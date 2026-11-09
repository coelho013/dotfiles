#!/usr/bin/env bash
# Bootstrap dos dotfiles: Homebrew -> Brewfile -> stow -> ai-memory.
#
# Uso: ~/.dotfiles/install.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh git tmux nvim)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ── Homebrew ─────────────────────────────────────────────
case "$(uname -s)" in
  # zsh e git vêm do sistema (o zsh precisa estar em /etc/shells para virar shell padrão)
  Linux)  sudo apt install -y build-essential zsh git ;;
  # no macOS o zsh já é o shell padrão e o git vem com as Command Line Tools
  Darwin) xcode-select -p >/dev/null 2>&1 || xcode-select --install ;;
esac
echo "==> build-essential, zsh e git instalados"

load_brew() {
  local p
  for p in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    [[ -x $p ]] && { eval "$($p shellenv)"; return 0; }
  done
  return 1
}

if ! load_brew; then
  echo "==> Instalando Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew
fi

echo "==> brew bundle"
brew bundle --file "$DOTFILES/Brewfile"

# ── Symlinks (stow) ──────────────────────────────────────
# Move para o backup qualquer arquivo real que impediria o stow.
# Em .config/ o alvo é a pasta do app (ex: ~/.config/nvim).
backup_conflicts() {
  local pkg=$1 entry rel target
  for entry in "$DOTFILES/$pkg"/{.,}*; do
    [[ -e $entry ]] || continue
    rel=${entry#"$DOTFILES/$pkg/"}
    [[ $rel == . || $rel == .. ]] && continue
    if [[ $rel == .config ]]; then
      for entry in "$DOTFILES/$pkg/.config"/*; do
        backup_one ".config/$(basename "$entry")"
      done
    else
      backup_one "$rel"
    fi
  done
}

backup_one() {
  local target="$HOME/$1"
  # symlinks quebrados ou que já apontam pro repo são só removidos; o stow recria
  if [[ -L $target ]] && { [[ ! -e $target ]] || [[ $(readlink -f "$target") == "$DOTFILES"/* ]]; }; then
    rm "$target"
  elif [[ -e $target || -L $target ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$1")"
    mv "$target" "$BACKUP_DIR/$1"
    echo "    backup: ~/$1 -> $BACKUP_DIR/$1"
  fi
}

echo "==> stow: ${PACKAGES[*]}"
mkdir -p "$HOME/.config"
for pkg in "${PACKAGES[@]}"; do
  backup_conflicts "$pkg"
  stow --dir "$DOTFILES" --target "$HOME" --restow "$pkg"
done

# ── tmux plugins (tpm) ───────────────────────────────────
# Os plugins não são versionados: clona o tpm e já instala os plugins do
# .tmux.conf (equivalente a prefix + I), senão a statusbar não aparece.
if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  echo "==> Clonando tpm"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
echo "==> Instalando plugins do tmux"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# ── ai-memory ────────────────────────────────────────────
"$DOTFILES/ai-memory/install.sh"

echo "==> Pronto. Abra um novo shell (exec zsh)."

