#!/bin/bash
set -e

# Install Code-Server (VS Code in Browser)
echo "Installing VS Code Server..."
curl -fsSL https://code-server.dev/install.sh | sh

# Setup systemd service pattern (so we can start it for specific users later)
# This proves you understand systemd/Linux internals
systemctl enable --now code-server@ubuntu