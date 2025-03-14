#!/bin/bash

# Create a temp folder in the current location
mkdir temp

# Prompt to install software via package manager
echo "Please select your desired package manager to complete the installation:"
echo "1) apt (Debian/Ubuntu)"
echo "2) dnf (Fedora)"
echo "3) yum (RHEL)"
echo "4) zypper (OpenSUSE)"
echo "5) pacman (Arch)"
echo "6) Cancel..."
read -p "> " CHOICE

while [[ ! $CHOICE =~ ^[1-5]$ ]]; do
    echo "Please enter a number between 1 and 5!"
    read -p "> " CHOICE
done

case $CHOICE in
  1)
    sudo apt update
    for i in $(cat installPackages.txt); do sudo apt install -y $i; done
    ;;
  2)
    for i in $(cat installPackages.txt); do sudo dnf install -y $i; done
    ;;
  3)
    for i in $(cat installPackages.txt); do sudo yum install -y $i; done
    ;;
  4)
    for i in $(cat installPackages.txt); do sudo zypper install -y $i; done
    ;;
  5)
    sudo pacman -Sy
    for i in $(cat installPackages.txt); do sudo pacman -S --noconfirm $i; done
    ;;
  6)
    exit
    ;;
esac

# Install latest npm version and yarn globally
echo "Installing yarn..."
sudo npm i -g npm@latest
sudo npm i -g yarn

# Set config files in place
echo "Using stow to create the symbolic links..."
mv ~/.bashrc ~/.bashrc.bak
stow .

# OPTIONAL
# Installing Catppuccin theme for Alacritty
# echo Installing alacritty theme...
# curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml


# Install keyd and configure
read -p "Do you want to install keyd and setup my keybinds? [y/N] " yn

case $yn in
  [yY] ) cd temp;
    git clone https://github.com/rvaiya/keyd;
    cd keyd;
    make && sudo make install;
    cd ../..;
    sudo cp keyd/default.conf /etc/keyd/default.conf;
    sudo systemctl enable keyd && sudo systemctl start keyd;;
  * ) echo "Skipping keyd...";;
esac

# Remove temporary files
command rm -r temp

# Wrap up
if [ -s log.txt ]; then
  echo Done! A log.txt was generated containing detailed overview of problems that might have occured.
else
  echo Done! Everything installed successfully.
fi
