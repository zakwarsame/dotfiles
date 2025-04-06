#!/bin/bash

case "$OSTYPE" in
    linux*) OS="linux" ;;
    darwin*) OS="macos" ;;
    *) OS="unknown" ;;
esac
echo "Detected OS: $OS"

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"

install_antidote() {
    local antidote_dir="${ZDOTDIR:-$HOME}/.antidote"
    if [[ ! -d "$antidote_dir" ]]; then
        echo "Installing Antidote..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_dir"
    fi
}

install_brew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH based on platform
        if [[ "$(uname -m)" == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> $HOME/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi

        echo "Homebrew installed successfully!"
    else
        echo "Homebrew is already installed."
    fi

    # Install apps from the apps.txt file
    if [[ -f "$DOTFILES_DIR/brew/apps.txt" ]]; then
        echo "Found brew/apps.txt with packages to install."
        echo "Packages to install:"
        cat "$DOTFILES_DIR/brew/apps.txt"
        read -p "Would you like to install these packages? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing apps from brew/apps.txt..."
            xargs brew install < "$DOTFILES_DIR/brew/apps.txt"
        else
            echo "Skipping package installation."
        fi
    fi
}

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

    local config_packages=("nvim" "wezterm" "kitty" "aerospace" "espanso" "ghostty")
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
    rm -f "$HOME/.gitconfig" "$HOME/.gitconfig.local" "$HOME/.gitignore_global"
    rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.zshenv"
    # remove Antidote plugins file
    rm -f "$HOME/.zsh/antidote.zsh_plugins.zsh"
}

stow_configs() {
    echo "Stowing configurations..."
    local config_packages=("nvim" "wezterm" "kitty" "aerospace" "espanso" "ghostty")
    local home_packages=("git" "zsh")

    for package in "${config_packages[@]}"; do
        if [[ "$package" == "espanso" ]]; then
            if [[ "$OS" == "linux" ]]; then
                mkdir -p "$HOME/.config/espanso"
                target="$HOME/.config/espanso"
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
        elif [[ "$package" == "ghostty" ]]; then
            local ghostty_source_dir="$DOTFILES_DIR/ghostty/.config/ghostty"
            local ghostty_target_dir="$HOME/.config/ghostty"
            mkdir -p "$ghostty_target_dir"

            local ghostty_configs=("config")
            if [[ "$OS" == "linux" ]]; then
                ghostty_configs+=("config-linux")
            elif [[ "$OS" == "macos" ]]; then
                ghostty_configs+=("config-macos")
            fi

            for gc in "${ghostty_configs[@]}"; do
                if [[ -f "$ghostty_source_dir/$gc" ]]; then
                    # using symlinks instead of stow to simplify os-specific configs
                    ln -sf "$ghostty_source_dir/$gc" "$ghostty_target_dir/$gc"
                fi
            done

            echo "Linked ghostty configs to $ghostty_target_dir"
        else
            stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$package"
        fi
    done

    for package in "${home_packages[@]}"; do
        stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$package"
        echo "Stowed $package to $HOME"
    done
}

setup_linux_configs() {
    echo "Configuring Linux-specific settings..."

    if [ -f "/etc/keyd/default.conf" ]; then
        echo "Backing up existing /etc/keyd/default.conf to $BACKUP_DIR"
        sudo mkdir -p "$BACKUP_DIR/etc/keyd"
        sudo cp "/etc/keyd/default.conf" "$BACKUP_DIR/etc/keyd/"
    fi

    sudo rm -f "/etc/keyd/default.conf"
    sudo mkdir -p "/etc/keyd"

    sudo ln -s "$DOTFILES_DIR/keyd/default.conf" "/etc/keyd/default.conf"
    echo "Linked $DOTFILES_DIR/keyd/default.conf to /etc/keyd/default.conf"
}

setup_macos_configs() {
    echo "Configuring macOS-specific settings..."
    install_brew
    setup_nix_config

    chmod +x "$DOTFILES_DIR/kanata/setup.sh"
    source "$DOTFILES_DIR/kanata/setup.sh"
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

setup_nix_config() {
    echo "Setting up Nix configuration..."

    if ! command -v nix &> /dev/null; then
        echo "Nix is not installed. Please install Nix before proceeding."
        echo "Visit https://nixos.org/download.html for installation instructions."
    else
        local src_dir="$DOTFILES_DIR/nix/darwin/nix"
        local target_dir="$HOME/nix"

        if [ ! -d "$src_dir" ]; then
            echo "Nix config files not found in $src_dir."
            return
        fi

        mkdir -p "$target_dir"
        stow --dir="$src_dir" --target="$target_dir" --restow .
        echo "Nix config files symlinked to ~/nix (need to run 'darwin-rebuild switch' to apply changes)"
    fi
}

setup_editor_keybinds() {
    echo "Setting up editor keybindings..."

    local vscode_keybinds_dir
    local cursor_keybinds_dir

    if [[ "$OS" == "linux" ]]; then
        vscode_keybinds_dir="$HOME/.config/Code/User"
        cursor_keybinds_dir="$HOME/.config/Cursor/User"
    elif [[ "$OS" == "macos" ]]; then
        vscode_keybinds_dir="$HOME/Library/Application Support/Code/User"
        cursor_keybinds_dir="$HOME/Library/Application Support/Cursor/User"
    else
        echo "Unsupported OS for editor keybindings"
        return
    fi

    mkdir -p "$vscode_keybinds_dir"
    ln -sf "$DOTFILES_DIR/experimental/keybinds.json" "$vscode_keybinds_dir/keybindings.json"

    mkdir -p "$cursor_keybinds_dir"
    ln -sf "$DOTFILES_DIR/experimental/keybinds.json" "$cursor_keybinds_dir/keybindings.json"

    echo "Editor keybindings configured for $OS."
}

# added for spin reasons, remove if not needed
install_ghostty_ubuntu() {
    if [[ "$OS" == "linux" ]] && [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            echo "Installing Ghostty for Ubuntu..."
            GHOSTTY_DEB_URL=$(
                curl -s https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest | \
                grep -oP "https://github.com/mkasberg/ghostty-ubuntu/releases/download/[^\s/]+/ghostty_[^\s/_]+_amd64_${VERSION_ID}.deb"
            )
            GHOSTTY_DEB_FILE=$(basename "$GHOSTTY_DEB_URL")
            curl -LO "$GHOSTTY_DEB_URL"
            sudo dpkg -i "$GHOSTTY_DEB_FILE"
            rm "$GHOSTTY_DEB_FILE"
        fi
    fi
}

main() {
    install_antidote
    install_stow

    # Add Ghostty installation before stowing configs
    install_ghostty_ubuntu

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

    setup_editor_keybinds
    setup_shopify_configs

    echo "Dotfiles installation complete!"
}

main
