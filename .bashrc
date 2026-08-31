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
alias mkdire='function _mkdire() { mkdir -p "$1" && jump "$1"; }; _mkdire'
alias svim='sudoedit'
alias py='python'
alias grep='rg'

# Overrides
alias free='free -h'
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias vi='nvim'
alias vim='nvim'
alias ls='ls --color=auto --group-directories-first'
alias sudoedit='function _sudoedit() { sudo -e "$1"; }; _sudoedit'
alias cd='z'

function jump {
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
    branch=$(git symbolic-ref --short -q HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
      echo "($branch)"
    else
      echo "(empty repo)"
    fi
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

# Check if rust is installed, and if so, initialize it's environment.
if [ -r "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# shellcheck shell=bash

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
__zoxide_oldpwd="$(__zoxide_pwd)"

function __zoxide_hook() {
    \builtin local -r retval="$?"
    \builtin local pwd_tmp
    pwd_tmp="$(__zoxide_pwd)"
    if [[ ${__zoxide_oldpwd} != "${pwd_tmp}" ]]; then
        __zoxide_oldpwd="${pwd_tmp}"
        \command zoxide add -- "${__zoxide_oldpwd}"
    fi
    return "${retval}"
}

# Initialize hook.
if [[ ${PROMPT_COMMAND:=} != *'__zoxide_hook'* ]]; then
    PROMPT_COMMAND="__zoxide_hook;${PROMPT_COMMAND#;}"
fi

# Report common issues.
function __zoxide_doctor() {
    [[ ${_ZO_DOCTOR:-1} -eq 0 ]] && return 0
    # shellcheck disable=SC2199
    [[ ${PROMPT_COMMAND[@]:-} == *'__zoxide_hook'* ]] && return 0
    # shellcheck disable=SC2199
    [[ ${__vsc_original_prompt_command[@]:-} == *'__zoxide_hook'* ]] && return 0

    _ZO_DOCTOR=0
    \builtin printf '%s\n' \
        'zoxide: detected a possible configuration issue.' \
        'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.bashrc).' \
        '' \
        'If the issue persists, consider filing an issue at:' \
        'https://github.com/ajeetdsouza/zoxide/issues' \
        '' \
        'Disable this message by setting _ZO_DOCTOR=0.' \
        '' >&2
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    __zoxide_doctor

    # shellcheck disable=SC2199
    if [[ $# -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ $# -eq 1 && $1 == '-' ]]; then
        __zoxide_cd "${OLDPWD}"
    elif [[ $# -eq 1 && -d $1 ]]; then
        __zoxide_cd "$1"
    elif [[ $# -eq 2 && $1 == '--' ]]; then
        __zoxide_cd "$2"
    elif [[ ${@: -1} == "${__zoxide_z_prefix}"?* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@: -1}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    __zoxide_doctor
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin unalias z &>/dev/null || \builtin true
function z() {
    __zoxide_z "$@" && l
}

\builtin unalias zi &>/dev/null || \builtin true
function zi() {
    __zoxide_zi "$@" && l
}

# Load completions.
# - Bash 4.4+ is required to use `@Q`.
# - Completions require line editing. Since Bash supports only two modes of
#   line editing (`vim` and `emacs`), we check if either them is enabled.
# - Completions don't work on `dumb` terminals.
if [[ ${BASH_VERSINFO[0]:-0} -eq 4 && ${BASH_VERSINFO[1]:-0} -ge 4 || ${BASH_VERSINFO[0]:-0} -ge 5 ]] &&
    [[ :"${SHELLOPTS}": =~ :(vi|emacs): && ${TERM} != 'dumb' ]]; then

    function __zoxide_z_complete_helper() {
        READLINE_LINE="z ${__zoxide_result@Q}"
        READLINE_POINT=${#READLINE_LINE}
        bind '"\e[0n": accept-line'
        \builtin printf '\e[5n' >/dev/tty
    }

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        [[ ${#COMP_WORDS[@]} -eq $((COMP_CWORD + 1)) ]] || return

        # If there is only one argument, use `cd` completions.
        if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
            \builtin mapfile -t COMPREPLY < <(
                \builtin compgen -A directory -- "${COMP_WORDS[-1]}" || \builtin true
            )
        # If there is a space after the last word, use interactive selection.
        elif [[ -z ${COMP_WORDS[-1]} ]]; then
            # shellcheck disable=SC2312
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- "${COMP_WORDS[@]:1:${#COMP_WORDS[@]}-2}")" && {
                # In case the terminal does not respond to \e[5n or another
                # mechanism steals the response, it is still worth completing
                # the directory in the command line.
                COMPREPLY=("${__zoxide_z_prefix}${__zoxide_result}/")

                # Note: We here call "bind" without prefixing "\builtin" to be
                # compatible with frameworks like ble.sh, which emulates Bash's
                # builtin "bind".
                bind -x '"\e[0n": __zoxide_z_complete_helper'
                \builtin printf '\e[5n' >/dev/tty
            }
        fi
    }

    \builtin complete -F __zoxide_z_complete -o filenames -- z
    \builtin complete -r zi &>/dev/null || \builtin true
fi

# Startup commands
fastfetch
l
