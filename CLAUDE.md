# Neovim Remote Control Cheatsheet

## About nvr

`nvr` is a wrapper function for `nvim --server` commands that communicate with a running Neovim instance.
By default, it connects to a Neovim server at `/tmp/nvim` unless specified otherwise.

The underlying implementation maps each nvr command to the appropriate nvim --remote command:

- `nvr expr` → `nvim --remote-expr`
- `nvr send` → `nvim --remote-send`
- `nvr visual-text` → Combines remote-send and remote-expr to retrieve selected text

## Basic Commands

```bash
nvr current-file            # Get path of current file
nvr mode                    # Get current mode (n=normal, i=insert, v=visual)
nvr expr 'expression'       # Evaluate Vim expression
nvr send 'keys'             # Send keys to Neovim
nvr visual-text             # Get visually selected text
```

## Common Operations

### Reading

```bash
nvr expr 'line(".")'        # Current line number
nvr expr 'getline(".")'     # Text of current line
nvr expr 'getline(1, "$")'  # All buffer content
```

### Writing

```bash
nvr send 'ihello<Esc>'      # Insert text at cursor
nvr send 'Go# Comment<Esc>' # Add line at end of file
nvr send ':w<CR>'           # Save file
```

### Visual Selection

```bash
nvr send 'V'                # Line visual mode
nvr send 'v'                # Character visual mode
nvr send 'c[new text]<Esc>' # Replace selection
```

### Combined Examples

```bash
# Get and modify selection
selected=$(nvr visual-text)
modified="Modified: $selected"
nvr send 'c'"$modified"'<Esc>'

# Go to line and add text
nvr send ':10<CR>'
nvr send 'oNew line<Esc>'
```

## File Editing Best Practices

### IMPORTANT: Avoid using nvim for file edits

1. DO NOT use nvim/nvr for file edits - use View/Edit/Replace tools instead
2. NEVER use nvr send 'c[text]<Esc>' to modify text, even for visually selected content
3. Only use nvr visual-text to READ selected text, then use Edit tool to make changes
4. For any file modifications (even when user is in nvim):
   - Use View to read the file
   - Use Edit to make changes
   - Optionally reload the buffer with nvim --remote-send ':checktime<CR>' --server /tmp/nvim after external edits
5. Use nvim/nvr commands ONLY for navigation, not for content modification
6. If needing to modify an active nvim session, verify connection works first:
   - Check with: nvim --remote-expr 'expand("%:p")' --server /tmp/nvim

# macOS Nix Management

## Removing Nix (to use traditional dotfiles)

```bash
# Remove files and services
sudo rm -rf /nix /etc/nix ~/.nix-*
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist

# Remove the Nix Store volume
diskutil apfs deleteVolume /nix
```

## Reinstalling Nix Later

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## Restoring Nix Configuration

```bash
cd nixos-config && nix run .#build-switch
```
