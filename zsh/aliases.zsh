# Ported from bash/aliases + bash/functions. Sourced by ~/.zshrc.

# navigation
alias h='cd ~'
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
cs()  { cd "$@" && ls; }
mkd() { mkdir -p "$@" && cd "$@"; }
u()   { local n=${1:-1}; repeat $n cd ..; }

# listing / files
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias l='eza -alh --git --group-directories-first'
  alias lt='eza --tree --level=2 --git-ignore'
else
  alias l='ls -alh'
fi
command -v bat >/dev/null && alias cat='bat --paging=never --style=plain'
alias df='df -h'
fs() { if (( $# )); then du -sh -- "$@"; else du -sh .[^.]* * 2>/dev/null; fi; }

# git / search
alias get='git'
alias ack='rg'
diff() { git diff --no-index --color-words "$@"; }

# postgres (homebrew service)
alias pgstart='brew services start postgresql@15'
alias pgstop='brew services stop postgresql@15'
alias pgstatus='brew services info postgresql@15'

# shell
alias reload='exec zsh'
alias zshrc='${EDITOR:-vim} ~/.zshrc'

# tmux: attach to (or create) a named session; default "main"
t() { tmux new-session -A -s "${1:-main}"; }

# Add note to Notes.app.  Usage: `note 'foo'` or `echo 'foo' | note`
note() {
  local text body
  if [[ -t 0 ]]; then text="$1"; else text=$(cat); fi
  body=$(print -r -- "$text" | sed -E 's|$|<br>|g')
  osascript >/dev/null <<EOF
tell application "Notes"
  make new note at folder "Notes" with properties {name:"$text", body:"$body"}
end tell
EOF
}

# Add reminder to Reminders.app.  Usage: `remind 'foo'` or `echo 'foo' | remind`
remind() {
  local text
  if [[ -t 0 ]]; then text="$1"; else text=$(cat); fi
  osascript >/dev/null <<EOF
tell application "Reminders"
  tell the default list
    make new reminder with properties {name:"$text"}
  end tell
end tell
EOF
}
