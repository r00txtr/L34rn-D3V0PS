#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# For CentOS / RHEL / Fedora

# Update package manager and install dependencies
sudo yum update -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo dnf -y install dnf-plugins-core

# Add Docker's repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install Docker packages
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker service
sudo systemctl enable --now docker

# Print success message
echo "Docker installation and setup completed successfully."

