#!/usr/bin/env bash
# filepath: install-dependencies.sh

set -e

echo "Installing dependencies for LUMI AI Factory Container Recipes build environment..."

# Check if running on Ubuntu 24.04 LTS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ] || [ "$VERSION_ID" != "24.04" ]; then
        echo "Warning: This script is designed for Ubuntu 24.04 LTS. You are running: $PRETTY_NAME"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    echo "Warning: Cannot detect OS version. This script is designed for Ubuntu 24.04 LTS."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install required packages
echo "Installing required packages..."
sudo apt-get install -y \
    buildah \
    jq \
    podman \
    python3-ruamel.yaml \
    singularity-container \
    yq

# Check system architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo "Detected x86_64 architecture. Installing qemu-user-static for ARM builds..."
    sudo apt-get install -y qemu-user-static
fi

echo "Dependencies installed successfully!"
echo ""
echo "Installed packages:"
echo "  - buildah: $(buildah --version 2>/dev/null || echo 'not found')"
echo "  - jq: $(jq --version 2>/dev/null || echo 'not found')"
echo "  - podman: $(podman --version 2>/dev/null || echo 'not found')"
echo "  - python3-ruamel.yaml: $(python3 -c 'import ruamel.yaml; print(ruamel.yaml.version_info)' 2>/dev/null || echo 'not found')"
echo "  - singularity: $(singularity --version 2>/dev/null || echo 'not found')"
echo "  - yq: $(yq --version 2>/dev/null || echo 'not found')"
if [ "$ARCH" = "x86_64" ]; then
    echo "  - qemu-user-static: $(dpkg -l | grep qemu-user-static | awk '{print $3}' || echo 'not found')"
fi