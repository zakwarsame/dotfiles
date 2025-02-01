# dotfiles

my current dotfiles setup. so much bs and iterations going on here and i'm too lazy to clean it up.

## structure

- `git/`: all my git-related stuff
- `nvim/`: neovim config
- `wezterm/`: terminal emulator config
- `zsh/`: zsh shell goodies
- `kitty/`: kitty terminal config (barely used anymore)
- `espanso/`: text expansion magic
- `aerospace/`: window management for macos
- `zellij/` for multiplexin

```
dotfiles/
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── nvim/
│   └── .config/
│       └── nvim/
│           └── ... (nvim config files)
├── wezterm/
│   └── .config/
│       └── wezterm/
│           └── ... (wezterm config files)
├── zsh/
│   ├── .zshrc
│   ├── .p10k.zsh
│   ├── environment.zsh
│   ├── environment.secrets.zsh
│   ├── macos.zsh
│   ├── linux.zsh
│   ├── utils.zsh
│   ├── custom.zsh
│   └── antidote.zsh_plugins.txt
├── kitty/
│   └── .config/
│       └── kitty/
│           └── ... (kitty config files)
├── espanso/
│   └── .config/
│       └── espanso/
│           └── ... (espanso config files)
├── keyd/
│       └── etc/
│           └── keyd/
│               └── default.conf
└── install.sh
```

## how to use this?

1. clone this repo to your home directory
2. run the `install.sh` script

the install script will:

- backup your existing configs
- use gnu stow to symlink everything
- handle os-specific stuff (macos vs linux)

## cool features

- uses antidote for zsh plugin management
- configures git with some neat shortcuts
- sets up a prompt with powerlevel10k

## os-specific stuff

- macos: configures things like keyboard repeat rate and finder settings
- linux: sets up keyd for keyboard remapping on linux (`capslock` as esc when
  tapped, ctrl when held. `capslock`+ `hjkl` as arrows)
