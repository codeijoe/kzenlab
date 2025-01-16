######################################
# base-os.sh
######################################
# Kzenlab Builder  
# Copyright (C) 2024  Indra Wahjoedi<indra.wahjoedi@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
######################################
#!/bin/bash

function set_locale(){
	apt install locales -yqq && \
	sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' etc/locale.gen && \
	locale-gen
}

function set_kernel(){
	apt install -yqq linux-image-amd64 linux-image-generic dkms 
	set_locale
	# set_ssh_server
	# set_base_tools
	#dpkg-reconfigure -f noninteractive tzdata 
}

function set_grub(){
	#echo -e "set_grub()>>>> $1"

	apt install -yqq --no-install-recommends \
	grub-efi-amd64 grub-efi-amd64-signed \
	grub-efi-amd64-signed efibootmgr efivar \
	efitools shim-signed

	set_devicemap $1
	sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=\"\).*/\1console=tty0 console=ttyS0,115200n8"/' /etc/default/grub

	update-grub 
}

function set_secure_boot(){
	apt install -yqq debian-secure-boot
    update-secureboot-policy --enroll-key /usr/share/debian-secure-boot/debian-secure-boot-ca.crt
}

function set_devicemap() {
	echo -e "set_devicemap()>>>> $1"
	esp_uuid=$(blkid -s UUID -o value $1p1)
	root_uuid=$(blkid -s UUID -o value $1p3)
 	
 	# Print both UUIDs with proper formatting
    echo -e "ESP UUID: $esp_uuid"
    echo -e "Root UUID: $root_uuid"

    echo "UUID=$root_uuid / ext4 defaults,rw 0 1" > /etc/fstab

    cat << EOF > /boot/grub/device.map 
(hd0)   $1

EOF
}

function set_uefi(){
	# NEED VBOX TO TEST SECUREBOOT
    grub-install --verbose --target=x86_64-efi $1 --bootloader-id=GRUB --modules="tpm" --efi-directory=/boot/efi --boot-directory=/boot --uefi-secure-boot --removable && \
    update-grub
	#echo -e "SETTT UEFI.DONE ${1} "
}

function set_ssh_server(){
	apt install -yqq openssh-server
	#systemctl enable --now ssh
}

function set_os_default(){
	#echo ">>> ${1}"
	echo "root:kzenlab" | chpasswd
	useradd -m -s /bin/bash kzen
	echo "kzen:kzenlab" | chpasswd
	#hostnamectl set-hostname $1 
}

function set_base_tools(){
	DEBIAN_FRONTEND=noninteractive apt install -yqq vim nano less wget curl git zsh

	#DEBIAN_FRONTEND=noninteractive apt install -y xorg xserver-xorg xserver-xorg-core xserver-xorg-legacy x11-xserver-utils xserver-xorg-input-all -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
	 
}

function set_motd(){
	cat << EOF > /etc/update-motd.d/00-header
#!/bin/sh
export TERM=linux
clear
printf "\n"
printf "'##:::'##:'########:'########:'##::: ##:'##::::::::::'###::::'########::\n"
printf " ##::'##::..... ##:: ##.....:: ###:: ##: ##:::::::::'## ##::: ##.... ##:\n"
printf " ##:'##::::::: ##::: ##::::::: ####: ##: ##::::::::'##:. ##:: ##:::: ##:\n"
printf " #####::::::: ##:::: ######::: ## ## ##: ##:::::::'##:::. ##: ########::\n"
printf " ##. ##::::: ##::::: ##...:::: ##. ####: ##::::::: #########: ##.... ##:\n"
printf " ##:. ##::: ##:::::: ##::::::: ##:. ###: ##::::::: ##.... ##: ##:::: ##:\n"
printf " ##::. ##: ########: ########: ##::. ##: ########: ##:::: ##: ########::\n"
printf "..::::..::........::........::..::::..::........::..:::::..::........:::\n"
printf "Ver 0.1.5-SNAPSHOT Codeijoe (c)2024. Indra Wahjoedi<indra.wahjoedi@gmail.com>\n"
printf "Kzenlab is pronounced as "kei-zen-lab"\n"
printf "Provide by @itwahjoedi to support Codeijoe Open Mentorship\n"
printf "\n"
EOF

	chmod +x /etc/update-motd.d/00-header
}


function wawa(){
apt install -yqq xorg xserver-xorg xserver-xorg-core xserver-xorg-legacy x11-xserver-utils xserver-xorg-input-all 
cat << EOF
# Minimal X11
-- Install with DVD
apt install -y xorg xserver-xorg xserver-xorg-core xserver-xorg-legacy x11-xserver-utils xserver-xorg-input-all 
apt install -y xserver-xorg-video-all x11-xkb-utils x11-utils xinit network-manager 
apt install -y xterm inxi screen lightdm 
apt install -y xserver-xorg-video-fbdev xserver-xorg-video-vmware python3-xdg dbus-x11 

# Require Tools
----- Tools
apt install -y zsh htop
apt build-essential zlib1g-dev

-- install with REPO
!!apt install -y xbacklight xbindkeys xvkbd xinput x11vnc minicom (77MB)
!!apt install -y xserver-xorg-video-dummy  xserver-xorg-video-cirrus (62KB)


EOF

}