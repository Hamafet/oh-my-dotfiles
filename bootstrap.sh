#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\n==> %s\n" "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1; }

install_apt() {
  sudo apt update
  sudo apt install -y git curl wget fzf zoxide stow zsh tmux neovim \
    ripgrep fd-find build-essential unzip

  # fd symlink for LazyVim/telescope (apt names it fdfind)
  mkdir -p "$HOME/.local/bin"
  ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"

  # fzf keybindings for zsh (requires fzf >= 0.48)
  if ! [ -f "$HOME/.fzf.zsh" ]; then
    fzf --zsh > "$HOME/.fzf.zsh" 2>/dev/null || true
  fi
}

install_kitty() {
  if [ ! -d "$HOME/.local/kitty.app" ]; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  fi

  sudo mkdir -p /usr/local/bin /usr/local/share/applications
  sudo ln -sf "$HOME/.local/kitty.app/bin/kitty" /usr/local/bin/kitty
  sudo ln -sf "$HOME/.local/kitty.app/bin/kitten" /usr/local/bin/kitten

  sudo cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" /usr/local/share/applications/
  sudo cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" /usr/local/share/applications/

  sudo sed -i "s|Icon=kitty|Icon=$(readlink -f "$HOME")/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" /usr/local/share/applications/kitty*.desktop
  sudo sed -i "s|Exec=kitty|Exec=$(readlink -f "$HOME")/.local/kitty.app/bin/kitty|g" /usr/local/share/applications/kitty*.desktop

  mkdir -p "$HOME/.config"
  echo 'kitty.desktop' > "$HOME/.config/xdg-terminals.list"
}

install_oh_my_tmux() {
  [ -d "$HOME/.tmux" ] || curl -fsSL "https://github.com/gpakosz/.tmux/raw/refs/heads/master/install.sh#$(date +%s)" | bash
}

install_oh_my_zsh() {
  [ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no CHSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
}

install_zsh_plugins() {
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  [ -d "$dir/zsh-autosuggestions" ]  || git clone https://github.com/zsh-users/zsh-autosuggestions "$dir/zsh-autosuggestions"
  [ -d "$dir/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$dir/zsh-syntax-highlighting"
}

stow_dotfiles() {
  cd "$REPO_DIR"
  mkdir -p "$HOME/.config"
  stow zsh nvim kitty tmux
}

main() {
  install_apt
  install_oh_my_zsh
  rm -f "$HOME/.zshrc"           # discard OMZ template; stow links ours
  install_zsh_plugins
  install_kitty
  install_oh_my_tmux
  stow_dotfiles
}

main "$@"
