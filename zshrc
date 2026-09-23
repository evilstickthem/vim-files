# ~/.zshrc — symlinked from ~/src/vim-files/zshrc by install.sh.
# Secrets and machine-specific settings go in ~/.zshrc.local (not in git).

export DOTFILES="${DOTFILES:-$HOME/src/vim-files}"
export PATH="$HOME/.local/bin:$PATH"

# --- oh-my-zsh -----------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""                       # prompt comes from starship, below
zstyle ':omz:update' mode reminder
plugins=(git fzf zoxide direnv)
[[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh   # optional on remote boxes

# --- history -------------------------------------------------------------------
HISTSIZE=200000
SAVEHIST=200000
setopt EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# --- environment ---------------------------------------------------------------
export EDITOR=vim VISUAL=vim
export ANDROID_HOME=$HOME/Library/Android/sdk
[[ -d $ANDROID_HOME ]] && export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

export PATH=/Library/PostgreSQL/15/bin:$PATH
[[ -d /opt/homebrew/opt/postgresql@15/bin ]] && export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH

# fzf: use fd, include dotfiles, skip .git; preview with bat
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"

# --- aliases / functions -------------------------------------------------------
[[ -r $DOTFILES/zsh/aliases.zsh ]] && source $DOTFILES/zsh/aliases.zsh

# --- iTerm2 shell integration (marks, cmd-shift-up/down between prompts) ------
# Skipped inside tmux, where it confuses prompt redraws.
if [[ $TERM_PROGRAM == iTerm.app && -z $TMUX ]]; then
  _it2=/Applications/iTerm.app/Contents/Resources/iterm2_shell_integration.zsh
  [[ -r $_it2 ]] && source $_it2
  unset _it2
fi

# --- local overrides + secrets -------------------------------------------------
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# --- prompt + interactive plugins (keep last) ---------------------------------
command -v starship >/dev/null && eval "$(starship init zsh)"
for _p in zsh-autosuggestions zsh-syntax-highlighting; do
  for _d in /opt/homebrew/share /usr/local/share /usr/share; do
    [[ -r $_d/$_p/$_p.zsh ]] && { source $_d/$_p/$_p.zsh; break; }
  done
done
unset _p _d
