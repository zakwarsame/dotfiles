DOTFILES_DIRECTORY_NAME="dotfiles"
DF_ZSH=~/$DOTFILES_DIRECTORY_NAME/zsh

# pokemon colorscripts
# if [ -e /usr/local/bin/pokemon-colorscripts ]; then
#   pokemon-colorscripts --no-title -s -r
# fi

# eval $(dircolors $DF_ZSH/dircolors)
alias ls='ls --color=auto'

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

typeset -A ZSH_HIGHLIGHT_STYLES

# alias stuff
alias setup='cart insert unified-index-tables && ~/.data/cartridges/unified-index-tables/setup.sh'
alias services='cart insert services && chmod +x ~/.data/cartridges/services/update_services.sh && ~/.data/cartridges/services/update_services.sh'

# list of prs that are currently open by me and not archived
alias prs='gh pr list --author "@me" --state OPEN --search "is:pr archived:false"'

# choose a pr from the list of open prs
alias pr='gh pr list --author "@me" --state OPEN --search "is:pr archived:false" | fzf | awk "{print \$1}" | xargs gh pr view --web'

# git fixum
alias gcf='git commit --fixup "$(git log --oneline | fzf --no-sort | awk "{print \$1}")"'

alias refresh='dev reup && dev restart --all'
#
# shopify
alias dcw='dev cd admin-web'
alias dcs='dev cd shopify'
alias dcl='dev clone web//admin-web'
alias dc='dev claude'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f $DF_ZSH/.p10k.zsh ]] || source $DF_ZSH/.p10k.zsh

# fzf stuff
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
# zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# eza
alias l="eza --color=always --icons=always --group-directories-first --long --git --all"

# zellij
alias zap="zellij a proxy"
alias zaw="zellij a web"
alias zas="zellij a shop"
alias ze="zellij"

# editor
export EDITOR=nvim

# Key bindings
# Up/down arrow for history search
bindkey '\eOA' history-beginning-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\eOB' history-beginning-search-forward
bindkey '\e[B' history-beginning-search-forward

# Let Tab perform normal completion
# bindkey '^I' autosuggest-accept  # Commented out to restore default Tab behavior

# Use Ctrl+e to accept suggestions (end of line key)
bindkey '^e' autosuggest-accept

# Autosuggestion settings
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Helper functions for Neovim remote control
nvr() {
  local socket="/tmp/nvim"
  local cmd="$1"
  shift

  case "$cmd" in
    "expr")
      nvim --remote-expr "$1" --server "$socket"
      ;;
    "send")
      nvim --remote-send "$1" --server "$socket"
      ;;
    "current-file")
      nvim --remote-expr 'expand("%:p")' --server "$socket"
      ;;
    "visual-text")
      # First yank the visually selected text, then retrieve it from register 0
      nvim --remote-send 'y' --server "$socket" > /dev/null
      nvim --remote-expr 'getreg("0")' --server "$socket"
      ;;
    "mode")
      nvim --remote-expr 'mode()' --server "$socket"
      ;;
    *)
      echo "Unknown command: $cmd"
      echo "Available commands: expr, send, current-file, visual-text, mode"
      return 1
      ;;
  esac
}

# Use default template with llm chat
function llm() {
  if [[ "$1" == "chat" ]]; then
    shift
    command llm chat -t default "$@"
  else
    command llm "$@"
  fi
}

