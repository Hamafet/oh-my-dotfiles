# oh-my-dotfiles 🧰

Dotfiles managed with **GNU Stow** for fast, clean, reproducible setup across multiple Linux machines.

This repo focuses on:
- **symlinks** (not copies)
- **Stow packages** that mirror `$HOME`
- install frameworks separately (Oh My Zsh, oh-my-tmux, Kitty), while versioning *your* configs

---

## What’s included

- **Zsh**: `.zshrc` (works with Oh My Zsh)
- **Neovim**: LazyVim config in `~/.config/nvim`
- **Kitty**: config in `~/.config/kitty`
- **Tmux**: config in `~/.config/tmux/tmux.conf` and optionally `~/.tmux.conf`

---

## One-shot install (new PC)

```bash
git clone https://github.com/Hamafet/oh-my-dotfiles.git ~/oh-my-dotfiles
cd ~/oh-my-dotfiles
chmod u+x ./bootstrap.sh
./bootstrap.sh
```

---

## Notes

- Frameworks are installed by `bootstrap.sh`
- Dotfiles are symlinked using `stow`
- Tested on Ubuntu / Debian
