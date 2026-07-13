# Only run in interactive shells.
[[ -o interactive ]] || return

path_prepend() {
  [ -d "$1" ] || return
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_prepend "/Library/TeX/texbin"
path_prepend "/opt/homebrew/opt/python@3.11/libexec/bin"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

# History.
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Prompt.
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

# Editor.
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias vi='nvim'
  alias vim='nvim'
else
  export EDITOR="${EDITOR:-vim}"
  export VISUAL="${VISUAL:-vim}"
fi

# Color support.
case "$(uname -s)" in
  Darwin)
    alias ls='ls -G -h'
    alias l='ls -G -h'
    alias ll='ls -alhG'
    alias la='ls -alhG'
    ;;
  *)
    if command -v dircolors >/dev/null 2>&1; then
      eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
    fi
    alias ls='ls -h --color=auto'
    alias l='ls -h --color=auto'
    alias ll='ls -alh --group-directories-first --color=auto'
    alias la='ls -alh --color=auto'
    ;;
esac

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias lt='ls -ltr'
alias tree='tree -Csuh'

# Safer core utils.
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Misc aliases.
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias path='printf "%s\n" ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -h'
alias brc='$EDITOR ~/.bashrc'
alias zrc='$EDITOR ~/.zshrc'
alias tmuxrc='$EDITOR ~/.tmux.conf'
alias nvimrc='$EDITOR ~/.config/nvim/init.lua'

# less setup.
export PAGER=less
export LESSCHARSET='utf-8'
export LESS='-i -N -w -z-4 -g -e -M -X -F -R'
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# Provide macOS-like `open` on Linux only.
if [ "$(uname -s)" != "Darwin" ] && command -v xdg-open >/dev/null 2>&1; then
  open() {
    command xdg-open "$@" >/dev/null 2>&1 &
  }
fi

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

ssh() {
  command ssh "$@"
  printf '\e[?1000l\e[?1002l\e[?1006l'
}

# Machine-local secrets and private overrides. This file is intentionally untracked.
[ -r "$HOME/.extra" ] && source "$HOME/.extra"
