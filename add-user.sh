#!/bin/bash

# Ask for username and password
read -p "Enter new username: " USERNAME
read -s -p "Enter password for $USERNAME: " PASSWORD
echo

# Create the user with a home directory and bash shell
sudo useradd -m -s /bin/bash "$USERNAME"

# Set the user's password
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Add user to sudo group
sudo usermod -aG sudo "$USERNAME"

# Add to docker group only if it exists
if getent group docker > /dev/null 2>&1; then
    sudo usermod -aG docker "$USERNAME"
    echo "User '$USERNAME' added to 'docker' group."
else
    echo "Group 'docker' does not exist. Skipping."
fi

# Confirm success
echo "User '$USERNAME' created and added to 'sudo' group."
