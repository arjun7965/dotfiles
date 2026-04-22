# Dotfiles

This repository keeps `nvim` and `tmux` at the repo root (not inside `.config`) so users can choose how to install them.

## What this repo contains

- `nvim/` -> Neovim config directory
- `tmux/` -> tmux config directory

## One-command bootstrap

Run this from the repo root:

```bash
./scripts/bootstrap-symlinks.sh
```

Optional: override the source path explicitly (must be absolute):

```bash
DOTFILES="/absolute/path/to/dotfiles" ./scripts/bootstrap-symlinks.sh
```

## Install after cloning (recommended: symlink model)

Use symlinks so `~/.config` remains the live location while real files stay in your clone.

1. Clone the repo and set an absolute source path

   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   export DOTFILES="$PWD"
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

4. Link live paths to the repo

   ```bash
   ln -sfn "$DOTFILES/nvim" ~/.config/nvim
   ln -sfn "$DOTFILES/tmux" ~/.config/tmux
   ```

5. Ensure tmux loads from `~/.config/tmux`

   ```bash
   ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf
   ```

6. Reload tools

   ```bash
   # Neovim: reopen nvim
   # tmux: reload config in a session
   tmux source-file ~/.tmux.conf
   ```

## Verify setup

- `~/.config/nvim` is a symlink to your clone
- `~/.config/tmux` is a symlink to your clone
- `~/.tmux.conf` points to `~/.config/tmux/tmux.conf`

Quick checks:

```bash
ls -ld ~/.config/nvim ~/.config/tmux
ls -l ~/.tmux.conf
ls ~/.config/nvim/init.lua ~/.config/tmux/tmux.conf ~/.tmux.conf
```

## Daily workflow

1. Edit only inside your clone.
2. Commit and pull in your clone.
3. Reload tmux with `tmux source-file ~/.tmux.conf`.
4. Reopen Neovim (and run `:Lazy sync` after plugin spec changes).

## Reliability guardrails

1. Always set `DOTFILES` to an absolute path.
2. If you move the clone, recreate symlinks.
3. Commit `nvim/lazy-lock.json` with plugin changes.

## Alternative: move-based install

If you prefer moving files into `~/.config`, use this variant.

```bash
mkdir -p ~/.config
mv "$DOTFILES/nvim" ~/.config/nvim
mv "$DOTFILES/tmux" ~/.config/tmux
ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf
```
