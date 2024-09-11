#!/bin/bash

# Set config files in place
cp .config $HOME/.config

# Installing Catppuccin theme for Alacritty
curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

# Prompt to install software
echo Installation done! Please install the packages in 'install_packages.txt' manually.
