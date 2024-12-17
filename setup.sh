#!/bin/bash

# Create a temp folder in the current location
mkdir temp

# Set config files in place
echo "Copy all files and configurations to it's correct location..."
cp -r .config/ $HOME/
cp -r .fonts/ $HOME/
cp -r .local/bin/ $HOME/.local/bin/
cp .bashrc $HOME/.bashrc

# OPTIONAL
# Installing Catppuccin theme for Alacritty
# echo Installing alacritty theme...
# curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml

# Prompt to install software via package manager
echo "Configuration files in place. Please select your desired package manager to complete the installation:"
echo "1) apt (Debian/Ubuntu)"
echo "2) dnf (Fedora)"
echo "3) yum (RHEL)"
echo "4) zypper (OpenSUSE)"
echo "5) pacman (Arch)"
echo "6) I will install the software myself (check installPackages.txt)"
read -p "> " CHOICE

while [[ ! $CHOICE =~ ^[1-6]$ ]]; do
    echo "Please enter a number between 1 and 6!"
    read -p "> " CHOICE
done

case $CHOICE in
  1)
    sudo apt update
    for i in $(cat installPackages.txt); do sudo apt install -y $i 2>>log.txt; done
    ;;
  2)
    for i in $(cat installPackages.txt); do sudo dnf install -y $i 2>>log.txt; done
    ;;
  3)
    for i in $(cat installPackages.txt); do sudo yum install -y $i 2>>log.txt; done
    ;;
  4)
    for i in $(cat installPackages.txt); do sudo zypper install -y $i 2>>log.txt; done
    ;;
  5)
    sudo pacman -Sy
    for i in $(cat installPackages.txt); do sudo pacman -S --noconfirm $i 2>>log.txt; done
    ;;
  6)
    echo "Please refer to installPackages.txt for the list of packages to install."
    ;;
esac

# Install latest npm version and yarn globally
echo "Installing yarn..."
sudo npm i -g npm@latest 2>>log.txt
sudo npm i -g yarn 2>>log.txt

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
rm -r temp

# Wrap up
if [ -s log.txt ]; then
  echo Warning! Some packages were not installed. Please check log.txt for a detailed overview.
else
  echo Done! Everything installed successfully.
fi
