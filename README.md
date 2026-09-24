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

## Fonts (required — icons render blank without this)

The Neovim config uses Nerd Font glyphs for diagnostic signs, file-type icons, the
dashboard and the statusline. Without a Nerd Font selected **in your terminal**,
all of them render as blank cells or boxes. Nothing in this repo can fix that; the
font is the terminal's, not Neovim's.

1. Install a Nerd Font (user-local, no `sudo`)

   ```bash
   mkdir -p ~/.local/share/fonts
   cd /tmp
   curl -sSLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
   unzip -o JetBrainsMono.zip \
     'JetBrainsMonoNerdFont-Regular.ttf' 'JetBrainsMonoNerdFont-Bold.ttf' \
     'JetBrainsMonoNerdFont-Italic.ttf'  'JetBrainsMonoNerdFont-BoldItalic.ttf' \
     -d ~/.local/share/fonts/
   fc-cache -f ~/.local/share/fonts
   ```

   The archive also ships `Mono`, `Propo` and `NL` variants and unpacks to ~240 MB;
   the four files above are all a terminal needs (~10 MB).

2. Add a symbols font for the non-Nerd glyphs

   Nerd Fonts only patch the Private Use Areas. Symbols in real Unicode blocks are
   not included — notably `U+23F5` (`⏵`), which Claude Code uses in its mode
   indicator. `Noto Sans Symbols 2` covers that block.

   No `sudo` needed — pull the one font out of the package and install it user-local
   (the Aries FW VMs have no sudo as of 2026-09-23):

   ```bash
   cd /tmp && apt-get download fonts-noto-core
   dpkg-deb -x fonts-noto-core_*.deb x/
   cp x/usr/share/fonts/truetype/noto/NotoSansSymbols2-Regular.ttf ~/.local/share/fonts/
   fc-cache -f ~/.local/share/fonts
   rm -rf /tmp/x /tmp/fonts-noto-core_*.deb
   ```

   Installing the whole `fonts-noto-core` package would add 268 font files
   system-wide to get this one 642 KB file, so the extraction is preferable even
   where you do have root.

3. Point your terminal at the font

   For Terminator, in `~/.config/terminator/config` under `[[default]]`:

   ```
   font = JetBrainsMono Nerd Font 11
   use_system_font = False
   ```

   **Terminator reads this once, at process start.** A new tab or window is handed
   to the existing process over DBus and keeps the old font, so editing the file is
   not enough — either quit Terminator entirely and relaunch (`terminator --no-dbus &`
   forces an independent process), or set the font via Preferences → Profiles →
   General, which applies live to the running window.

## Verify setup

- `~/.config/nvim` is a symlink to your clone
- `~/.config/tmux` is a symlink to your clone
- `~/.tmux.conf` points to `~/.config/tmux/tmux.conf`
- A Nerd Font is installed **and loaded by the running terminal**

Quick checks:

```bash
ls -ld ~/.config/nvim ~/.config/tmux
ls -l ~/.tmux.conf
ls ~/.config/nvim/init.lua ~/.config/tmux/tmux.conf ~/.tmux.conf

# fonts: is a Nerd Font installed, and does the running terminal actually use it?
fc-list | grep -c -i nerd
grep -c JetBrainsMono /proc/$(pgrep -u "$USER" -f 'x-terminal-emul|terminator' | head -1)/maps
```

Both counts must be non-zero. The second is the one that matters — a font can be
installed and still not loaded by the terminal you are sitting in. To check a single
glyph's coverage use `fc-list ':charset=f15b'`; do not use `fc-match`, which returns
the requested family whether or not it has the glyph.

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
