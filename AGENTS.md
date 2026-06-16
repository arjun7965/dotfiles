# Repository Guidelines

## Project Structure & Module Organization

This repository stores personal dotfiles at the repo root so they can be symlinked into live config paths. `nvim/init.lua` loads `lua/config/init.lua`, which bootstraps lazy.nvim, loads core settings, then imports plugin specs from `nvim/lua/plugins/`. Shared Neovim helpers live in `nvim/lua/util/`, pinned plugin versions in `nvim/lazy-lock.json`, and committed tree-sitter parsers in `nvim/parser/`. `tmux/tmux.conf` sources `statusline.conf`, `utility.conf`, and `macos.conf` on Darwin. `bash/` contains the optional pure-bash powerline prompt. `scripts/bootstrap-symlinks.sh` installs symlinks into `~/.config`.

## Build, Test, and Development Commands

There is no package build or formal test suite. Use tool-specific validation:

- `./scripts/bootstrap-symlinks.sh` - create or refresh symlinks and run basic verification.
- `tmux source-file ~/.tmux.conf` - reload tmux config after changes.
- `nvim` then `:Lazy sync` - bootstrap or update Neovim plugins after plugin spec changes.
- `source ~/.bashrc` - reload the optional bash prompt after sourcing changes.

## Coding Style & Naming Conventions

Keep Lua modules grouped by purpose: core settings under `nvim/lua/config/`, reusable helpers under `nvim/lua/util/`, and one plugin spec per file under `nvim/lua/plugins/`. `nvim/lua/plugins/init.lua` is also a spec file, not a shared loader. Match existing Lua style: two-space indentation, concise `require(...)` calls, and snake_case local names. For shell scripts, use Bash with `set -euo pipefail`, quote variables, and prefer small helper functions. For tmux files, keep related bindings together and preserve `~/.config/tmux/...` source paths.

## Testing Guidelines

Validate the exact tool touched. For Neovim changes, open `nvim`, check startup errors, and run `:Lazy sync` when plugin specs or `lazy-lock.json` change. For tmux, reload with `tmux source-file ~/.tmux.conf` or prefix `C-a` then `r`. For bash prompt changes, source a shell that loads `~/.config/bash/bash-powerline.sh` and verify git prompt states in a clean and dirty repository.

## Agent-Specific Implementation Notes

Do not move `nvim/`, `tmux/`, or `bash/` under `.config/`; the README documents symlink and move-based installs. Live paths are usually `~/.config/nvim`, `~/.config/tmux`, and `~/.config/bash`, with `~/.tmux.conf` pointing to `~/.config/tmux/tmux.conf`. If the clone path changes, rerun the bootstrap script. The bash prompt installs itself through `PROMPT_COMMAND`, so source it after other prompt setup. Tmux prefix is `C-a`; vim-style pane navigation is mirrored by Neovim's `vim-tmux-navigator`, so update both sides if keys change.

## Commit & Pull Request Guidelines

Recent commits use short, imperative subjects such as `Fix todo-comments never loading` and `Add symlink bootstrap script and README setup guide`. Keep the first line specific and under roughly 72 characters. Include `nvim/lazy-lock.json` with plugin updates. Pull requests should describe the changed config area, mention manual validation performed, and include screenshots only for visible UI changes such as statusline or prompt updates.
