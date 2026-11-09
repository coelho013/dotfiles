# Brewfile — instale com: brew bundle --file ~/.dotfiles/Brewfile

# ── Taps ─────────────────────────────────────────────────
tap "akitaonrails/tap"

# ── Dotfiles ─────────────────────────────────────────────
brew "stow"                       # gerencia os symlinks dos pacotes

# ── Editor / terminal ────────────────────────────────────
brew "neovim"
brew "tmux"
brew "bash"                       # tmux2k (statusbar) exige bash 5.2+; o do macOS é 3.2
brew "lazygit"
brew "node"
brew "tree-sitter-cli"
brew "ripgrep"
brew "jdtls"                      # LSP do Java (traz o JDK 21+ que ele precisa)

# ── Zsh ──────────────────────────────────────────────────
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ── AI ───────────────────────────────────────────────────
brew "akitaonrails/tap/ai-jail"   # sandbox para agentes de IA

# ── Essentials ───────────────────────────────────────────────────
brew "unzip"

# ── Fontes ───────────────────────────────────────────────
# Nerd Font para o ícone de git do prompt. Casks só existem no macOS;
# no Linux o install.sh baixa a fonte; no WSL ela é instalada no Windows (veja o README).
cask "font-jetbrains-mono-nerd-font" if OS.mac?
