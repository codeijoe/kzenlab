#!/usr/bin/env bash

echo "Running postCreateCommand.sh as user: $(whoami)"

# Install additional tools (requires sudo for non-root)
sudo apt update && sudo apt install -yqq \
    vim \
    htop \
    udisks2 \
    debootstrap \
    qemu-system \


wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt install -yqq virtualbox-7.1

# Configure environment (example)
echo "export PATH=$PATH:/custom/path" >> ~/.bashrc

# Verify installation
echo "Installed packages:"
dpkg -l | grep vim

# Print completion message
echo "Post-create steps completed successfully!"


