#!/bin/bash

### z ###
source /opt/homebrew/etc/profile.d/z.sh

### Git ###
if [ -f "${HOME}/.git-completion.bash" ]; then
  # shellcheck source="${HOME}/.git-completion.bash"
  source "${HOME}/.git-completion.bash"
fi
if [ -f "${HOME}/.git-prompt.sh" ]; then
  export GIT_PS1_SHOWDIRTYSTATE=true
  # shellcheck source="${HOME}/.git-completion.bash"
  source "${HOME}/.git-prompt.sh"
fi

### Python ###
source <(uv --generate-shell-completion bash)
source <(uvx --generate-shell-completion bash)

### Homebrew ###
eval "$(/opt/homebrew/bin/brew shellenv)"
if [ -e "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  # shellcheck source="$(brew --prefix)/etc/profile.d/bash_completion.sh"
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

### kubectl ###
alias k=kubectl
complete -F __start_kubectl k
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"

### Podman ###
# Specify the location of the non-constant source
# shellcheck source=/dev/stdin
source <(podman completion bash)
#export KIND_EXPERIMENTAL_PROVIDER=podman

### default:cyan / root:red ###
if [ $UID -eq 0 ]; then
  PS1='\[\e[1;31m\]\u@\h \[\e[1;31m\]\t \[\e[1;31m\]\W\n\[\e[1;31m\]\$ '
else
  PS1='\[\e[1;36m\]\u@\h \[\e[1;32m\]\t \[\e[1;33m\]\W \[\e[1;32m\]$(__git_ps1 " (%s)")$(kube_ps1)\n\[\e[1;0m\]\$ '
fi

alias path='echo ${PATH} | tr ":" "\n"'

# refine command execution history with "fzf"
select-history() {
  READLINE_LINE="$(HISTTIMEFORMAT='' history | awk '{c="";for(i=2;i<=NF;i++) c=c $i" "; print c}' | fzf --query "$READLINE_LINE")"
  READLINE_POINT=$#READLINE_LINE
}
bind -x '"\C-r": select-history'

# select target in .ssh/config with "ssh"
function sshs {
  target=$(cat ~/.ssh/config | grep 'Host ' | cut -f2 -d' ' | fzf --preview "cat ~/.ssh/config | sed -ne '/^Host {}$/,/^\s*$/p'")
  if [ -n "$target" ]; then
    ssh "$target"
  fi
}

# GUI selection from multiple targets with "make"
function makes {
  target=$(cat Makefile | grep '.PHONY: ' | cut -f2- -d' ' | tr ' ' '\n' | fzf --preview "cat Makefile | sed -ne '/^{}:$/,/^\s*$/p'")
  if [ -n "$target" ]; then
    make "$target"
  fi
}


