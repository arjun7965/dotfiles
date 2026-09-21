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
- LSP servers are configured via `vim.lsp.config[...]` in `lua/plugins/nvim-lspconfig.lua`, with `efm` wiring formatters/linters per filetype through `efmls-configs-nvim`. Mason installs the binaries, but `mason-lspconfig.nvim` is disabled in `disabled.lua`, so nothing auto-installs — add servers by hand via `:MasonInstall` (the efm package is named `efm`, not `efm-langserver`). `clangd` is not from Mason; its `cmd` is hardcoded to `/apps/tools/llvm-17/bin/clangd`.
- `nvim/lazy-lock.json` is the pinned plugin manifest — commit it alongside spec changes. `nvim/parser/` holds committed tree-sitter parsers. On a fresh clone use `:Lazy restore` to honor the pins; `:Lazy sync` updates plugins and rewrites the lockfile.

### Known gotchas

- **Requires Neovim 0.11+.** `vim.lsp.config` and `vim.lsp.enable` do not exist in 0.10 — the LSP spec errors at startup on anything older.
- LSP servers only attach inside a project root (`.git` or a language marker). On a loose file they silently don't start and only `efm` attaches, which looks like a broken server but isn't.
- `efm`'s `settings.languages` references linters/formatters whose `require` lines are commented out just above it, so those names are `nil` and each list collapses to an empty table. Only `c`/`cpp` actually run anything; lua/python/sh/json/markdown/JS-TS format and lint nothing.
- `options.lua` sets `foldexpr = "nvim_treesitter#foldexpr()"` while `nvim-treesitter` is disabled in `disabled.lua`. `foldlevel = 99` hides it on open, but a fold recompute raises `E117`. `nvim/parser/` and `nvim-treesitter.lua` are dead weight for the same reason.
- `lualine-nvim.lua` has `theme = auto` — a bare nil global, not the string `"auto"`. It works only because lualine defaults to `auto` when the key is absent.
- `guicursor` in `options.lua` spells out a `t:` clause on purpose: an `a:`-only value replaces the whole option and silently drops nvim's default terminal-mode cursor.

## tmux architecture

`tmux/tmux.conf` is the main file and `source`s two siblings unconditionally plus one conditional:

- `statusline.conf` — Solarized-flavored statusline (colors hardcoded).
- `utility.conf` — misc utility bindings.
- `macos.conf` — sourced only when `uname -s` reports Darwin.

Prefix is remapped to `C-a`. Vim-style pane navigation (`h/j/k/l` with prefix, `M-h/j/k/l` without) is mirrored in Neovim via `vim-tmux-navigator` — if you change pane-navigation keys, update both sides.

`.config/tmux/plugins/` is gitignored (TPM installs there at runtime).
