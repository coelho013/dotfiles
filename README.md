# .dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/)
and [Homebrew](https://brew.sh).

## Structure

Each top-level folder is a stow *package*, mirroring the path relative to
`$HOME`:

```
.dotfiles/
├── zsh/.zshrc                  -> ~/.zshrc
├── git/.gitconfig              -> ~/.gitconfig
├── tmux/.tmux.conf             -> ~/.tmux.conf
├── nvim/.config/nvim/          -> ~/.config/nvim
├── ai-memory/install.sh        installs/configures ai-memory
├── Brewfile                    Homebrew packages
└── install.sh                  full bootstrap
```

## Installation

```sh
git clone git@github.com:coelho013/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh`:

1. installs the system prerequisites (`build-essential`, `zsh`, `git` via apt
   on Linux; Command Line Tools on macOS);
2. installs Homebrew (if missing) and runs `brew bundle`;
3. creates the symlinks with `stow` — conflicting real files are moved to
   `~/.dotfiles-backup/<date>/`;
4. runs `ai-memory/install.sh`.

No system Ruby is needed: Homebrew ships its own Ruby to read the Brewfile.

### Nerd Font

The zsh prompt uses a Nerd Font icon for the git branch. On macOS the
Brewfile installs JetBrains Mono Nerd Font. On WSL the font must be installed
on Windows (download from <https://www.nerdfonts.com/font-downloads>) and
selected in the Windows Terminal profile; otherwise set `GIT_SYMBOL=''` in
`.zshrc`.

## Tools

Top-level entries are the tools I actually use; nested entries are only
there so their parent works.

```
BOOTSTRAP (install.sh)
├── apt: build-essential, zsh, git       Linux (macOS: Command Line Tools)
├── Homebrew                             installs the Brewfile
│   └── curl                             downloads the installer
└── stow                                 symlinks the packages

zsh                                      no framework
├── zsh-autosuggestions                  brew
├── zsh-syntax-highlighting              brew
├── git                                  prompt reads `git status`
└── Nerd Font                            prompt git icon (cask on macOS)

tmux                                     prefix C-Space
├── tpm                                  plugin manager (install.sh installs plugins)
└── tmux2k                               statusbar
    ├── bash 5.2+                        brew (macOS ships 3.2)
    └── Nerd Font                        status icons

git                                      .gitconfig with user/email

lazygit                                  git TUI

Neovim
├── lazy.nvim                            plugin manager
│   └── git                              clones lazy and the plugins
├── telescope.nvim                       fuzzy finder
│   ├── plenary.nvim
│   └── ripgrep                          live_grep / grep_string
├── nvim-treesitter                      syntax highlighting
│   ├── tree-sitter-cli                  builds the parsers
│   └── build-essential                  C compiler for the parsers
├── blink.cmp                            completion (prebuilt binary)
├── nvim-jdtls                           Java
│   ├── jdtls                            brew; pulls openjdk and python
│   ├── blink.cmp                        LSP capabilities
│   ├── lombok-nightly                   optional, :MasonInstall
│   └── JDKs 8/17/21 in /usr/lib/jvm     project runtimes, installed outside
├── mason.nvim                           LSP/tool installer (only lombok today)
│   └── unzip                            extracts packages
├── lazygit.nvim                         <leader>gg
│   ├── lazygit
│   └── plenary.nvim
├── lualine.nvim                         statusline/tabline
├── mini.files                           file explorer, <leader>e
├── catppuccin                           theme (mocha)
├── indent-blankline.nvim                indent guides
├── ultimate-autopair.nvim               auto-close pairs
└── cstest.nvim                          local, only if $CSTEST_DIR exists

ai-memory                                memory for AI agents (curl installer)
└── curl, systemd --user

ai-jail                                  sandbox for AI agents
└── tap akitaonrails/tap

ORPHAN
└── node                                 nothing uses it yet
```

## Day-to-day usage

```sh
# (re)link a package
stow -d ~/.dotfiles -t ~ -R nvim

# remove a package's links
stow -d ~/.dotfiles -t ~ -D tmux

# (re)link all packages (ai-memory is not a stow package)
stow -d ~/.dotfiles -t ~ -R zsh git tmux nvim

# dry run: show what stow would do without changing anything
stow -n -v -d ~/.dotfiles -t ~ -R zsh git tmux nvim

# update the Brewfile with what is currently installed
brew bundle dump --file ~/.dotfiles/Brewfile --force --brews --taps

# update ai-memory to the latest release
~/.dotfiles/ai-memory/install.sh --update
```

To add a new app, create `<app>/` with the path relative to `$HOME`
(e.g. `alacritty/.config/alacritty/alacritty.toml`) and add it to `PACKAGES`
in `install.sh`.
