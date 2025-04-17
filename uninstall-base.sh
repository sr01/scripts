#!/bin/bash

set -e

echo "Reverting default shell to bash..."
chsh -s /bin/bash

echo "Removing Oh My Zsh..."
rm -rf ~/.oh-my-zsh
rm -f ~/.zshrc
rm -f ~/.p10k.zsh

echo "Uninstalling Zsh..."
sudo apt-get remove --purge -y zsh
sudo apt-get autoremove -y

echo "Cleaning up plugin directories..."
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k

echo "✅ Zsh and related components have been removed."
echo "Please restart your terminal or log out and log back in to fully switch back to Bash."
