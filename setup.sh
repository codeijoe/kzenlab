#!/bin/bash
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

# DESC: Define Common Vars 
LANG=en_US.UTF-8
LANGUAGE=en_US:en
LC_ALL=en_US.UTF-8
FORCE_COLOR=0
NO_COLOR=1
OSVERSION=$(uname)


## LOCAL ENV
_qemu_home=default 
_vbox_home=default 
_vbox_vm_home=default
_vbox_disk_home=default
_iso_home=default 
_vm_name=default 
_vm_domain=default
_vm_hostname=default
_hyper_type=default
_vm_disk_size=default
_disk_efi=default
_disk_swap=default
_disk_root=default
_dvd1=default
_dvd2=default
_dvd3=default
_dvd4=default
_dvd5=default
_dvd6=default
_dvd7=default
_dvd8=default
_dvd9=default
_dvd10=default
_dvd11=default
_dvd12=default
_dvd13=default
_dvd14=default
_dvd15=default
_dvd16=default
_dvd17=default
_dvd18=default
_dvd19=default
_dvd20=default
_dvd21=default

## Local VARS
_device=default
_loops=default
_verbose=""



##### Functions #####

# DESC: Define Script Debugging
# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
    _verbose=--verbose
fi

# Only enable these shell behaviours if we're not being sourced
# Approach via: https://stackoverflow.com/a/28776166/8787985
if ! (return 0 2> /dev/null); then
    # A better class of script...
    set -o errexit      # Exit on most errors (see the manual)
    set -o nounset      # Disallow expansion of unset variables
    set -o pipefail     # Use last non-zero exit code in a pipeline
fi

# Enable errtrace or the error trap handler will not work as expected
set -o errtrace         # Ensure the error trap handler is inherited

# DESC: Import external .env file to script
# ARGS: None
# OUTS: None
# RETS: None
function import_env() {
	_iso_home=$(grep -F -- "ISO_HOME" .env | cut -d'=' -f2)
	_dvd1=$(grep -F -- "DVD_01" .env | cut -d'=' -f2)
	_dvd2=$(grep -F -- "DVD_02" .env | cut -d'=' -f2)
	_dvd3=$(grep -F -- "DVD_03" .env | cut -d'=' -f2)
	_dvd4=$(grep -F -- "DVD_04" .env | cut -d'=' -f2)
	_dvd5=$(grep -F -- "DVD_05" .env | cut -d'=' -f2)
	_dvd6=$(grep -F -- "DVD_06" .env | cut -d'=' -f2)
	_dvd7=$(grep -F -- "DVD_07" .env | cut -d'=' -f2)
	_dvd8=$(grep -F -- "DVD_08" .env | cut -d'=' -f2)
	_dvd9=$(grep -F -- "DVD_09" .env | cut -d'=' -f2)
	_dvd10=$(grep -F -- "DVD_10" .env | cut -d'=' -f2)
	_dvd11=$(grep -F -- "DVD_11" .env | cut -d'=' -f2)
	_dvd12=$(grep -F -- "DVD_12" .env | cut -d'=' -f2)
	_dvd13=$(grep -F -- "DVD_13" .env | cut -d'=' -f2)
	_dvd14=$(grep -F -- "DVD_14" .env | cut -d'=' -f2)
	_dvd15=$(grep -F -- "DVD_15" .env | cut -d'=' -f2)
	_dvd16=$(grep -F -- "DVD_16" .env | cut -d'=' -f2)
	_dvd17=$(grep -F -- "DVD_17" .env | cut -d'=' -f2)
	_dvd18=$(grep -F -- "DVD_18" .env | cut -d'=' -f2)
	_dvd19=$(grep -F -- "DVD_19" .env | cut -d'=' -f2)
	_dvd20=$(grep -F -- "DVD_20" .env | cut -d'=' -f2)
	_dvd21=$(grep -F -- "DVD_21" .env | cut -d'=' -f2)
    _qemu_home=$(grep -F -- "QEMU_HOME" .env | cut -d'=' -f2)
    _vbox_home=$(grep -F -- "VBOX_HOME" .env | cut -d'=' -f2)
    _vbox_vm_home=$(grep -F -- "VBOX_VM_HOME" .env | cut -d'=' -f2)
    _vbox_disk_home=$(grep -F -- "VBOX_DISK_HOME" .env | cut -d'=' -f2)
    _vm_hyper_type=$(grep -F -- "VM_HYPER_TYPE" .env | cut -d'=' -f2)
    _vm_name=$(grep -F -- "VM_NAME" .env | cut -d'=' -f2)
    _vm_hostname=$(grep -F -- "VM_HOSTNAME" .env | cut -d'=' -f2)
    _vm_domain=$(grep -F -- "VM_DOMAIN" .env | cut -d'=' -f2)
    _vm_disk_size=$(grep -F -- "VM_DISK_SIZE" .env | cut -d'=' -f2)
    _disk_root=$(grep -F -- "DISK_ROOT" .env | cut -d'=' -f2)
    _disk_swap=$(grep -F -- "DISK_SWAP" .env | cut -d'=' -f2)
    _disk_efi=$(grep -F -- "DISK_EFI" .env | cut -d'=' -f2)

}


# DESC: Setup CMAKE
# ARGS: None
# OUTS: None
# RETS: None
function setup_cmake(){
    if ! [[ -d build/log ]]; then
		mkdir -p build/log
    fi
	cmake -S . -B build \
-DISO_HOME=$_iso_home \
-DVBOX_HOME=$_vbox_home \
-DVBOX_DISK_HOME=$_vbox_disk_home \
-DVBOX_VM_HOME=$_vbox_vm_home \
-DVM_HYPER_TYPE=$_vm_hyper_type \
-DVM_DISK_SIZE=$_vm_disk_size \
-DVM_NAME=$_vm_name \
-DVM_HOSTNAME=$_vm_hostname \
-DVM_DOMAIN=$_vm_domain \
-DDISK_EFI=$_disk_efi \
-DDISK_SWAP=$_disk_swap \
-DDISK_ROOT=$_disk_root 
	cmake --build build --target check_tools
	cmake --build build --target print_vm_env
	cmake --build build --target write_vm_env
}

# DESC: Clean CMAKE
# ARGS: None
# OUTS: None
# RETS: None
function clean_cmake(){
	unmount_linux && \
	unloop && \
	sudo rm -rf build/*   

	#cmake --build build --target clean_cmake
}

# DESC: Build empty virtual disk
# ARGS: None
# OUTS: None
# RETS: None
function build_raw_disk(){
    cmake --build build --target create_raw_disk $_verbose && \
    cmake --build build --target mounting_raw_disk $_verbose
}

function download_debian9(){
	cmake --build build --target download_debian9	
}

function download_debian12(){
	cmake --build build --target download_debian12	
}

function unpack_debian9(){
	cmake --build build --target unpack_debian9
}

function unpack_debian12(){
	cmake --build build --target unpack_debian12 $_verbose
}

function unloop(){
    echo "UNLOOP()"
	# Unloop RAWDISK
    _devloop=$(losetup -a | grep $_vm_name | cut -d' ' -f1 | grep -oE '/dev/loop[0-9]+' )

    echo $_devloop

    if [[ -n "$_devloop" ]]; then
    	losetup -d $_devloop
    	if [ $? -ne 0 ]; then
    		echo "Error unloop..."
    	else
	    	echo $_devloop" unloopped"
		fi
    else
	    echo "Loop device already unloopped"
	fi
}

function start_qemu_uefi(){
	_dvdxfce=debian-live-12.8.0-amd64-xfce.iso
	#-drive file=$_iso_home/$_dvdxfce,media=cdrom \
	
	_file=$_vm_name
	_file+='.raw'
	#echo $_file
	qemu-system-x86_64 \
	-m 2048M \
	-drive file=build/$_file,format=raw,if=virtio \
	-enable-kvm \
	-bios /usr/share/OVMF/OVMF_CODE.fd \
	-boot c
	#-boot menu=on
}

function create_vmdk(){
	_devloop=$(losetup -a | grep $_vm_name | cut -d' ' -f1 | grep -oE '/dev/loop[0-9]+')
	echo $_devloop 
	#vboxmanage closemedium disk build/$_vm_name'.vmdk'
	rm -rf build/$_vm_name'.vmdk'
	vboxmanage createmedium disk \
	--filename build/$_vm_name'.vmdk' \
	--format=VMDK \
	--variant RawDisk \
	--property RawDrive=$_devloop
}

function create_usb_vmdk(){
	_device=$1
	echo $_device 
	rm -rf build/usb.vmdk
	vboxmanage createmedium disk \
	--filename build/usb.vmdk \
	--format=VMDK \
	--variant RawDisk \
	--property RawDrive=$_device
}

function create_usb_vboxvm(){
	# System
	_vm_name="USB-OS"
	vboxmanage createvm --basefolder=$_vbox_vm_home --name $_vm_name --register 
	vboxmanage modifyvm $_vm_name --description "Klaudizen Lab"
	vboxmanage modifyvm $_vm_name --memory=2048 --vram=128 --acpi=on --ioapic=on --cpus=2 --pae=on --long-mode=on
	vboxmanage modifyvm $_vm_name --hwvirtex=on --paravirt-provider=kvm --nested-paging=on --nested-hw-virt=on
	vboxmanage modifyvm $_vm_name --chipset=piix3
	#vboxmanage modifyvm $_vm_name --boot1=disk 
	vboxmanage modifyvm $_vm_name --graphicscontroller vmsvga
	vboxmanage modifyvm $_vm_name --tpm-type 2.0 
	vboxmanage modifyvm $_vm_name --firmware efi64 
	VBoxManage modifynvram $_vm_name inituefivarstore
	vboxmanage modifynvram $_vm_name enrollmssignatures
	vboxmanage modifynvram $_vm_name enrollorclpk

	# Other
	vboxmanage modifyvm $_vm_name --mouse=ps2 --keyboard=ps2   
	vboxmanage modifyvm $_vm_name --uart1 0x3f8 4 --uart-type1=16550A --uart-mode1 server /tmp/vbox

	# Network
	vboxmanage modifyvm $_vm_name --nic1=nat --nic-type1=Am79C973 --cable-connected1=on
	vboxmanage modifyvm $_vm_name --nat-pf1 "SSH,tcp,,2200,,22"
	vboxmanage modifyvm $_vm_name --nat-pf1 "VNC,tcp,,15900,,5900"

	# Storage
	vboxmanage storagectl $_vm_name --name "SATA01" --add sata --controller IntelAHCI

	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 0 --device 0 --type hdd --medium build/usb.vmdk
}


function create_vboxvm(){
	# System
	vboxmanage createvm --basefolder=$_vbox_vm_home --name $_vm_name --register 
	vboxmanage modifyvm $_vm_name --description "Klaudizen Lab"
	vboxmanage modifyvm $_vm_name --memory=2048 --vram=128 --acpi=on --ioapic=on --cpus=2 --pae=on --long-mode=on
	vboxmanage modifyvm $_vm_name --hwvirtex=on --paravirt-provider=kvm --nested-paging=on --nested-hw-virt=on
	vboxmanage modifyvm $_vm_name --chipset=piix3
	#vboxmanage modifyvm $_vm_name --boot1=disk 
	vboxmanage modifyvm $_vm_name --graphicscontroller vmsvga
	vboxmanage modifyvm $_vm_name --tpm-type 2.0 
	vboxmanage modifyvm $_vm_name --firmware efi64 
	VBoxManage modifynvram $_vm_name inituefivarstore
	vboxmanage modifynvram $_vm_name enrollmssignatures
	vboxmanage modifynvram $_vm_name enrollorclpk

	# Other
	vboxmanage modifyvm $_vm_name --mouse=ps2 --keyboard=ps2   
	vboxmanage modifyvm $_vm_name --uart1 0x3f8 4 --uart-type1=16550A --uart-mode1 server /tmp/vbox

	# Network
	vboxmanage modifyvm $_vm_name --nic1=nat --nic-type1=Am79C973 --cable-connected1=on
	vboxmanage modifyvm $_vm_name --nat-pf1 "SSH,tcp,,2200,,22"
	vboxmanage modifyvm $_vm_name --nat-pf1 "VNC,tcp,,15900,,5900"

	# Storage
	vboxmanage storagectl $_vm_name --name "SATA01" --add sata --controller IntelAHCI

	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 0 --device 0 --type hdd --medium build/$_vm_name'.vmdk'

	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 1 --device 0 --type dvddrive --medium $_iso_home/$_dvd1
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 2 --device 0 --type dvddrive --medium $_iso_home/$_dvd2
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 3 --device 0 --type dvddrive --medium $_iso_home/$_dvd3
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 4 --device 0 --type dvddrive --medium $_iso_home/$_dvd4
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 5 --device 0 --type dvddrive --medium $_iso_home/$_dvd5
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 6 --device 0 --type dvddrive --medium $_iso_home/$_dvd6
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 7 --device 0 --type dvddrive --medium $_iso_home/$_dvd7
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 8 --device 0 --type dvddrive --medium $_iso_home/$_dvd8
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 9 --device 0 --type dvddrive --medium $_iso_home/$_dvd9
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 10 --device 0 --type dvddrive --medium $_iso_home/$_dvd10
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 11 --device 0 --type dvddrive --medium $_iso_home/$_dvd11
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 12 --device 0 --type dvddrive --medium $_iso_home/$_dvd12
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 13 --device 0 --type dvddrive --medium $_iso_home/$_dvd13
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 14 --device 0 --type dvddrive --medium $_iso_home/$_dvd14
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 15 --device 0 --type dvddrive --medium $_iso_home/$_dvd15
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 16 --device 0 --type dvddrive --medium $_iso_home/$_dvd16
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 17 --device 0 --type dvddrive --medium $_iso_home/$_dvd17
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 18 --device 0 --type dvddrive --medium $_iso_home/$_dvd18
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 19 --device 0 --type dvddrive --medium $_iso_home/$_dvd19
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 20 --device 0 --type dvddrive --medium $_iso_home/$_dvd20
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 21 --device 0 --type dvddrive --medium $_iso_home/$_dvd21

	# Must detach dvd1 otherwise boot will go to DVD1
	vbox_dettach_dvd1
	
	#vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 1 --device 0 --type dvddrive --medium none
	
	#vboxmanage showvminfo $VM_NAME
	#vboxmanage startvm $VM_NAME -type headless
	#vboxmanage startvm $VM_NAME -type gui
	#vboxmanage controlvm $VM_NAME reset
	#vboxmanage controlvm $VM_NAME poweroff
}

function vbox_attach_dvd1(){
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 1 --device 0 --type dvddrive --medium $_iso_home/$_dvd1
}

function vbox_dettach_dvd1(){
	# while VM off
	echo "WARN! VM should be non-active state"
	vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 1 --device 0 --type dvddrive --medium emptydrive 

	#vboxmanage storageattach $_vm_name --storagectl "SATA01" --port 1 --device 0 --type dvddrive --medium none
}


function remove_vboxvm(){
	vboxmanage unregistervm $_vm_name --delete
}

function remove_usb_vboxvm(){
	_vm_name="USB-OS"
	vboxmanage unregistervm $_vm_name --delete
}


function unmount_linux(){

	## /dev
	if mount | grep -q "on /media/$USER/root/dev "; then
		mount | grep ${USER}'/root/dev' | cut -d' ' -f3 | sort -r | xargs -I {} sudo umount {}
    	echo "/root/dev unmounted"
	fi
	if ! mount | grep -q "on /media/$USER/root/dev "; then
    	rm -rf build/log/linux-dev
	fi


	## /sys
	if mount | grep -q "on /media/$USER/root/sys "; then
    	mount | grep ${USER}'/root/sys/' | cut -d' ' -f3 | xargs -I {} sudo umount {}
	fi

	if mount | grep -q "on /media/$USER/root/sys "; then
    	sudo umount /media/$USER/root/sys
    	echo "/root/sys unmounted"
	fi
	if ! mount | grep -q "on /media/$USER/root/sys "; then
    	rm -rf build/log/linux-sys
	fi

	## /proc
	if mount | grep -q "on /media/$USER/root/proc "; then
		mount | grep ${USER}'/root/proc' | cut -d' ' -f3 | sort -r | xargs -I {} sudo umount {}
    	echo "/root/proc unmounted"
	fi
	if mount | grep -q "on /media/$USER/root/proc "; then
    	sudo umount /media/$USER/root/proc
    	echo "/root/proc unmounted2"
	fi
	if ! mount | grep -q "on /media/$USER/root/proc "; then
    	rm -rf build/log/linux-proc
	fi

	# Run
	if mount | grep -q "on /media/$USER/root/run "; then
		mount | grep ${USER}'/root/run/user/1000' | cut -d' ' -f3 | sort -r | xargs -I {} sudo umount {}
	fi
	if mount | grep -q "on /media/$USER/root/run "; then
		mount | grep ${USER}'/root/run' | cut -d' ' -f3 | sort -r | xargs -I {} sudo umount {}
    	echo "/root/run unmounted"
	fi
	if ! mount | grep -q "on /media/$USER/root/run "; then
    	rm -rf build/log/linux-run
	fi

	_loops_p1=$(losetup -a | grep $_vm_name | cut -d' ' -f1 | grep -oE '/dev/loop[0-9]+')
	_loops_p3=$(losetup -a | grep $_vm_name | cut -d' ' -f1 | grep -oE '/dev/loop[0-9]+')
	_loops_p1+="p1"
	_loops_p3+="p3"

    # EFI
	if mount | grep -q "on /media/$USER/root/boot/efi "; then
		sudo umount /media/$USER/root/boot/efi
    	#echo $_loops_p1" unmounted"
	fi
	if mount | grep -q "on /media/$USER/EFI "; then
    	udisksctl unmount -b $_loops_p1
    	echo $_loops_p1" unmounted"
	fi
	if ! mount | grep -q "on /media/$USER/EFI "; then
    	rm -rf build/log/efi
	fi

	# ROOT
	if mount | grep -q "on /media/$USER/root "; then
    	udisksctl unmount -b $_loops_p3
    	echo $_loops_p3" unmounted"
	fi
	if ! mount | grep -q "on /media/$USER/root "; then
    	rm -rf build/log/root
	fi

}

function remounting(){
	echo "WARN: Remouting at base-os stage"

	if [ -f build/log/loops ] ; then
    	rm build/log/loops
	fi
	if [ -f build/log/loops ] ; then
    	rm build/log/root
	fi
	if [ -f build/log/loops ] ; then
    	rm build/log/efi
	fi
	if [ -f build/log/linux-dev ] ; then
    	rm build/log/linux-dev
	fi
	if [ -f build/log/linux-proc ] ; then
    	rm build/log/linux-proc
	fi
	if [ -f build/log/linux-sys ] ; then
    	rm build/log/linux-sys
	fi
	if [ -f build/log/linux-pts ] ; then
    	rm build/log/linux-pts
	fi
	if [ -f build/log/linux-pts ] ; then
    	rm build/log/linux-run
	fi
	if  ! mount | grep -q "on /media/$USER/root " ; then
		cmake --build build --target make_loops_mounted $_verbose && \
		cmake --build build --target mounting_linux $_verbose
	fi
}

function set_repo_active(){
	sudo cp -f base-os/debian.list /media/$USER/root/etc/apt/sources.list.d/
}

function set_repo_deactive(){
	sudo rm -rf /media/$USER/root/etc/apt/sources.list.d/debian.list
}

function mount_dvd(){
	mount_dvd1 && \
	mount_dvd2 && \
	mount_dvd3 && \
	mount_dvd4 && \
	mount_dvd5 && \
	mount_dvd6 && \
	mount_dvd7 && \
	mount_dvd8 && \
	mount_dvd9 && \
	mount_dvd10 && \
	mount_dvd11 && \
	mount_dvd12 && \
	mount_dvd13 && \
	mount_dvd14 && \
	mount_dvd15 && \
	mount_dvd16 && \
	mount_dvd17 && \
	mount_dvd18 && \
	mount_dvd19 && \
	mount_dvd20 && \
	mount_dvd21 && \
	sudo cp -f base-os/DVD.list /media/$USER/root/etc/apt/sources.list.d/
}

function unmount_dvd(){
	unmount_dvd1 && \
	unmount_dvd2 && \
	unmount_dvd3 && \
	unmount_dvd4 && \
	unmount_dvd5 && \
	unmount_dvd6 && \
	unmount_dvd7 && \
	unmount_dvd8 && \
	unmount_dvd9 && \
	unmount_dvd10 && \
	unmount_dvd11 && \
	unmount_dvd12 && \
	unmount_dvd13 && \
	unmount_dvd14 && \
	unmount_dvd15 && \
	unmount_dvd16 && \
	unmount_dvd17 && \
	unmount_dvd18 && \
	unmount_dvd19 && \
	unmount_dvd20 && \
	unmount_dvd21 && \
	sudo rm -rf /media/$USER/root/etc/apt/sources.list.d/DVD.list
}

function mount_dvd1(){
	if  ! mount | grep -q "DVD1"  ; then
    	sudo mkdir -p /mnt/DVD1 && sudo mkdir -p /media/$USER/root/mnt/DVD1 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd1 /mnt/DVD1 && \
		sudo mount --bind /mnt/DVD1 /media/$USER/root/mnt/DVD1
	fi
}

function mount_dvd2(){
	if  ! mount | grep -q "DVD2"  ; then
    	sudo mkdir -p /mnt/DVD2 && sudo mkdir -p /media/$USER/root/mnt/DVD2 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd2 /mnt/DVD2 && \
		sudo mount --bind /mnt/DVD2 /media/$USER/root/mnt/DVD2
	fi
}

function mount_dvd3(){
	if  ! mount | grep -q "DVD3"  ; then
    	sudo mkdir -p /mnt/DVD3 && sudo mkdir -p /media/$USER/root/mnt/DVD3 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd3 /mnt/DVD3 && \
		sudo mount --bind /mnt/DVD3 /media/$USER/root/mnt/DVD3
	fi
}

function mount_dvd4(){
	if  ! mount | grep -q "DVD4"  ; then
    	sudo mkdir -p /mnt/DVD4 && sudo mkdir -p /media/$USER/root/mnt/DVD4 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd4 /mnt/DVD4 && \
		sudo mount --bind /mnt/DVD4 /media/$USER/root/mnt/DVD4
	fi
}

function mount_dvd5(){
	if  ! mount | grep -q "DVD5"  ; then
    	sudo mkdir -p /mnt/DVD5 && sudo mkdir -p /media/$USER/root/mnt/DVD5 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd5 /mnt/DVD5 && \
		sudo mount --bind /mnt/DVD5 /media/$USER/root/mnt/DVD5
	fi
}

function mount_dvd6(){
	if  ! mount | grep -q "DVD6"  ; then
    	sudo mkdir -p /mnt/DVD6 && sudo mkdir -p /media/$USER/root/mnt/DVD6 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd6 /mnt/DVD6 && \
		sudo mount --bind /mnt/DVD6 /media/$USER/root/mnt/DVD6
	fi
}

function mount_dvd7(){
	if  ! mount | grep -q "DVD7"  ; then
    	sudo mkdir -p /mnt/DVD7 && sudo mkdir -p /media/$USER/root/mnt/DVD7 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd7 /mnt/DVD7 && \
		sudo mount --bind /mnt/DVD7 /media/$USER/root/mnt/DVD7
	fi
}

function mount_dvd8(){
	if  ! mount | grep -q "DVD8"  ; then
    	sudo mkdir -p /mnt/DVD8 && sudo mkdir -p /media/$USER/root/mnt/DVD8 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd8 /mnt/DVD8 && \
		sudo mount --bind /mnt/DVD8 /media/$USER/root/mnt/DVD8
	fi
}

function mount_dvd9(){
	if  ! mount | grep -q "DVD9"  ; then
    	sudo mkdir -p /mnt/DVD9 && sudo mkdir -p /media/$USER/root/mnt/DVD9 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd9 /mnt/DVD9 && \
		sudo mount --bind /mnt/DVD9 /media/$USER/root/mnt/DVD9
	fi
}

function mount_dvd10(){
	if  ! mount | grep -q "DVD10"  ; then
    	sudo mkdir -p /mnt/DVD10 && sudo mkdir -p /media/$USER/root/mnt/DVD10 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd10 /mnt/DVD10 && \
		sudo mount --bind /mnt/DVD10 /media/$USER/root/mnt/DVD10
	fi
}

function mount_dvd11(){
	if  ! mount | grep -q "DVD11"  ; then
    	sudo mkdir -p /mnt/DVD11 && sudo mkdir -p /media/$USER/root/mnt/DVD11 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd11 /mnt/DVD11 && \
		sudo mount --bind /mnt/DVD11 /media/$USER/root/mnt/DVD11
	fi
}

function mount_dvd12(){
	if  ! mount | grep -q "DVD12"  ; then
    	sudo mkdir -p /mnt/DVD12 && sudo mkdir -p /media/$USER/root/mnt/DVD12 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd12 /mnt/DVD12 && \
		sudo mount --bind /mnt/DVD12 /media/$USER/root/mnt/DVD12
	fi
}

function mount_dvd13(){
	if  ! mount | grep -q "DVD13"  ; then
    	sudo mkdir -p /mnt/DVD13 && sudo mkdir -p /media/$USER/root/mnt/DVD13 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd13 /mnt/DVD13 && \
		sudo mount --bind /mnt/DVD13 /media/$USER/root/mnt/DVD13
	fi
}

function mount_dvd14(){
	if  ! mount | grep -q "DVD14"  ; then
    	sudo mkdir -p /mnt/DVD14 && sudo mkdir -p /media/$USER/root/mnt/DVD14 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd14 /mnt/DVD14 && \
		sudo mount --bind /mnt/DVD14 /media/$USER/root/mnt/DVD14
	fi
}

function mount_dvd15(){
	if  ! mount | grep -q "DVD15"  ; then
    	sudo mkdir -p /mnt/DVD15 && sudo mkdir -p /media/$USER/root/mnt/DVD15 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd15 /mnt/DVD15 && \
		sudo mount --bind /mnt/DVD15 /media/$USER/root/mnt/DVD15
	fi
}

function mount_dvd16(){
	if  ! mount | grep -q "DVD16"  ; then
    	sudo mkdir -p /mnt/DVD16 && sudo mkdir -p /media/$USER/root/mnt/DVD16 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd16 /mnt/DVD16 && \
		sudo mount --bind /mnt/DVD16 /media/$USER/root/mnt/DVD16
	fi
}

function mount_dvd17(){
	if  ! mount | grep -q "DVD17"  ; then
    	sudo mkdir -p /mnt/DVD17 && sudo mkdir -p /media/$USER/root/mnt/DVD17 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd17 /mnt/DVD17 && \
		sudo mount --bind /mnt/DVD17 /media/$USER/root/mnt/DVD17
	fi
}

function mount_dvd18(){
	if  ! mount | grep -q "DVD18"  ; then
    	sudo mkdir -p /mnt/DVD18 && sudo mkdir -p /media/$USER/root/mnt/DVD18 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd18 /mnt/DVD18 && \
		sudo mount --bind /mnt/DVD18 /media/$USER/root/mnt/DVD18
	fi
}

function mount_dvd19(){
	if  ! mount | grep -q "DVD19"  ; then
    	sudo mkdir -p /mnt/DVD19 && sudo mkdir -p /media/$USER/root/mnt/DVD19 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd19 /mnt/DVD19 && \
		sudo mount --bind /mnt/DVD19 /media/$USER/root/mnt/DVD19
	fi
}

function mount_dvd20(){
	if  ! mount | grep -q "DVD20"  ; then
    	sudo mkdir -p /mnt/DVD20 && sudo mkdir -p /media/$USER/root/mnt/DVD20 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd20 /mnt/DVD20 && \
		sudo mount --bind /mnt/DVD20 /media/$USER/root/mnt/DVD20
	fi
}

function mount_dvd21(){
	if  ! mount | grep -q "DVD21"  ; then
    	sudo mkdir -p /mnt/DVD21 && sudo mkdir -p /media/$USER/root/mnt/DVD21 
		sudo mount -t iso9660 -o loop $_iso_home/$_dvd21 /mnt/DVD21 && \
		sudo mount --bind /mnt/DVD21 /media/$USER/root/mnt/DVD21
	fi
}

function unmount_dvd1(){
    #sudo umount $_iso_home/$_dvd1
    sudo umount /media/$USER/root/mnt/DVD1 && sudo umount /mnt/DVD1
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD1."    	
	else
    	echo "Done unmounting DVD1."    	
	fi
	if [ -d "/mnt/DVD1" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD1
       sudo rm -rf /mnt/DVD1
    fi
}

function unmount_dvd2(){
    sudo umount /media/$USER/root/mnt/DVD2 && sudo umount /mnt/DVD2
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD2."    	
	else
    	echo "Done unmounting DVD2."    	
	fi
	if [ -d "/mnt/DVD2" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD2
       sudo rm -rf /mnt/DVD2
    fi
}

function unmount_dvd3(){
    sudo umount /media/$USER/root/mnt/DVD3 && sudo umount /mnt/DVD3
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD3."
	else
    	echo "Done unmounting DVD3." 
	fi
	if [ -d "/mnt/DVD3" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD3
       sudo rm -rf /mnt/DVD3
    fi
}

function unmount_dvd4(){
    sudo umount /media/$USER/root/mnt/DVD4 && sudo umount /mnt/DVD4
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD4."
	else
    	echo "Done unmounting DVD4." 
	fi
	if [ -d "/mnt/DVD4" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD4
       sudo rm -rf /mnt/DVD4
    fi
}

function unmount_dvd5(){
    sudo umount /media/$USER/root/mnt/DVD5 && sudo umount /mnt/DVD5
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD5."
	else
    	echo "Done unmounting DVD5." 
	fi
	if [ -d "/mnt/DVD5" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD5
       sudo rm -rf /mnt/DVD5
    fi
}

function unmount_dvd6(){
    sudo umount /media/$USER/root/mnt/DVD6 && sudo umount /mnt/DVD6
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD6."
	else
    	echo "Done unmounting DVD6." 
	fi
	if [ -d "/mnt/DVD6" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD6
       sudo rm -rf /mnt/DVD6
    fi
}

function unmount_dvd7(){
    sudo umount /media/$USER/root/mnt/DVD7 && sudo umount /mnt/DVD7
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD7."
	else
    	echo "Done unmounting DVD7." 
	fi
	if [ -d "/mnt/DVD7" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD7
       sudo rm -rf /mnt/DVD7
    fi
}

function unmount_dvd8(){
    sudo umount /media/$USER/root/mnt/DVD8 && sudo umount /mnt/DVD8
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD8."
	else
    	echo "Done unmounting DVD8." 
	fi
	if [ -d "/mnt/DVD8" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD8
       sudo rm -rf /mnt/DVD8
    fi
}

function unmount_dvd9(){
    sudo umount /media/$USER/root/mnt/DVD9 && sudo umount /mnt/DVD9
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD9."
	else
    	echo "Done unmounting DVD9." 
	fi
	if [ -d "/mnt/DVD9" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD9
       sudo rm -rf /mnt/DVD9
    fi
}

function unmount_dvd10(){
    sudo umount /media/$USER/root/mnt/DVD10 && sudo umount /mnt/DVD10
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD10."
	else
    	echo "Done unmounting DVD10." 
	fi
	if [ -d "/mnt/DVD10" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD10
       sudo rm -rf /mnt/DVD10
    fi
}

function unmount_dvd11(){
    sudo umount /media/$USER/root/mnt/DVD11 && sudo umount /mnt/DVD11
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD11."
	else
    	echo "Done unmounting DVD11." 
	fi
	if [ -d "/mnt/DVD11" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD11
       sudo rm -rf /mnt/DVD11
    fi
}

function unmount_dvd12(){
    sudo umount /media/$USER/root/mnt/DVD12 && sudo umount /mnt/DVD12
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD12."
	else
    	echo "Done unmounting DVD12." 
	fi
	if [ -d "/mnt/DVD12" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD12
       sudo rm -rf /mnt/DVD12
    fi
}

function unmount_dvd13(){
    sudo umount /media/$USER/root/mnt/DVD13 && sudo umount /mnt/DVD13
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD13."
	else
    	echo "Done unmounting DVD13." 
	fi
	if [ -d "/mnt/DVD13" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD13
       sudo rm -rf /mnt/DVD13
    fi
}

function unmount_dvd14(){
    sudo umount /media/$USER/root/mnt/DVD14 && sudo umount /mnt/DVD14
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD14."
	else
    	echo "Done unmounting DVD14." 
	fi
	if [ -d "/mnt/DVD14" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD14
       sudo rm -rf /mnt/DVD14
    fi
}

function unmount_dvd15(){
    sudo umount /media/$USER/root/mnt/DVD15 && sudo umount /mnt/DVD15
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD15."
	else
    	echo "Done unmounting DVD15." 
	fi
	if [ -d "/mnt/DVD15" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD15
       sudo rm -rf /mnt/DVD15
    fi
}

function unmount_dvd16(){
    sudo umount /media/$USER/root/mnt/DVD16 && sudo umount /mnt/DVD16
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD16."
	else
    	echo "Done unmounting DVD16." 
	fi
	if [ -d "/mnt/DVD16" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD16
       sudo rm -rf /mnt/DVD16
    fi
}

function unmount_dvd17(){
    sudo umount /media/$USER/root/mnt/DVD17 && sudo umount /mnt/DVD17
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD17."
	else
    	echo "Done unmounting DVD17." 
	fi
	if [ -d "/mnt/DVD17" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD17
       sudo rm -rf /mnt/DVD17
    fi
}

function unmount_dvd18(){
    sudo umount /media/$USER/root/mnt/DVD18 && sudo umount /mnt/DVD18
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD18."
	else
    	echo "Done unmounting DVD18." 
	fi
	if [ -d "/mnt/DVD18" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD18
       sudo rm -rf /mnt/DVD18
    fi
}

function unmount_dvd19(){
    sudo umount /media/$USER/root/mnt/DVD19 && sudo umount /mnt/DVD19
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD19."
	else
    	echo "Done unmounting DVD19." 
	fi
	if [ -d "/mnt/DVD19" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD19
       sudo rm -rf /mnt/DVD19
    fi
}

function unmount_dvd20(){
    sudo umount /media/$USER/root/mnt/DVD20 && sudo umount /mnt/DVD20
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD20."
	else
    	echo "Done unmounting DVD20." 
	fi
	if [ -d "/mnt/DVD20" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD20
       sudo rm -rf /mnt/DVD20
    fi
}

function unmount_dvd21(){
    sudo umount /media/$USER/root/mnt/DVD21 && sudo umount /mnt/DVD21
    if [[ $? -ne 0 ]]; then
    	echo "Error unmounting DVD21."
	else
    	echo "Done unmounting DVD21." 
	fi
	if [ -d "/mnt/DVD21" ]; then
       sudo rm -rf /media/$USER/root/mnt/DVD21
       sudo rm -rf /mnt/DVD21
    fi
}

function set_base_os(){
    unpack_debian12 && \
	cmake --build build --target mounting_linux $_verbose && \
	cmake --build build --target chroot_debian $_verbose
}

function set_kernel(){
	if [ ! -d "/mnt/DVD1" ]; then
    	echo "Mount DVD1 before installing some packages."
    else
		cmake --build build --target set_kernel $_verbose
	fi
}

function set_uefi_boot(){
	cmake --build build --target set_uefi_boot $_verbose
}


function check_qemu(){
	echo -e "-- Checking QEMU Path ${QEMU_PATH}"
	which $QEMU_PATH > /dev/null 2>&1 || (echo 'QEMU not installed. Please install QEMU.' && exit 1)
}

# DESC: Usage of kzenlab setup
# ARGS: tags,version
# OUTS: None
# RETS: None
function script_usage() {
    cat << EOF
KZENLAB Virtual Machine Setup 
Version 0.1
DEBUG=[yes/no] [shell] setup.sh [options]

Usage:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
     -cl|--clean-cmake          Clean CMAKE
     -sc|--setup-cmake          Clean CMAKE
     -br|--build-raw        	Build RAW IMAGE
     -d9|--download-debian9     Download Debian 9   
     -ud9|--unpack-debian9      Unpack Debian 9   
     -db9|--build-debian9  		Build Debian 9

example:
> DEBUG=no bash setup.sh --setup-cmake
or
> DEBUG=yes bash setup.sh -sc

EOF
}

########################## SCRIPT ##########################

# DESC: Generic script initialisation
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: $orig_cwd: The current working directory when the script was run
#       $script_path: The full path to the script
#       $script_dir: The directory path of the script
#       $script_name: The file name of the script
#       $script_params: The original parameters provided to the script
#       $ta_none: The ANSI control code to reset all text attributes
# RETS: None
# NOTE: $script_path only contains the path that was used to call the script
#       and will not resolve any symlinks which may be present in the path.
#       You can use a tool like realpath to obtain the "true" path. The same
#       caveat applies to both the $script_dir and $script_name variables.
# shellcheck disable=SC2034
function script_init() {
    # Useful variables
    readonly orig_cwd="$PWD"
    readonly script_params="$*"
    readonly script_path="${BASH_SOURCE[0]}"
    script_dir="$(dirname "$script_path")"
    script_name="$(basename "$script_path")"
    readonly script_dir script_name

    # Important to always set as we use it in the exit handler
    # shellcheck disable=SC2155
    readonly ta_none="$(tput sgr0 2> /dev/null || true)"
}

# DESC: Handler for unexpected errors
# ARGS: $1 (optional): Exit code (defaults to 1)
# OUTS: None
# RETS: None
function script_trap_err() {
    local exit_code=1

    # Disable the error trap handler to prevent potential recursion
    trap - ERR

    # Consider any further errors non-fatal to ensure we run to completion
    set +o errexit
    set +o pipefail

    # Validate any provided exit code
    if [[ ${1-} =~ ^[0-9]+$ ]]; then
        exit_code="$1"
    fi

    # Output debug data if in Cron mode
    if [[ -n ${cron-} ]]; then
        # Restore original file output descriptors
        if [[ -n ${script_output-} ]]; then
            exec 1>&3 2>&4
        fi

        # Print basic debugging information
        printf '%b\n' "$ta_none"
        printf '***** Abnormal termination of script *****\n'
        printf 'Script Path:            %s\n' "$script_path"
        printf 'Script Parameters:      %s\n' "$script_params"
        printf 'Script Exit Code:       %s\n' "$exit_code"

        # Print the script log if we have it. It's possible we may not if we
        # failed before we even called cron_init(). This can happen if bad
        # parameters were passed to the script so we bailed out very early.
        if [[ -n ${script_output-} ]]; then
            # shellcheck disable=SC2312
            printf 'Script Output:\n\n%s' "$(cat "$script_output")"
        else
            printf 'Script Output:          None (failed before log init)\n'
        fi
    fi

    # Exit with failure status
    exit "$exit_code"
}

# DESC: Handler for exiting the script
# ARGS: None
# OUTS: None
# RETS: None
function script_trap_exit() {
    cd "$orig_cwd"

    # Remove Cron mode script log
    if [[ -n ${cron-} && -f ${script_output-} ]]; then
        rm "$script_output"
    fi

    # Remove script execution lock
    if [[ -d ${script_lock-} ]]; then
        rmdir "$script_lock"
    fi

    # Restore terminal colours
    printf '%b' "$ta_none"
}

# DESC: Exit script with the given message
# ARGS: $1 (required): Message to print on exit
#       $2 (optional): Exit code (defaults to 0)
# OUTS: None
# RETS: None
# NOTE: The convention used in this script for exit codes is:
#       0: Normal exit
#       1: Abnormal exit due to external error
#       2: Abnormal exit due to script error
function script_exit() {
    if [[ $# -eq 1 ]]; then
        printf '%s\n' "$1"
        exit 0
    fi

    if [[ ${2-} =~ ^[0-9]+$ ]]; then
        printf '%b\n' "$1"
        # If we've been provided a non-zero exit code run the error trap
        if [[ $2 -ne 0 ]]; then
            script_trap_err "$2"
        else
            exit 0
        fi
    fi

    script_exit 'Missing required argument to script_exit()!' 2
}


# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
# RETS: None
function parse_params() {
    local param
    local args=0
    if [[ $# -eq 0 ]]; then 
        script_usage
    fi
    while [[ $# -gt 0 ]]; do
        param="$1"
        if [ $# -eq 2 ]; then
            args="$2"
            shift 2
        else
            shift
        fi
        case $param in
            -h | --help)
                script_usage
                exit 0
                ;;
            -v | --verbose)
                verbose=true
                ;;
            -cl | --clean)
				clean_cmake
                ;;
            -sc | --setup)
				setup_cmake
                ;;
            -br | --build-raw)
				build_raw_disk
				;;
	   	    -d9|--download-debian9)
				download_debian9
				;;
	   	    -d12|--download-debian12)
				download_debian12
				;;
		    -ud9|--unpack-debian9)
				unpack_debian9
				;;
	        -db9|--build-debian9)
				build_debian9
				;;
			-ulx|--unmount-linux)
				unmount_linux
				;;
			-unl|--unloop)
				unloop
				;;
			-rem|--remounting)
				remounting
				;;
			--set-repo-active)
				set_repo_active
				;;
			--set-repo-deactive)
				set_repo_deactive
				;;
			--mount-dvd)
				mount_dvd
				;;
			--unmount-dvd)
				unmount_dvd
				;;
            --set-base-os)
				set_base_os
				;;
            --set-kernel)
				set_kernel
				;;
            --set-uefi-boot)
				set_uefi_boot
				;;
			--start-qemu-uefi)
				start_qemu_uefi
				;;
			--create-vboxvm)
				create_vboxvm
				;;
			--create-usb-vboxvm)
				create_usb_vboxvm
				;;
			--create-vmdk)
				create_vmdk
				;;
			--create-usb-vmdk)
				create_usb_vmdk $args
				;;
			--remove-vboxvm)
				remove_vboxvm
				;;
			--remove-usb-vboxvm)
				remove_usb_vboxvm
				;;
			--vbox-attach-dvd1)
				vbox_attach_dvd1
				;;
			--vbox-dettach-dvd1)
				vbox_dettach_dvd1
				;;
            --build-by-config)
				build_empty_disk
				;;
            --build-partition)
				build_partition
				;;
            --demolish-disk)
                if [[ $args -eq 0 ]]; then
                    demolish_disk
                else
                    demolish_empty_vbox_4gb $args
                fi
                ;;
            *)
                script_exit "Invalid parameter was provided: $param" 1
                ;;
        esac
    done
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
# RETS: None
function main() {
    trap script_trap_err ERR
    trap script_trap_exit EXIT
    import_env
    script_init "$@"
    parse_params "$@"
}

# Invoke main with args if not sourced
if ! (return 0 2> /dev/null); then
    main "$@"
fi