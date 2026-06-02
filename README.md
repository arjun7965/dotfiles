# Dotfiles

This repository keeps `nvim` and `tmux` at the repo root (not inside `.config`) so users can choose how to install them.

## What this repo contains

- `nvim/` -> Neovim config directory
- `tmux/` -> tmux config directory
- `bash/` -> bash prompt (pure-bash powerline-style prompt with git status)

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

- `fd` — gitignore-aware file-finder backend for Telescope `find_files` (nicer defaults than the built-in `find`; comparable in speed to ripgrep, which it shares a traversal engine with)
- A Nerd Font + a true-color terminal — `nvim-web-devicons`, `lualine`, and `bufferline` render glyph icons

**tmux bindings that shell out:**

- `lazygit` — `Prefix + g` opens a popup running `lazygit` (`tmux/utility.conf`)

## One-command bootstrap

After cloning, run this from the repo root — it handles backups, symlinks, and verification automatically:

```bash
./scripts/bootstrap-symlinks.sh
```

Optional: override the source path explicitly (must be absolute):

```bash
DOTFILES="/absolute/path/to/dotfiles" ./scripts/bootstrap-symlinks.sh
```

This replaces the manual steps below. Use the manual steps only if you need finer control.

## Install after cloning (recommended: symlink model)

Use symlinks so `~/.config` remains the live location while real files stay in your clone.

1. Clone the repo and set an absolute source path

   ```bash
   git clone <your-repo-url> ~/src/dotfiles
   cd ~/src/dotfiles
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

## bash prompt

A self-contained, pure-bash powerline-style prompt
(vendored from [riobard/bash-powerline](https://github.com/riobard/bash-powerline) —
no Python, no daemon, no dependency beyond `git`). To the right of the cwd it shows:

- `⑂<branch>` — current branch (or tag/short-hash when detached)
- `*` — working tree has uncommitted changes
- `↑N` — local is N commits **ahead** of upstream (you need to push)
- `↓N` — upstream is N commits ahead (**origin ahead**; you need to pull)

The trailing `$` turns green on success and red when the last command exited non-zero.

The bootstrap script symlinks `~/.config/bash` -> `bash/`. To enable the prompt,
add this line to the **end** of `~/.bashrc` (after any existing `PS1` setup, since
it takes over the prompt via `PROMPT_COMMAND`):

```bash
[ -f ~/.config/bash/bash-powerline.sh ] && source ~/.config/bash/bash-powerline.sh
```

Then `source ~/.bashrc` (or open a new shell). Customize by exporting any
`COLOR_*` / `SYMBOL_*` / `PS_SYMBOL` variable before that line, or set
`POWERLINE_GIT=0` to disable git info. Note: because the prompt is rebuilt every
command via `PROMPT_COMMAND`, it replaces the stock xterm window-title `PS1`.

## Verify setup

- `~/.config/nvim` is a symlink to your clone
- `~/.config/tmux` is a symlink to your clone
- `~/.config/bash` is a symlink to your clone (and `~/.bashrc` sources `bash-powerline.sh`)
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

If you prefer moving files into `~/.config` (no symlinks), use this variant. Set `DOTFILES` to your clone path first.

```bash
export DOTFILES="/absolute/path/to/your/clone"
mkdir -p ~/.config
mv "$DOTFILES/nvim" ~/.config/nvim
mv "$DOTFILES/tmux" ~/.config/tmux
ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf
```

Note: with this approach, `git pull` updates will not automatically reflect in `~/.config` — you would need to copy files again after each pull.
