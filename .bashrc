# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# Aliasses
alias l='ls -CF'
alias la='ls -AlCF'
alias ll='ls -AlFsh'
alias lsd='ll | grep'
alias cls='clear'
alias bashrc='nvim $HOME/.bashrc'
alias rldbash='source $HOME/.bashrc'
alias cd-='cd -'
alias cd..='cd ..'
alias ..='cd ..'
alias mkdire='function _mkdire() { mkdir -p "$1" && cd "$1"; }; _mkdire'
alias svim='sudoedit'
alias py='python'

# Overrides
alias free='free -h'
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias vi='nvim'
alias vim='nvim'
alias ls='ls --color=auto --group-directories-first'
alias sudoedit='function _sudoedit() { sudo -e "$1"; }; _sudoedit'

function cd {
  builtin cd "$@" && l
}

function dnf {
  if command -v dnf5 &>/dev/null; then
    command dnf5 "$@"
  else
    command dnf "$@"
  fi
}

# Completion improvements
bind 'set completion-ignore-case on'

# History settings
export HISTFILESIZE=20000
export HISTSIZE=10000
shopt -s histappend
shopt -s cmdhist
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"

# Window improvements
shopt -s checkwinsize

# Set default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim

# Custom function to get the current Git branch
function __current_git_branch {
  # Check if the current directory is inside a Git repository
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the current branch name
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo "($branch)"
  fi
}

# Beautify console
function __setprompt {
  local BLUE="\[\033[0;96m\]"
  local GREEN="\[\033[0;92m\]"
  local MAGENTA="\[\033[0;95m\]"
  local YELLOW="\[\033[0;33m\]"
  local RED="\[\033[0;91m\]"
  local NO_COLOUR="\[\033[0m\]"
  local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
  local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
  if [ $SSH2_IP ] || [ $SSH_IP ] ; then
    local SSH_FLAG="@\h"
  fi
  PS1="$BLUE[\$(date +%H:%M)]$GREEN[\u$SSH_FLAG:$MAGENTA\w$GREEN]$YELLOW\$(__current_git_branch)$RED\$ $NO_COLOUR"
  PS2="$BLUE>$NO_COLOUR "
  PS4='$BLUE+$NO_COLOUR '
}
__setprompt

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Startup commands
fastfetch
l
. "$HOME/.cargo/env"
