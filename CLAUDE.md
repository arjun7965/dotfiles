# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles for Neovim and tmux. There is no build, lint, or test tooling — changes are validated by reloading the target tool:

- Neovim: reopen `nvim` (or `:Lazy sync` after changing a plugin spec).
- tmux: `tmux source-file ~/.tmux.conf` in an active session, or `Prefix + r` (prefix is `C-a`).

## Installation model (important)

`nvim/` and `tmux/` live at the repo root, **not** under `.config/`, so users can choose between moving or symlinking into `~/.config` (see README.md). When editing configs, remember that the "live" paths on a configured machine are `~/.config/nvim` and `~/.config/tmux`, and `~/.tmux.conf` is a symlink to `~/.config/tmux/tmux.conf`. Cross-file `source` directives in tmux use the `~/.config/tmux/...` path (see `tmux/tmux.conf:100-103`), so preserve those absolute locations when refactoring.

## Neovim architecture

Entry point: `nvim/init.lua` → `lua/config/init.lua`.

- `lua/config/init.lua` bootstraps **lazy.nvim** (cloned on first run), loads settings modules in order (`globals`, `options`, `keymaps`, `autocmds`, `helpers`), then calls `require("lazy").setup("plugins", opts)`.
- `lua/plugins/` — one file per plugin spec; lazy.nvim auto-imports every file here. Adding a plugin = dropping a new file in this dir that returns a lazy spec table. `lua/plugins/init.lua` is just another spec file (not a loader), so don't put shared state there.
- `lua/config/globals.lua` sets `<leader>` and `<localleader>` to space — keymaps everywhere assume this.
- `lua/util/` — shared helpers (`lsp.on_attach`, `icons.diagnostic_signs`, `keymapper`) consumed by plugin specs; edit here when multiple plugins need the same behavior.
- `lua/plugins/disabled.lua` — convention for plugins kept around but turned off.
- LSP servers are configured via `vim.lsp.config[...]` in `lua/plugins/nvim-lspconfig.lua`, with `efm` wiring formatters/linters per filetype through `efmls-configs-nvim`. Mason handles server installation (`mason.lua`, `mason-lspconfig.lua`).
- `nvim/lazy-lock.json` is the pinned plugin manifest — commit it alongside spec changes. `nvim/parser/` holds committed tree-sitter parsers.

## tmux architecture

`tmux/tmux.conf` is the main file and `source`s two siblings unconditionally plus one conditional:

- `statusline.conf` — Solarized-flavored statusline (colors hardcoded).
- `utility.conf` — misc utility bindings.
- `macos.conf` — sourced only when `uname -s` reports Darwin.

Prefix is remapped to `C-a`. Vim-style pane navigation (`h/j/k/l` with prefix, `M-h/j/k/l` without) is mirrored in Neovim via `vim-tmux-navigator` — if you change pane-navigation keys, update both sides.

`.config/tmux/plugins/` is gitignored (TPM installs there at runtime).
