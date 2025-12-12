#!/bin/bash
set -e

# 1. Update & Install Utilities
echo "Installing Base Utilities..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl wget git unzip zsh build-essential

# 2. Install Docker (The Hard Way - shows Linux knowledge)
echo "Installing Docker..."
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu

# 3. Configure Firewall (UFW) - Security Requirement
echo "Configuring Firewall..."
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw --force enable