#!/bin/bash

### default:cyan / root:red ###
if [ $UID -eq 0 ]; then
    PS1='\[\e[1;31m\]\u@\h \[\e[1;31m\]\t \[\e[1;31m\]\W\n\[\e[1;31m\]\$ '
else
    PS1='\[\e[1;36m\]\u@\h \[\e[1;32m\]\t \[\e[1;33m\]\W \[\e[1;32m\]$(__git_ps1 " (%s)")\n\[\e[1;0m\]\$ '
fi

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
