#!/bin/bash

# Set config files in place
echo Copy all files and configurations to it\'s correct location...
cp -r .config/ $HOME/
cp -r .fonts/ $HOME/
cp -r .local/bin/ $HOME/.local/bin/
cp .bashrc $HOME/.bashrc

# Installing Catppuccin theme for Alacritty
Installing alacritty theme...
curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

# Prompt to install software via package manager
echo Installation done! Please select your desired package manager to complete the installation:
echo "1) apt (Debian/Ubuntu)"
echo "2) dnf (Fedora)"
echo "3) yum (RHEL)"
echo "4) zypper (OpenSU)"
echo "5) pacman (Arch)"
echo "6) I will install the software myself (check install_packages.txt)"
read -p "> " CHOICE

case $CHOICE in
  1)
    sudo apt update
    for i in $(cat install_packages.txt); do sudo apt install -y $i 2>>log.txt; done
    ;;
  2)
    for i in $(cat install_packages.txt); do sudo dnf install -y $i 2>>log.txt; done
    ;;
  3)
    for i in $(cat install_packages.txt); do sudo yum install -y $i 2>>log.txt; done
    ;;
  4)
    for i in $(cat install_packages.txt); do sudo zypper install -y $i 2>>log.txt; done
    ;;
  5)
    sudo pacman -Sy
    for i in $(cat install_packages.txt); do sudo pacman -S --noconfirm $i 2>>log.txt; done
    ;;
  6)
    echo "Please refer to install_packages.txt for the list of packages to install."
    ;;
  *)
    echo "Invalid choice. Please select a valid package manager option."
    ;;
esac

# Install latest npm version and yarn globally
sudo npm i -g npm@latest 2>>log.txt
sudo npm i -g yarn 2>>log.txt 

if [ -s log.txt ]; then
  echo Warning! Some packages were not installed. Please check log.txt for a detailed overview.
else
  echo Done! Everything installed successfully.
fi
