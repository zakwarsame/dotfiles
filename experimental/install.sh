
# Custom actions to take on initial install of dotfiles.
# This runs after default install actions- overwrites those.

echo "Experimental install.sh"

DOTFILES_DIRECTORY_NAME="dotfiles"
DF_EXP=~/$DOTFILES_DIRECTORY_NAME/experimental


# espanso config
case $OS in
  darwin*)

    # # Install Neovim
    # echo "Enter the version of Neovim to install (or 'n' for nightly):"
    # read version
    #
    # if [[ "$version" == "n" ]] || [[ -z "$version" ]]; then
    #     brew install --HEAD neovim
    # else
    #     brew install neovim@$version
    # fi

    echo "Neovim installed successfully."
;;
esac

# linux
case $OS in
  linux*)

    # nvim setup
    # echo "Enter the version of Neovim to install (or 'n' for nightly):"
    # read version
    #
    # if [[ "$version" == "n" ]] || [[ -z "$version" ]]; then
    #     version="nightly"
    # fi
    #
    # echo "Installing Neovim version $version..."
    # wget "https://github.com/neovim/neovim/releases/download/$version/nvim.appimage" -O ~/nvim.appimage && chmod u+x ~/nvim.appimage
    #
    # if ~/nvim.appimage --appimage-extract; then
    #     extraction_dir=$(pwd)/squashfs-root
    #     if [ -d "$extraction_dir" ]; then
    #         sudo mv "$extraction_dir" /nvim-root
    #         target_dir=/nvim-root
    #     else
    #         echo "Failed to extract Neovim. The squashfs-root directory does not exist."
    #         exit 1
    #     fi
    # else
    #     echo "Failed to download or extract Neovim."
    #     exit 1
    # fi

    sudo rm -f /usr/local/bin/nvim
    sudo ln -s $target_dir/usr/bin/nvim /usr/local/bin/nvim
    echo "Neovim installed successfully."
;;
esac
