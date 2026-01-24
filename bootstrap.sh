#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\n==> %s\n" "$*"; }
need_cmd() { command -v "$1" >/dev/null 2>&1; }

install_apt() {
  sudo apt update
  sudo apt install -y git curl wget fzf zoxide stow zsh tmux neovim
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
  [ -d "$HOME/.oh-my-zsh" ] || RUNZSH=no CHSH=no sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

stow_dotfiles() {
  cd "$REPO_DIR"
  mkdir -p "$HOME/.config"
  stow zsh nvim kitty tmux
}

main() {
  install_apt
  install_kitty
  install_oh_my_tmux
  install_oh_my_zsh
  stow_dotfiles
}

main "$@"
