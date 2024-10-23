#!/bin/bash

### Bash ###
export BASH_SILENCE_DEPRECATION_WARNING=1

### if running bash ###
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

### set PATH so it includes user's bin if it exists ###
if [ -d "$HOME/bin" ]; then
  if ! echo "$PATH" | grep --quiet "$HOME/bin"; then
    export PATH="$HOME/bin:$PATH"
  fi
fi

### set PATH so it includes user's private bin if it exists ###
if [ -d "$HOME/.local/bin" ]; then
  if ! echo "$PATH" | grep --quiet "$HOME/.local/bin"; then
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

### welcome messages ###
echo -e Welcome to "\033[1;32m$(hostname)\033[0;39m", it\'s "\033[1;32m$(date "+%Y/%m/%d")\033[0;39m" today, "\033[1;32m$(date "+%H:%M:%S")\033[0;39m" now.

### check and update dotfiles ###
# shellcheck source=$HOME/dotfiles/check_update_dotfiles.sh disable=SC1090
source "$HOME/dotfiles/check_update_dotfiles.sh"

### Git ###
if [ -f $HOME/.git-completion.bash ]; then
  # shellcheck source=/Users/kobayashishun/.git-completion.bash
  source $HOME/.git-completion.bash
fi
if [ -f $HOME/.git-prompt.sh ]; then
  export GIT_PS1_SHOWDIRTYSTATE=true
  # shellcheck source=/Users/kobayashishun/.git-prompt.sh
  source $HOME/.git-prompt.sh
fi

### Java ###
export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
#JAVA_HOME=$(/usr/libexec/java_home -v "17")
#JAVA_HOME=$(/usr/libexec/java_home -v "18")
#JAVA_HOME=$(/usr/libexec/java_home -v "20")
#export JAVA_HOME

### Go ###
if [ -d /usr/local/go/bin ]; then
  export GO_HOME="/usr/local/go"
  if ! echo "$PATH" | grep --quiet "$GO_HOME"; then
    export PATH=$PATH:"$GO_HOME/bin"
  fi
fi

if [ -d "$HOME"/go ]; then
  export PATH=$PATH:"$HOME/go/bin"
fi

### Rust ###
if [ -d "$HOME"/.cargo ]; then
  export CARGO_HOME=$HOME/.cargo
  if ! echo "$PATH" | grep --quiet "$CARGO_HOME"; then
    source "$CARGO_HOME/env"
  fi
fi

### Python ###
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"

### JavaScript ###
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  echo "$PATH" | grep --quiet "$NVM_DIR"
  if [ ! $? == 0 ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi
fi

### Clang ###
TARGET="/usr/local/checker/bin"
if [ -d "$TARGET" ]; then
  if ! echo "$PATH" | grep --quiet "$TARGET"; then
    PATH=$PATH:$TARGET
  fi
fi
unset TARGET

### Apache Ant ###
if [ -d "/usr/local/ant" ]; then
  export ANT_HOME="/usr/local/ant"
  if ! echo "$PATH" | grep --quiet "$ANT_HOME/bin"; then
    PATH=$PATH:$ANT_HOME/bin
  fi
  export ANT_OPTS="-Dfile.encoding=UTF-8 -Xmx512m -Xss256k"
fi

### Clang Static Analyzer ###
if ! echo "$PATH" | grep --quiet "/usr/local/checker/bin"; then
  PATH=$PATH:/usr/local/checker/bin
fi

### Homebrew ###
eval "$(/opt/homebrew/bin/brew shellenv)"
if [ -e "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  source "$(brew --prefix)"/etc/profile.d/bash_completion.sh
fi

alias k=kubectl
complete -F __start_kubectl k

### Podman ###
# Specify the location of the non-constant source
# shellcheck source=/dev/stdin
source <(podman completion bash)
export KIND_EXPERIMENTAL_PROVIDER=podman

source /opt/homebrew/etc/profile.d/z.sh
