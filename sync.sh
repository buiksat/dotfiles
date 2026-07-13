#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

usage() {
	cat <<'USAGE'
Usage:
  ./sync.sh status
  ./sync.sh capture
  ./sync.sh push [commit message]
  ./sync.sh pull

Commands:
  status   Show dotfiles Git status.
  capture  Copy selected live configs from $HOME into this repo.
  push     Capture, commit if needed, and push to origin/main.
  pull     Pull origin/main and install dotfiles into $HOME.
USAGE
}

copy_file() {
	src="$1"
	dst="$2"

	if [ ! -f "$src" ]; then
		return 0
	fi

	mkdir -p "$(dirname "$dst")"
	rsync -a "$src" "$dst"
}

capture() {
	copy_file "$HOME/.tmux.conf" "$ROOT/.tmux.conf"
	copy_file "$HOME/.config/kitty/kitty.conf" "$ROOT/.config/kitty/kitty.conf"
	copy_file "$HOME/.config/karabiner/karabiner.json" "$ROOT/.config/karabiner/karabiner.json"
	copy_file "$HOME/.config/nvim/init.lua" "$ROOT/.config/nvim/init.lua"
	copy_file "$HOME/.config/nvim/lazy-lock.json" "$ROOT/.config/nvim/lazy-lock.json"
}

cmd="${1:-status}"
case "$cmd" in
	status)
		git status --short --branch
		;;
	capture)
		capture
		git status --short --branch
		;;
	push)
		shift || true
		message="${*:-sync dotfiles}"
		capture
		git add \
			.tmux.conf \
			.config/kitty/kitty.conf \
			.config/karabiner/karabiner.json \
			.config/nvim/init.lua \
			.config/nvim/lazy-lock.json \
			.zshrc \
			.gitignore \
			bootstrap.sh \
			sync.sh \
			README.md \
			.local/bin/tmux-copy

		if git diff --cached --quiet; then
			printf 'No dotfile changes to commit.\n'
		else
			git commit -m "$message"
			git push origin main
		fi
		;;
	pull)
		git pull --ff-only origin main
		"$ROOT/bootstrap.sh" --force --no-pull
		;;
	-h|--help)
		usage
		;;
	*)
		usage >&2
		exit 2
		;;
esac
