#!/bin/bash

case "$OSTYPE" in
    linux*) OS="linux" ;;
    darwin*) OS="macos" ;;
    *) OS="unknown" ;;
esac
echo "Detected OS: $OS"

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"

# antidote
install_antidote() {
    local antidote_dir="${ZDOTDIR:-$HOME}/.antidote"
    if [[ ! -d "$antidote_dir" ]]; then
        echo "Installing Antidote..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_dir"
    fi
}

# stow
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

backup_configs() {
    echo "Backing up existing configurations to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    # backup entire dotfiles from $HOME
    cp -a "$DOTFILES_DIR" "$BACKUP_DIR/"
}

remove_configs() {
    echo "Removing existing configurations..."

    local config_packages=("nvim" "wezterm" "kitty" "aerospace" "espanso")
    for package in "${config_packages[@]}"; do
        case "$package" in
            espanso)
                if [[ "$OS" == "linux" ]]; then
                    rm -rf "$HOME/.config/espanso"
                elif [[ "$OS" == "macos" ]]; then
                    rm -rf "$HOME/Library/Application Support/espanso"
                fi
                ;;
            *)
                rm -rf "$HOME/.config/$package"
                ;;
        esac
    done

    local home_packages=("git" "zsh")
    for package in "${home_packages[@]}"; do
        rm -rf "$HOME/.$package"
    done

    # remove individual files
    rm -f "$HOME/.gitconfig" "$HOME/.gitignore_global"
    rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.zshenv"
    # remove Antidote plugins file
    rm -f "$HOME/.zsh/antidote.zsh_plugins.zsh"
}

stow_configs() {
    echo "Stowing configurations..."
    local config_packages=("nvim" "wezterm" "kitty" "aerospace" "espanso")
    local home_packages=("git" "zsh")

    for package in "${config_packages[@]}"; do
        if [[ "$package" == "espanso" ]]; then
            if [[ "$OS" == "linux" ]]; then
                target="$HOME/.config"
            elif [[ "$OS" == "macos" ]]; then
                mkdir -p "$HOME/Library/Application Support/espanso"
                target="$HOME/Library/Application Support/espanso"
            else
                echo "Unsupported OS for Espanso configuration."
                continue
            fi
            source_dir="$DOTFILES_DIR/espanso/.config"
            stow --dir="$source_dir" --target="$target" --restow "espanso"
            echo "Stowed $package to $target"
        else
            target="$HOME"
            stow --dir="$DOTFILES_DIR" --target="$target" --restow "$package"
            echo "Stowed $package to $target"
        fi
    done

    for package in "${home_packages[@]}"; do
        stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$package"
        echo "Stowed $package to $HOME"
    done
}

setup_linux_configs() {
    echo "Configuring Linux-specific settings..."

    # keyd configuration
    if [ -d "/etc/keyd" ]; then
        sudo cp -a "/etc/keyd" "$BACKUP_DIR/"
        sudo rm -rf "/etc/keyd"
        sudo stow --dir="$DOTFILES_DIR" --target="/etc/keyd" --restow keyd
        echo "Stowed keyd configuration to /etc/keyd"
    else
        echo "Keyd directory not found. Skipping keyd configuration."
    fi
}

setup_macos_configs() {
    echo "Configuring macOS-specific settings..."
}

setup_shopify_configs() {
    if [ -n "$SPIN" ]; then
        if [ ! -d "$DOTFILES_DIR/shopify-dotfiles" ]; then
            echo "Adding Shopify configurations..."
            git subtree add --prefix=shopify-dotfiles git@github.com:Shopify/dotfiles.git zakwarsame_ --squash
        fi

        if [ -f "$DOTFILES_DIR/shopify-dotfiles/install.sh" ]; then
            source "$DOTFILES_DIR/shopify-dotfiles/install.sh"
        fi

        # link neovim configuration
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

    #zoxide
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    cd "$DOTFILES_DIR" || exit

    backup_configs
    remove_configs
    stow_configs

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
