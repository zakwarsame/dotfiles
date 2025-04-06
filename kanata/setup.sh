#!/bin/bash

# Set dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

echo "Setting up Kanata for macOS..."

echo "Please complete the following steps in System Settings:"
echo "1. Enable 'Karabiner-Elements Non-Privileged Agents' in Login Items & Extensions"
echo "2. Enable 'Karabiner-Elements Privileged Daemons' in Login Items & Extensions"
echo "3. Enable '.Karabiner-VirtualHIDDevice-Manager' in Login Items & Extensions > Driver Extensions"
echo "4. Enable Input Monitoring for Terminal and Karabiner processes"

read -p "Have you completed these steps? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please complete the setup steps before continuing."
    exit 1
fi

# Kill any running processes
echo "Stopping any running kanata processes..."
sudo pkill kanata 2>/dev/null || true

# Kill any running Karabiner processes
echo "Stopping Karabiner processes..."
killall karabiner_console_user_server 2>/dev/null || true
launchctl bootout gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server 2>/dev/null || true

# Create log directories
mkdir -p ~/Library/Logs
sudo mkdir -p /Library/Logs/Kanata
sudo chmod 755 /Library/Logs/Kanata

# Stow kanata config
stow --dir="$DOTFILES_DIR" --target="$HOME" --restow kanata

# Start kanata in the background
echo "Starting kanata in the background..."
sudo nohup /opt/homebrew/bin/kanata --cfg ~/.config/kanata/kanata.kbd > ~/Library/Logs/kanata.log 2> ~/Library/Logs/kanata.err.log &

echo "Kanata is now running in the background."

# to kill kanata
# sudo pkill kanata || true
