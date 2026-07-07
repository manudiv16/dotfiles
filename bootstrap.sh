#!/bin/bash
# bootstrap.sh - Symlink dotfiles to their expected locations
#
# Usage:
#   cd ~/dotfiles && ./bootstrap.sh

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

echo "🔗 Symlinking dotfiles from $DOTFILES_DIR..."

# Map of dotfiles to their targets
declare -A LINKS=(
	["$DOTFILES_DIR/.gitconfig"]="$HOME/.gitconfig"
	["$DOTFILES_DIR/.gitignore"]="$HOME/.gitignore"
	["$DOTFILES_DIR/.zshenv"]="$HOME/.zshenv"
	["$DOTFILES_DIR/.zshrc"]="$HOME/.zshrc"
	["$DOTFILES_DIR/.zprofile"]="$HOME/.zprofile"
	["$DOTFILES_DIR/.aerospace.toml"]="$HOME/.aerospace.toml"
	["$DOTFILES_DIR/.config/wezterm/wezterm.lua"]="$HOME/.config/wezterm/wezterm.lua"
	["$DOTFILES_DIR/.config/sketchybar/sketchybarrc"]="$HOME/.config/sketchybar/sketchybarrc"
	["$DOTFILES_DIR/.config/sketchybar/colors.sh"]="$HOME/.config/sketchybar/colors.sh"
	["$DOTFILES_DIR/.config/sketchybar/icons.sh"]="$HOME/.config/sketchybar/icons.sh"
)

# Create target directories if needed
mkdir -p "$HOME/.config/wezterm"
mkdir -p "$HOME/.config/sketchybar"

for src in "${!LINKS[@]}"; do
	target="${LINKS[$src]}"

	# Skip if source doesn't exist (some files may not be tracked yet)
	if [[ ! -f "$src" && ! -d "$src" ]]; then
		echo "  ⏭️  Source missing: $src (skipping)"
		continue
	fi

	# Remove existing file/symlink if present
	if [[ -e "$target" || -L "$target" ]]; then
		rm -f "$target"
	fi

	# Create parent directory if needed
	mkdir -p "$(dirname "$target")"

	# Create symlink
	ln -s "$src" "$target"
	echo "  ✅ $target -> $src"
done

echo ""
echo "✨ Dotfiles symlinked successfully!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell: exec zsh"
echo "  2. If using AeroSpace: restart it"
echo "  3. If using SketchyBar: run 'sketchybar --reload'"
