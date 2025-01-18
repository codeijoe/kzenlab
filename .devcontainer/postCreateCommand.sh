#!/usr/bin/env bash

wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt update
sudo apt install -yqq cmake
sudo apt install -yqq udisksctl
sudo apt install -yqq debootstrap
sudo apt install -yqq virtualbox
sudo apt install -yqq virtualbox-7.1
sudo apt install -yqq qemu-system
