# Dotfiles

This repository keeps `nvim` and `tmux` at the repo root (not inside `.config`) so users can choose how to install them.

## What this repo contains

- `nvim/` -> Neovim config directory
- `tmux/` -> tmux config directory

## Dependencies

These need to be on `PATH` before Neovim starts (or on first plugin sync).

**Required — Neovim will not fully bootstrap without these:**

- `git` — lazy.nvim clones itself and every plugin on first run
- `make` and a C compiler (`gcc` or `clang`) — plugin `build` steps (`telescope-fzf-native`, `LuaSnip`) and `:TSUpdate` for tree-sitter parsers

**Required for core workflows:**

- `ripgrep` — backs Telescope's `live_grep`, `grep_string`, and `find_files` (`--hidden --no-ignore-vcs` flags)
- `node` ≥ 18 — `copilot.vim` runtime; also required by Mason to install `pyright` and `bashls`
- `curl` (or `wget`), `unzip`, `tar`, `gzip` — used by Mason to fetch LSP servers

**Required for the active `efm` formatters/linters (C/C++):**

- `clang-format`
- `cpplint` (`pip install cpplint`)

**Recommended:**

- `fd` — faster backend for Telescope `find_files`
- A Nerd Font + a true-color terminal — `nvim-web-devicons`, `lualine`, and `bufferline` render glyph icons

## Install after cloning

These steps move the directories into `~/.config`.

1. Clone the repo (any path works — the examples below use `$DOTFILES`)

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

4. Move configs from repo into `~/.config`

   ```bash
   mv "$DOTFILES/nvim" ~/.config/nvim
   mv "$DOTFILES/tmux" ~/.config/tmux
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

If you want to keep the repo directories in place and avoid moving them, use symlinks instead. Set `DOTFILES` to your clone path first — `ln -sfn` does not validate the target, so a wrong path produces a dangling link that silently fails.

```bash
export DOTFILES="$PWD"   # run from inside your clone, or set it explicitly
mkdir -p ~/.config
ln -sfn "$DOTFILES/nvim" ~/.config/nvim
ln -sfn "$DOTFILES/tmux" ~/.config/tmux
ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf
```

Verify the links resolve (no `cannot access` errors):

```bash
ls ~/.config/nvim/init.lua ~/.config/tmux/tmux.conf ~/.tmux.conf
```

This approach makes future `git pull` updates immediately reflect in your active config.
