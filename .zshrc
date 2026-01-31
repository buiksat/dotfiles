# Only run in interactive shells
[[ -o interactive ]] || return

# History
HISTSIZE=1000
SAVEHIST=2000          # zsh's equivalent of HISTFILESIZE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY   # like histappend in bash
setopt INC_APPEND_HISTORY

# Prompt (simple green user@host:cwd$)
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

# Color support for ls/grep (GNU-ish; tweak for mac if needed)
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# ls family
alias l='ls -h --color=auto'
alias ls='ls -h --color=auto'
alias lx='ls -lXB'
alias lk='ls -lSr'
alias lt='ls -ltr'
alias lc='ls -ltcr'
alias lu='ls -ltur'
alias ll='ls -alv --group-directories-first --color=auto'
alias lm='ll | less'
alias lr='ll -R'
alias la='ll -A'
alias tree='tree -Csuh'

# Safer core utils
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Misc aliases
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias path='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -kTh'
alias g++='g++ -Wall -W -Werror'
alias brc='vim ~/.bashrc'
alias vrc='vim ~/.vimrc'
alias sbrc='source ~/.bashrc'

# less setup (works in zsh too)
export PAGER=less
export LESSCHARSET='latin1'
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R'
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# Functions (bash style works fine in zsh in sh-compatible mode)
open() {
  xdg-open "$1" &!
}

lazygit() {
  git add -A
  git commit -a -m "$1"
  git pull
  git push
}

marekgit() {
  git commit -a -m "$1"
  git pull
  git push
}

# Python (Homebrew)
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
ssh() { command ssh "$@"; printf '\e[?1000l'; }

export PATH="/Library/TeX/texbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
