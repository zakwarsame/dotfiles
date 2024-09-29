# Define custom environment variables.
# This will overwrite any environment variables defined by `core/environment.zsh`.


export ZSH_HOST_OS=$(uname | awk '{print tolower($0)}')

# Make sure we're saving our history to a file
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=1000
touch $HISTFILE
