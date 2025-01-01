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
	apt install locales -y && \
	sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	locale-gen
}

function set_kernel(){
	apt install -y linux-image-amd64
}

function set_grub(){
	#apt install -y --no-install-recommends -o Dpkg::Options::="--force-confold" grub-efi-amd64 \
	#grub-efi-amd64-signed refind  \
	#efibootmgr efivar efitools

	#DEBIAN_FRONTEND=noninteractive apt install -y grub-efi-amd64-signed
	echo "SETTT GRUB.DONE"
}

function set_uefi(){
	echo "SETTT UEFI.DONE"
}


#COMMAND bash -c "sudo grub-install --target=x86_64-efi `grep -oP '\/[A-Za-z0-9]+' ${LOG_LOOPS}` --bootloader-id=GRUB --modules=tpm --efi-directory=`grep -oP '\/[A-Za-z0-9]+' ${LOG_EFI}` --boot-directory=`grep -oP '\/[A-Za-z0-9]+' ${LOG_EFI}`/EFI/BOOT --uefi-secure-boot --removable"

