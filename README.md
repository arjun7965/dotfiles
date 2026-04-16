# Dotfiles

This repository keeps `nvim` and `tmux` at the repo root (not inside `.config`) so users can choose how to install them.

## What this repo contains

- `nvim/` -> Neovim config directory
- `tmux/` -> tmux config directory

## Install after cloning

These steps move the directories into `~/.config`.

1. Clone the repo

   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Create `~/.config` if needed

   ```bash
   mkdir -p ~/.config
   ```

3. Back up existing configs (if present)

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
   mv ~/.config/tmux ~/.config/tmux.backup.$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
   ```

4. Move configs from repo into `~/.config`

   ```bash
   mv ~/dotfiles/nvim ~/.config/nvim
   mv ~/dotfiles/tmux ~/.config/tmux
   ```

5. Ensure tmux loads this config via `~/.tmux.conf`

   ```bash
   ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf
   ```

6. Reload tools

   ```bash
   # Neovim: reopen nvim
   # tmux: reload config in a session
   tmux source-file ~/.tmux.conf
   ```

## Verify setup

- `~/.config/nvim` exists
- `~/.config/tmux` exists
- `~/.tmux.conf` points to `~/.config/tmux/tmux.conf`

Quick checks:

```bash
ls -ld ~/.config/nvim ~/.config/tmux
ls -l ~/.tmux.conf
```

## Optional: keep repo as source of truth (symlink instead of move)

If you want to keep the repo directories in place and avoid moving them, use symlinks instead:

```bash
mkdir -p ~/.config
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/tmux ~/.config/tmux
ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf
```

This approach makes future `git pull` updates immediately reflect in your active config.
