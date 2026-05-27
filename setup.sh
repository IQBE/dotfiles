#!/usr/bin/env bash

echo "Backing up important files..."
mv ~/.bashrc ~/.bashrc.bak
sudo mv /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak

# Create a temp folder in the current location
mkdir temp

# Prompt to install software via package manager
echo "Please select your desired package manager to complete the installation:"
echo "1) apt (Debian/Ubuntu)"
echo "2) dnf (Fedora)"
echo "3) yum (RHEL)"
echo "4) zypper (OpenSUSE)"
echo "5) pacman (Arch)"
echo "6) Don't install system packages"
read -p "> " CHOICE

while [[ ! $CHOICE =~ ^[1-6]$ ]]; do
    echo "Please enter a number between 1 and 6!"
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
    echo "Warning: Not installing system packages may have side effects. Continuing setup..."
    ;;
esac

# Install latest npm version and yarn globally
echo "Installing yarn..."
sudo npm i -g npm@latest
sudo npm i -g yarn

# Generating ssh key
KEY_PATH="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY_PATH" ]; then
    echo "Generating SSH key for auth..."
    ssh-keygen -t ed25519 -f "$KEY_PATH"
else
    echo "SSH key already exists at $KEY_PATH"
fi

# Set config files in place
echo "Using stow to create the symbolic links..."
stow .
sudo stow -t / root-symlinks

# Remove temporary files
command rm -r temp

# Wrap up
echo "Your SSH public key for auth:"
cat "${KEY_PATH}.pub"
echo "Please remember to add your PGP key to sign the commits!"
if [ -s log.txt ]; then
  echo Done! A log.txt was generated containing detailed overview of problems that might have occured.
else
  echo Done! Everything installed successfully.
fi
