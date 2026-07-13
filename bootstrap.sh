#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE=0
PULL=1
DRY_RUN=0

usage() {
	printf 'Usage: %s [--force|-f] [--no-pull] [--dry-run]\n' "$0"
}

while [ "$#" -gt 0 ]; do
	case "$1" in
		-f|--force)
			FORCE=1
			;;
		--no-pull)
			PULL=0
			;;
		--dry-run)
			DRY_RUN=1
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			usage >&2
			exit 2
			;;
	esac
	shift
done

cd "$ROOT"

if [ "$PULL" -eq 1 ] && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	git pull --ff-only origin main
fi

install_dotfiles() {
	rsync_args=(
		-avh
		--no-perms
		--exclude ".git/"
		--exclude ".DS_Store"
		--exclude ".macos"
		--exclude ".osx"
		--exclude "bootstrap.sh"
		--exclude "sync.sh"
		--exclude "README.md"
		--exclude "LICENSE-MIT.txt"
	)

	if [ "$DRY_RUN" -eq 1 ]; then
		rsync_args+=(--dry-run)
	fi

	rsync "${rsync_args[@]}" ./ "$HOME/"
}

if [ "$FORCE" -eq 1 ] || [ "$DRY_RUN" -eq 1 ]; then
	install_dotfiles
else
	read -r -p "This may overwrite files in $HOME. Continue? [y/N] " reply
	case "$reply" in
		[Yy]|[Yy][Ee][Ss])
			install_dotfiles
			;;
		*)
			printf 'Aborted.\n'
			exit 1
			;;
	esac
fi

if [ "$DRY_RUN" -eq 1 ]; then
	printf 'Dry run complete. No files were changed.\n'
else
	printf 'Dotfiles installed. Open a new shell or source your shell config to reload it.\n'
fi
