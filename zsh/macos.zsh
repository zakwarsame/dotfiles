# Custom configs for MacOS environments.
# This file will only be executed if the current environment is MacOS.


# Aliases
alias stfu="osascript -e 'set volume output muted true'"
alias flushdns="dscacheutil -flushcache"
alias keeptalking="osascript -e 'set volume output muted false'"

#The step values that correspond to the sliders on the GUI are as follow (lower equals faster):
#KeyRepeat: 120, 90, 60, 30, 12, 6, 2
#InitialKeyRepeat: 120, 94, 68, 35, 25, 15
#ref: https://apple.stackexchange.com/questions/261163/default-value-for-nsglobaldomain-initialkeyrepeat

# Faster keyboard repeat rate. The defaults available are so slow and it takes ages to delete a lot of text.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

DOTFILES_DIRECTORY_NAME="dotfiles"
DF_ZSH=~/$DOTFILES_DIRECTORY_NAME/zsh

# update wallpaper - (sonoma broke normal `wal -i` command)
setwallpaper() {
    # Run the AppleScript and capture the selected image path
    IMAGE_PATH=$(osascript $DF_ZSH/wallpaper_script.applescript)

    # Check if an image was selected
    if [ "$IMAGE_PATH" = "No file selected" ]; then
        echo "No image selected or AppleScript did not return a path."
    fi
}

# set kitty config directory to dotfiles
launchctl setenv KITTY_CONFIG_DIRECTORY ~/$DOTFILES_DIRECTORY_NAME/kitty/.config/kitty
# set zellij config directory to dotfiles
launchctl setenv ZELLIJ_CONFIG_DIR ~/$DOTFILES_DIRECTORY_NAME/zellij/.config/zellij
export EDITOR=nvim


# from core/macos.zsh
#Environment variables
source ~/.dotfile_brew_setup

# Assumes that coreutils and other GNU tools have replaced OSX'
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
export PATH="${PATH}:~/.local/lib/python3.9/site-packages"

# Faster keyboard repeat rate. The defaults available are so slow and it takes ages to delete a lot of text.
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12

eval "$(zoxide init zsh)"

# Show hidden files in finder. I want to see everything.
defaults write com.apple.finder AppleShowAllFiles YES
export MYOS=macos
