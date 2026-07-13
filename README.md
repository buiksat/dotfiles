# Bahram's dotfiles

Personal terminal/editor setup for macOS and Linux servers.

## What is tracked

- `~/.tmux.conf`
- `~/.config/nvim/init.lua`
- `~/.config/nvim/lazy-lock.json`
- `~/.config/kitty/kitty.conf`
- `~/.config/karabiner/karabiner.json`
- shell helpers such as `~/.zshrc` and `~/.local/bin/tmux-copy`

Generated backups, Karabiner automatic backups, plugin install directories, and secrets are intentionally not tracked.

## Install on a new machine

```bash
git clone git@github.com:buiksat/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh --dry-run
./bootstrap.sh --force
```

Use the SSH URL on machines that have your GitHub SSH key. If a server only has HTTPS access, clone with:

```bash
git clone https://github.com/buiksat/dotfiles.git ~/dotfiles
```

## Daily sync

Pull latest dotfiles onto a machine:

```bash
cd ~/dotfiles
./sync.sh pull
```

Capture this machine's active terminal/editor configs and push them:

```bash
cd ~/dotfiles
./sync.sh push "sync terminal and editor configs"
```

Preview repo state:

```bash
cd ~/dotfiles
./sync.sh status
```

## Neovim

After installing on a fresh server, open Neovim once or run:

```bash
nvim --headless "+Lazy! sync" +qa
```

Then install language servers from inside Neovim with `:Mason`, or let Mason install them when configured.

## Secrets

Do not commit API keys or machine-specific tokens. Put private environment variables in `~/.extra` or a password manager-backed shell integration. This repo ignores `~/.extra` and `.env*` files.
