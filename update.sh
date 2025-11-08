#!/usr/bin/env bash

set -euo pipefail

echo "Updating dotfiles..."

echo "Restowing files..."
stow .
sudo stow -t / root-symlinks

echo "Update completed!"
