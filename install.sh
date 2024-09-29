#!/bin/bash

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Detect OS
$OS=$(detect_os)

echo "OS: $OS"

# Install the antidote plugin/theme manager if it's not already installed.
if [[ ! -d $HOME/antidote ]]; then
	echo -e "Antidote not found, installing..."
	cd $HOME
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
	cd -
fi

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"


install_stow() {
    if ! command -v stow &> /dev/null; then
        echo "Stow not found. Installing..."
        if [ "$OS" == "linux" ]; then
            sudo apt-get update && sudo apt-get install -y stow
        elif [ "$OS" == "macos" ]; then
            brew install stow
        else
            echo "Unable to install stow. Please install it manually."
            exit 1
        fi
    fi
}

backup_config() {
    if [ -e "$1" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$1" "$BACKUP_DIR/"
        echo "Backed up $1 to $BACKUP_DIR/"
    fi
}

stow_config() {
    local target="$1"
    local package="$2"
    local stow_dir="$3"

    if [ -e "$target/.zshrc" ]; then
        backup_config "$target/.zshrc"
    fi
    if [ -e "$target/headers.txt" ]; then
        backup_config "$target/headers.txt"
    fi


    mkdir -p "$target"
    # stow --verbose --target="$target" --dir="$stow_dir" "$package"
    stow --target="$target" --dir="$stow_dir" "$package"
    echo "Stowed $package to $target"
}

# Backup and stow common configs
setup_common_configs() {
    local config_packages=("nvim" "wezterm" "kitty" "espanso" "aerospace")

    for package in "${config_packages[@]}"; do
        backup_config "$CONFIG_DIR/$package"
        stow_config "$HOME" "$package" "$DOTFILES_DIR"
    done

    # Handle configs that go directly in the home directory
    local home_packages=("git" "zsh")
    for package in "${home_packages[@]}"; do
        stow_config "$HOME" "$package" "$DOTFILES_DIR"
    done

    # Delete antidote.zsh_plugins.zsh to ensure a new one is created (fixes path bug for linux vs mac)
    local antidote_plugins_file="$HOME/.zsh/antidote.zsh_plugins.zsh"
    if [ -f "$antidote_plugins_file" ]; then
        echo "Removing existing antidote.zsh_plugins.zsh file..."
        rm "$antidote_plugins_file"
    fi
}

setup_linux_configs() {
    echo "Configuring Linux-specific settings..."

    # Keyd configuration
    backup_config "/etc/keyd/default.conf"
    if [ -d "/etc/keyd" ]; then
        sudo stow -t /etc/keyd keyd
    else
        echo "Keyd directory not found. Skipping keyd configuration."
    fi

    # Espanso for Linux
    local espanso_dir="$HOME/.config"
    backup_config "$espanso_dir/espanso"
    stow_config "$espanso_dir" "espanso" "$DOTFILES_DIR"
}

setup_macos_configs() {
    echo "Configuring macOS-specific settings..."

    # Espanso for macOS
    local espanso_dir="$HOME/Library/Application Support"
    backup_config "$espanso_dir/espanso"
    stow_config "$espanso_dir" "espanso" "$DOTFILES_DIR"
}

main() {
    OS=$(detect_os)
    install_stow

    mkdir -p "$CONFIG_DIR"
    cd "$DOTFILES_DIR" || exit

    setup_common_configs

    case $OS in
        linux)
            setup_linux_configs
            ;;
        macos)
            setup_macos_configs
            ;;
        *)
            echo "Unknown OS. Skipping OS-specific configurations."
            ;;
    esac

    echo "Dotfiles installation complete!"
}

main

# shopify stuff
if [ -n "$SPIN" ]; then
  # Include shopify-dotfiles subtree
  if [ ! -d "$DOTFILES_DIR/shopify-dotfiles" ]; then
    echo "Adding Shopify configurations..."
    git subtree add --prefix=shopify-dotfiles git@github.com:Shopify/dotfiles.git zakwarsame --squash
  fi

  # Run Shopify-specific install scripts if they exist
  if [ -f "$DOTFILES_DIR/shopify-dotfiles/install.sh" ]; then
    source "$DOTFILES_DIR/shopify-dotfiles/install.sh"
  fi
  
  # link lua file
    ln -sf "$HOME/shopify-dotfiles/shopify_config.lua" "$HOME/.config/nvim/lua/custom/shopify_config.lua"

fi
