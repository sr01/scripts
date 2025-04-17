#!/bin/bash

set -e

# Update and install Samba
echo "Updating package list..."
sudo apt update

echo "Installing Samba..."
sudo apt install -y samba

# Create and set permissions for /share
echo "Setting up shared folder..."
sudo mkdir -p /share
sudo chown nobody:nogroup /share
sudo chmod 0775 /share

# Backup smb.conf and append configuration
echo "Configuring Samba..."
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

sudo tee -a /etc/samba/smb.conf > /dev/null <<EOL

[share]
   path = /share
   browsable = yes
   writable = yes
   guest ok = yes
   read only = no
   create mask = 0664
   directory mask = 0775
EOL

# Restart Samba service
echo "Restarting Samba service..."
sudo systemctl restart smbd.service

# Ask if user wants to allow authenticated access
read -p "Do you want to allow a user to log in to the Samba share? (y/n): " allow_user
if [[ "$allow_user" =~ ^[Yy]$ ]]; then
    read -p "Enter the existing Linux username to enable for Samba: " samba_user

    if id "$samba_user" &>/dev/null; then
        echo "Setting Samba password for user '$samba_user'..."
        sudo smbpasswd -a "$samba_user"
        sudo smbpasswd -e "$samba_user"

        echo "Changing ownership of /share to '$samba_user'..."
        sudo chown "$samba_user:$samba_user" /share

        echo "User '$samba_user' enabled for Samba and granted access to /share."
    else
        echo "User '$samba_user' does not exist. Please create the user first."
    fi
fi

# Install and enable Avahi
echo "Installing Avahi..."
sudo apt install -y avahi-daemon avahi-utils

echo "Enabling Avahi daemon..."
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon

echo "Checking Avahi status..."
sudo systemctl status avahi-daemon

echo "✅ Setup complete. You can now access the share over the network."

