#!/bin/bash

# Detect OS
detect_os() {
    case "$OSTYPE" in
        linux*) OS="linux" ;;
        darwin*) OS="macos" ;;
        *) OS="unknown" ;;
    esac
    echo "Detected OS: $OS"
}

detect_os

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# antidote
install_antidote() {
    local antidote_dir="${ZDOTDIR:-$HOME}/.antidote"
    if [[ ! -d "$antidote_dir" ]]; then
        echo "Installing Antidote..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_dir"
    fi
}

# GNU stow
install_stow() {
    if ! command -v stow &>/dev/null; then
        echo "Installing GNU Stow..."
        if [[ "$OS" == "linux" ]]; then
            sudo apt-get update && sudo apt-get install -y stow
        elif [[ "$OS" == "macos" ]]; then
            brew install stow
        else
            echo "Unsupported OS for automatic Stow installation."
            exit 1
        fi
    fi
}

backup_config() {
    local target="$1"
    if [ -e "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        echo "Backed up $target to $BACKUP_DIR/"
    fi
}

# Stow configurations with OS-specific handling
stow_config() {
    local target="$1"
    local package="$2"

    case "$package" in
        espanso)
            if [[ "$OS" == "linux" ]]; then
                target="$HOME/.config"
            elif [[ "$OS" == "macos" ]]; then
                target="$HOME/Library/Application Support"
            else
                echo "Unsupported OS for Espanso configuration."
                return
            fi
            ;;
        *)
            target="$1"
            ;;
    esac

    mkdir -p "$target"
    stow --dir="$DOTFILES_DIR" --target="$target" "$package"
    echo "Stowed $package to $target"
}

setup_common_configs() {
    local config_packages=("nvim" "wezterm" "kitty" "aerospace" "espanso")
    local home_packages=("git" "zsh")

    for package in "${config_packages[@]}"; do
        backup_config "$CONFIG_DIR/$package"
        # For config packages, stow to $HOME instead of $CONFIG_DIR
        stow_config "$HOME" "$package"
    done

    for package in "${home_packages[@]}"; do
        backup_config "$HOME/.$package"
        stow_config "$HOME" "$package"
    done

    # Remove existing Antidote plugin - caused bugs b4
    local antidote_plugins_file="$HOME/.zsh/antidote.zsh_plugins.zsh"
    if [ -f "$antidote_plugins_file" ]; then
        echo "Removing existing Antidote plugins file..."
        rm "$antidote_plugins_file"
    fi
}

# Linux-specific
setup_linux_configs() {
    echo "Configuring Linux-specific settings..."

    # Keyd configuration
    if [ -d "/etc/keyd" ]; then
        backup_config "/etc/keyd/default.conf"
        sudo stow --target=/etc/keyd --dir="$DOTFILES_DIR" keyd
    else
        echo "Keyd directory not found. Skipping keyd configuration."
    fi
}

# Configure macOS-specific settings
setup_macos_configs() {
    echo "Configuring macOS-specific settings..."
}

setup_shopify_configs() {
    if [ -n "$SPIN" ]; then
        if [ ! -d "$DOTFILES_DIR/shopify-dotfiles" ]; then
            echo "Adding Shopify configurations..."
            git subtree add --prefix=shopify-dotfiles git@github.com:Shopify/dotfiles.git zakwarsame_ --squash
        fi

        # Run Shopify-specific install script if it exists
        if [ -f "$DOTFILES_DIR/shopify-dotfiles/install.sh" ]; then
            source "$DOTFILES_DIR/shopify-dotfiles/install.sh"
        fi

        # Link Neovim configuration
        ln -sf "$DOTFILES_DIR/shopify-dotfiles/shopify_config.lua" "$HOME/.config/nvim/lua/custom/shopify_config.lua"

        setup_shopify_espanso
    fi
}

setup_shopify_espanso() {
    echo "Setting up Shopify Espanso configurations..."

    if [[ "$OS" == "linux" ]]; then
        espanso_dir="$HOME/.config/espanso/match"
    elif [[ "$OS" == "macos" ]]; then
        espanso_dir="$HOME/Library/Application Support/espanso/match"
    else
        echo "Unsupported OS for Shopify Espanso configuration."
        return
    fi

    mkdir -p "$espanso_dir"
    cp "$DOTFILES_DIR/shopify-dotfiles/match/shopify.yml" "$espanso_dir/"
    echo "Shopify Espanso configurations updated."
}

main() {
    install_antidote
    install_stow

    cd "$DOTFILES_DIR" || exit

    setup_common_configs

    if [[ "$OS" == "linux" ]]; then
        setup_linux_configs
    elif [[ "$OS" == "macos" ]]; then
        setup_macos_configs
    else
        echo "Unsupported OS for OS-specific configurations."
    fi

    setup_shopify_configs

    echo "Dotfiles installation complete!"
}

main
