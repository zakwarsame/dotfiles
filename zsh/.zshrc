# This script is the entrypoint for all shell environment config.

echo "Running install.sh"
export DOTFILES_DIRECTORY_NAME="dotfiles"
export DF_HOME=~/$DOTFILES_DIRECTORY_NAME
export DF_ZSH=$DF_HOME/zsh

# Create common color functions.
autoload -U colors
colors

# Set up custom environment variables
source $DF_ZSH/environment.zsh

# set up custom env secrets
source $DF_ZSH/environment.secrets.zsh

# Load configs for MacOS. Does nothing if not on MacOS
if [ "$ZSH_HOST_OS" = "darwin" ]; then
  source $DF_ZSH/macos.zsh
fi

# Load configs for Linux
if [ "$ZSH_HOST_OS" = "linux" ]; then
  if [ -e $DF_ZSH/linux.zsh ]; then
    source $DF_ZSH/linux.zsh
  fi
fi

# Load zsh plugins via antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load $DF_ZSH/antidote.zsh_plugins.txt

source $DF_ZSH/utils.zsh


source $DF_ZSH/filter_history.zsh
source $DF_ZSH/custom.zsh

# ruby version manager
[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# shopify stuff
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

if [ -n "$SPIN" ] && [ -d "$DF_HOME/shopify-dotfiles" ]; then
  source "$DF_HOME/shopify-dotfiles/shopify.zsh"
fi

function su() {
    local service=${1%%:*}
    spin up $1 --wait -n $2 -c $service.branch=${3:-main}
}
