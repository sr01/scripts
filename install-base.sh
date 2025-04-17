#!/bin/bash

set -e

echo "Installing zsh..."
sudo apt-get update
sudo apt-get install -y zsh curl git

echo "Changing default shell to zsh..."
chsh -s $(which zsh)

echo "Installing Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing Powerlevel10k theme..."
git clone https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Setting Powerlevel10k as the default theme in ~/.zshrc..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

P10K_CONFIG_URL="https://raw.githubusercontent.com/sr01/scripts/refs/heads/main/.p10k.zsh"

echo "Downloading .p10k.zsh from ${P10K_CONFIG_URL}..."
curl -fsSL "$P10K_CONFIG_URL" -o ~/.p10k.zsh

# Add sourcing line to .zshrc if not present
if ! grep -q "\.p10k\.zsh" ~/.zshrc; then
    echo '[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh' >> ~/.zshrc
fi

echo "Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Enabling plugins in ~/.zshrc..."
sed -i 's/^plugins=.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

echo "Sourcing ~/.zshrc to apply changes..."

# creates (or updates) the ~/.zprofile file to source the LXC login greeting script
ZPROFILE="$HOME/.zprofile"
LXC_GREETING='[[ -f /etc/profile.d/00_lxc-details.sh ]] && source /etc/profile.d/00_lxc-details.sh'

# Check if the line is already present
if grep -Fxq "$LXC_GREETING" "$ZPROFILE" 2>/dev/null; then
  echo ".zprofile already contains the LXC greeting line."
else
  echo "$LXC_GREETING" >> "$ZPROFILE"
  echo "Added LXC greeting to .zprofile."
fi

echo "✅ Zsh setup complete!"
echo "👉 Now run 'zsh' to start your new shell, or restart your terminal."
