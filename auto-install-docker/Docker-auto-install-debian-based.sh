#!/bin/bash

# For Debian / Ubuntu / Linux Mint

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl

# Create directory for Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's repository to Apt sources
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Docker group and set permissions
sudo groupadd -f docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Print success message
echo "Docker installation and setup completed successfully. Please log out and log back in to apply group changes."

