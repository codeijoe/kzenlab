# CMakeLists.txt
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
cmake_minimum_required(VERSION 3.15)
project(BaseBuild)


######################################
## Shell Environment variables as CMake cache variables
######################################

#### TOOLS
set(VBOX_CMD "/usr/bin/VBoxManage" CACHE STRING "Path to VBoxManage executable")
set(VBOX_IMG_MOUNT "/usr/bin/vboximg-mount" CACHE STRING "Path to VBox Image Mount executable")
set(VBOX_IMG "/usr/bin/vbox-img" CACHE STRING "Path to VBox Image executable")
set(QEMU_PATH "/usr/bin/qemu-system-x86_64" CACHE STRING "Path to VBoxManage executable")
set(GDISK_PATH "/usr/sbin/gdisk" CACHE STRING "Path to GDISK executable")
set(FDISK_PATH "/usr/sbin/fdisk" CACHE STRING "Path to FDISK executable")
set(DEBOOT_PATH "/usr/sbin/debootstrap" CACHE STRING "Path to DEBOOTSTRAP executable")
set(FALLO_PATH "/usr/bin/fallocate" CACHE STRING "Path to Fallocate executable")
set(PARTED_PATH "/usr/sbin/parted" CACHE STRING "Path to Parted executable")
set(UDISKCTL_PATH "/usr/bin/udisksctl" CACHE STRING "Path to UDISKCTL executable")
set(MKFS_PATH "/usr/sbin/mkfs" CACHE STRING "Path to MKFS executable")
set(MKSWAP_PATH "/usr/sbin/mkswap" CACHE STRING "Path to MKSWAP executable")
set(LOSETUP_PATH "/usr/sbin/losetup" CACHE STRING "Path to Losetup executable")


#### VM
set(VM_HYPER_TYPE "VBOX" CACHE STRING "VM Hypervisor type")
set(VM_NAME "KZENLAB" CACHE STRING "VM Name")
set(VM_DOMAIN "codeijoe.org" CACHE STRING "VM Domain")
set(VM_HOSTNAME "kzenlab" CACHE STRING "VM Hostname")
set(VM_DISK_SIZE "0" CACHE STRING "VM Disk size")

#### ISO
set(ISO_HOME "/home/ijoe/ISO/LINUX/DEBIAN" CACHE STRING "ISO DEBIAN Directory")
set(ISO_DEBIAN127_DVD "debian-12.7.0-amd64-DVD-1.iso" CACHE STRING "Debian ISO File")
set(ISO_DEBIAN128_CD "debian-12.8.0-amd64-netinst.iso" CACHE STRING "Debian Netinstall CD ISO File")
set(ISO_DEBIAN128_DVD_1 "debian-12.8.0-amd64-DVD-1.iso" CACHE STRING "Debian Netinstall CD ISO File")
set(ISO_DEBIAN128_LIVE_XFCE "debian-live-12.8.0-amd64-xfce.iso" CACHE STRING "Debian Netinstall CD ISO File")

#### QEMU
set(QEMU_HOME "/home/ijoe/QEMU_VM" CACHE STRING "QEMU VM Home Directory")
set(QEMU_VM_HOME "${QEMU_VM}/VM" CACHE STRING "QEMU VM Home Directory")

#### QEMU DISK
set(QEMU_DISK_HOME "${QEMU_HOME}/DISK" CACHE STRING "QEMU VM Home Directory")

#### VBOX
set(VBOX_HOME "/media/89fbfc92-6afb-4c5a-a889-199bc5f66e21/ijoe/VBOX_VM" CACHE STRING "VBOX Home Directory")
set(VBOX_VM_HOME "/media/89fbfc92-6afb-4c5a-a889-199bc5f66e21/ijoe/VBOX_VM/VM" CACHE STRING "VBOX VM Home Directory")

#### VBOX DISK
set(VBOX_DISK_HOME "${VBOX_HOME}/DISK" CACHE STRING "VM Disk Home Directory")
set(VM_RAWDISK_4GB "${VBOX_HOME}/flat4GB.vmdk" CACHE STRING "Raw Disk 4GB")
set(VM_RAWDISK_8GB "${VBOX_HOME}/flat8GB.vmdk" CACHE STRING "Raw Disk 8GB")
set(VM_RAWDISK_16GB "${VBOX_HOME}/flat16GB.vmdk" CACHE STRING "Raw Disk 16GB")
set(VM_RAWDISK_32GB "${VBOX_HOME}/flat32GB.vmdk" CACHE STRING "Raw Disk 32GB")
set(VM_RAWDISK_64GB "${VBOX_HOME}/flat64GB.vmdk" CACHE STRING "Raw Disk 64GB")
set(VBOX_DISK_4GB "${VM_NAME}.vdi" CACHE STRING "4GB Disk")
set(VBOX_DISK_8GB "${VM_NAME}--8GB.vdi" CACHE STRING "8GB Disk")
set(VBOX_DISK_16GB "${VM_NAME}--16GB.vdi" CACHE STRING "16GB Disk")
set(VBOX_DISK_32GB "${VM_NAME}--32GB.vdi" CACHE STRING "32GB Disk")
set(VBOX_DISK_64GB "${VM_NAME}--64GB.vdi" CACHE STRING "64GB Disk")


#### DEBIAN
set(EFI_PART "default" CACHE STRING "EFI Partition")
set(ROOT_PART "default" CACHE STRING "EFI Partition")


######################################
# TGET: print_vm_env
# PROC: init/env
# DESC: Print Virtual Machine Environment to screen
######################################
add_custom_target(
    print_vm_env
    COMMAND ${CMAKE_COMMAND} -E echo "VM_HYPER_TYPE: ${VM_HYPER_TYPE}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_CMD: ${VBOX_CMD}"
    COMMAND ${CMAKE_COMMAND} -E echo "QEMU_PATH: ${QEMU_PATH}"

    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_HOME: ${VBOX_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_VM_HOME: ${VBOX_VM_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_NAME: ${VM_NAME}"
    COMMAND ${CMAKE_COMMAND} -E echo "ISO_HOME: ${ISO_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "ISO_DEBIAN128_CD: ${ISO_DEBIAN128_CD}"
    COMMAND ${CMAKE_COMMAND} -E echo "ISO_DEBIAN128_DVD: ${ISO_DEBIAN128_DVD}"    
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_HOME: ${VBOX_DISK_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_4GB: ${VM_RAWDISK_4GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_8GB: ${VM_RAWDISK_8GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB: ${VM_RAWDISK_16GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_32GB: ${VM_RAWDISK_32GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_64GB: ${VM_RAWDISK_64GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_4GB: ${VBOX_DISK_4GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_8GB: ${VBOX_DISK_8GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_16GB: ${VBOX_DISK_16GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_32GB: ${VBOX_DISK_32GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_64GB: ${VBOX_DISK_64GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_HOSTNAME: ${VM_HOSTNAME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DOMAIN: ${VM_DOMAIN}"
    COMMENT "Printing VM environment variables"
)

######################################
# TGET: write_vm_env
# PROC: init/env
# DESC: Print Virtual Machine Environment to vm_env.sh
######################################
add_custom_target(
    write_vm_env
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_HOME=${VBOX_HOME}" > vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_HYPER_TYPE=${VM_HYPER_TYPE}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_VM_HOME=${VBOX_VM_HOME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_CMD=${VBOX_CMD}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "QEMU_PATH=${QEMU_PATH}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_NAME=${VM_NAME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "ISO_HOME=${ISO_HOME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "ISO_DEBIAN128_CD=${ISO_DEBIAN128_CD}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "ISO_DEBIAN128_DVD=${ISO_DEBIAN128_DVD}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_HOME=${VBOX_DISK_HOME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_4GB=${VM_RAWDISK_4GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_8GB=${VM_RAWDISK_8GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB=${VM_RAWDISK_16GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB=${VM_RAWDISK_32GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB=${VM_RAWDISK_64GB}" >> vm_env.sh

    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_4GB=${VBOX_DISK_4GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_8GB=${VBOX_DISK_8GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_16GB=${VBOX_DISK_16GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_32GB=${VBOX_DISK_32GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_64GB=${VBOX_DISK_64GB}" >> vm_env.sh

    COMMAND ${CMAKE_COMMAND} -E echo "VM_HOSTNAME=${VM_HOSTNAME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DOMAIN=${VM_DOMAIN}" >> vm_env.sh
    #COMMAND ${CMAKE_COMMAND} -E env bash -c "build/vm_env.sh 2>&1" || (echo 'Fail to export ENV.' && exit 1)
    #COMMAND ${CMAKE_COMMAND} -E env -- bash -c "source vm_env.sh"
    COMMENT "Writing VM environment variables to vm_env.sh"
)

######################################
## CHECK REQUIRMENT TOOLS
######################################




add_custom_target(
    check_tools
    DEPENDS check_or_create_directory
    DEPENDS log/vbox
    DEPENDS log/qemu
    DEPENDS log/udisksctl
    DEPENDS log/losetup
    DEPENDS log/gdisk
    DEPENDS log/fdisk
    DEPENDS log/mkswap
    DEPENDS log/mkfs
    DEPENDS log/falloc
    DEPENDS log/deboot
    COMMENT "Checking tools installation"
    VERBATIM
)

add_custom_target(
    check_or_create_directory
    COMMAND ${CMAKE_COMMAND} -E echo "Checking if directory ${VBOX_HOME} exists..."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${VBOX_HOME}
    COMMAND ${CMAKE_COMMAND} -E echo "Directory ${VBOX_HOME} is ready."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${VBOX_VM_HOME}
    COMMAND ${CMAKE_COMMAND} -E echo "Directory ${VBOX_VM_HOME} is ready."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${QEMU_HOME}
    COMMAND ${CMAKE_COMMAND} -E echo "Directory ${QEMU_HOME} is ready."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${ISO_HOME}
    COMMAND ${CMAKE_COMMAND} -E echo "Directory ${ISO_HOME} is ready."
    COMMAND ${CMAKE_COMMAND} -E make_directory log
    COMMENT "Checking and creating directory"
)

add_custom_target(
	clean_cmake
    COMMAND ${CMAKE_COMMAND} -E rm -rf ${CMAKE_BINARY_DIR}/*   
    DEPENDS unloop_raw_disk
    DEPENDS unmounting_raw_disk
    COMMENT "Cleaning the build directory and unmount and unloop device... ${CMAKE_BINARY_DIR}"
)

add_custom_target(
    setup_env
    #if ( ${VM_HYPER_TYPE} STREQUAL "VBOX" )
    #message(STATUS "YAELAAAH...")
    DEPENDS write_vm_env print_vm_env check_or_create_directory 
    COMMENT "Checking and setting..."
)

#=========================================

##### BUILD RAW TARGET #####

add_custom_target(
    create_raw_disk
    DEPENDS ${VM_NAME}.raw
    COMMENT "Create RAW Disk 2GB with EFI, Swap and Root Partition"
)

add_custom_target(
    formating_raw_disk
    ## Formating EFI
    COMMAND cat log/loops | xargs -I {} mkfs -t vfat -F 32 -n EFI {}p1 
    ## Formating SWAP
    COMMAND cat log/loops | xargs -I {} mkswap -L swap {}p3 
    ## Formating ROOT
    COMMAND cat log/loops | xargs -I {} mkfs -t ext4 -L root -E root_owner=1000:1000 {}p3 
    #COMMAND cat log/loops | xargs -I {} echo {}
    COMMAND cat log/loops | xargs -I {} fdisk -l {}
    DEPENDS log/loops
    COMMENT "Formating RAW Disk..."
)

add_custom_target(
    mounting_raw_disk
    # EFI Partition
    #COMMAND cat log/loops | xargs -I {} ${UDISKCTL_PATH} mount -b {}p1 --filesystem-type=auto --options="rw" | cut -f 4 -d " " > log/efi
    # Root Partition
    COMMAND cat log/loops | xargs -I {} ${UDISKCTL_PATH} mount -b {}p3 --filesystem-type=auto | cut -f 4 -d " " > log/root && cat log/loops | xargs -I {} sudo mount -o remount,exec {}p3 /media/ijoe/root
    #COMMAND cat log/loops | xargs -I {} sudo mount -o exec,dev {}p3 /media/ijoe/root
    DEPENDS formating_raw_disk
    COMMENT "Mounting..."
)

add_custom_target(
    unmounting_raw_disk
    # EFI Partition
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${UDISKCTL_PATH} unmount -b {}p3 
    # ROOT Partition
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${UDISKCTL_PATH} unmount -b {}p3 
    COMMENT "Unmounting..."
)

add_custom_target(
    install_debian_base
    COMMAND cat log/root | xargs -I {} sudo debootstrap --arch amd64 bookworm {} http://ftp.uk.debian.org/debian
    COMMENT "Installing Debian Bookworm with salt-minion base to root partition..."
)

add_custom_target(
    unloop_raw_disk
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${LOSETUP_PATH} -d {}
    COMMENT "Unlooping..."
)

add_custom_target(
    delete_raw_disk
    COMMAND ${CMAKE_COMMAND} -E rm -rf ${VM_NAME}.raw
    COMMENT "Removing RAW Image..."
)


add_custom_target(
    download_stretch
    COMMAND sudo debootstrap --arch amd64 --include=curl,git,zsh,gdisk stretch /tmp/debian-9 http://archive.debian.org/debian && sudo tar -czf debian-9.tar.gz -C /tmp debian-9
    COMMENT "Downloading DEBIAN 9 Stretch..."
)

#=========================================



########## COMMAND ############

########## RAW BUILD ##########
add_custom_command(
    OUTPUT ${VM_NAME}.raw
    COMMAND ${FALLO_PATH} -l 2GiB ${VM_NAME}.raw 
    COMMAND ${PARTED_PATH} -s -a optimal ${VM_NAME}.raw mklabel gpt mkpart primary fat32 1MiB 270MiB name 1 uefi mkpart primary linux-swap 270MiB 500MiB name 2 swap mkpart primary ext4 500MiB 2000MiB name 3 root set 1 esp on
    COMMENT "${VM_NAME} Create 2 GB RAW disk then create partition..."
    VERBATIM
)

######################################
# COMD: log/loops
# PROC: init/disk
# DESC: Checking `debootstrap` availability
######################################
add_custom_command(
    OUTPUT log/loops
    COMMAND ${UDISKCTL_PATH} loop-setup -f ${VM_NAME}.raw | head -c -2 | cut -f 5 -d " " > log/loops
    COMMENT "Create loop device for ${VM_NAME}.raw..."
    VERBATIM
)

######################################
# COMD: log/deboot
# PROC: init/check
# DESC: Checking `debootstrap` availability
######################################
add_custom_command(
    OUTPUT log/deboot
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${DEBOOT_PATH} > log/deboot 2>&1 || (echo '`debootstrap` not installed. Please install `debootstrap`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`debootstrap` found at ${DEBOOT_PATH}."
    COMMENT "Checking `debootstap` installation..."
    VERBATIM
)

######################################
# COMD: log/falloc
# PROC: init/check
# DESC: Checking `fallocate` availability
######################################
add_custom_command(
    OUTPUT log/falloc
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${FALLO_PATH} > log/falloc 2>&1 || (echo '`fallocate` not installed. Please install `fallocate`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`fallocate` found at ${FALLO_PATH}."
    COMMENT "Checking `fallocate` installation..."
    VERBATIM
)

######################################
# COMD: log/losetup
# PROC: init/check
# DESC: Checking `losetup` availability
######################################
add_custom_command(
    OUTPUT log/losetup
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${LOSETUP_PATH} > log/losetup 2>&1 || (echo '`losetup` not installed. Please install `losetup`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`losetup` found at ${LOSETUP_PATH}."
    COMMENT "Checking `losetup` installation..."
    VERBATIM
)

######################################
# COMD: log/mkswap
# PROC: init/check
# DESC: Checking `mkswap` availability
######################################
add_custom_command(
    OUTPUT log/mkswap
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${MKSWAP_PATH} > log/mkswap 2>&1 || (echo '`mkswap` not installed. Please install `mkswap`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`mkswap` found at ${MKSWAP_PATH}."
    COMMENT "Checking `mkswap` installation..."
    VERBATIM
)

######################################
# COMD: log/mkfs
# PROC: init/check
# DESC: Checking `mkfs` availability
######################################
add_custom_command(
    OUTPUT log/mkfs
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${MKFS_PATH} > log/mkfs 2>&1 || (echo '`mkfs` not installed. Please install `mkfs`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`mkfs` found at ${MKFS_PATH}."
    COMMENT "Checking `mkfs` installation"
    VERBATIM
)

######################################
# COMD: log/fdisk
# PROC: init/check
# DESC: Checking `fdisk` availability
######################################
add_custom_command(
    OUTPUT log/fdisk
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${FDISK_PATH} > log/fdisk 2>&1 || (echo '`fdisk` not installed. Please install `fdisk`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`fdisk` found at ${FDISK_PATH}."
    COMMENT "Checking `fdisk` installation"
    VERBATIM
)

######################################
# COMD: log/gdisk
# PROC: init/check
# DESC: Checking `gdisk` availability
######################################
add_custom_command(
OUTPUT log/gdisk
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${GDISK_PATH} > log/gdisk 2>&1 || (echo '`gdisk` not installed. Please install `gdisk`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`gdisk` found at ${GDISK_PATH}."
    COMMENT "Checking `gdisk` installation"
    VERBATIM
)

######################################
# COMD: log/udisksctl
# PROC: init/check
# DESC: Checking `udisksctl` availability
######################################
add_custom_command(
    OUTPUT log/udisksctl
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${UDISKCTL_PATH} > log/udiskctl 2>&1 || (echo '`udiskctl` not installed. Please install `udiskctl`.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "`udiskctl` found at ${UDISKCTL_PATH}."
    COMMENT "Checking `udiskctl` installation"
    VERBATIM
)

######################################
# COMD: log/vbox
# PROC: init/check
# DESC: Checking Virtual Box availability
######################################
add_custom_command(
    OUTPUT log/vbox
    COMMAND ${CMAKE_COMMAND} -E env sh -c "which ${VBOX_CMD} > log/vbox 2>&1 || (echo 'VBOX not installed. Please install VirtualBox.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX found at ${VBOX_CMD}."
    COMMENT "Checking VBOX installation"
    VERBATIM
)

######################################
# COMD: log/qemu
# PROC: init/check
# DESC: Checking Qemu availability
######################################
add_custom_command(
    OUTPUT log/qemu
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${QEMU_PATH} > log/qemu 2>&1 || (echo 'QEMU not installed. Please install QEMU.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "QEMU found at ${QEMU_PATH}."
    COMMENT "Checking QEMU installation"
    VERBATIM
)

########## VBOX TARGET ##########

add_custom_target(
    build_empty_vbox_4gb
    COMMAND ${VBOX_CMD} storageattach ${VM_NAME} --storagectl "SATA01" --port 1 --device 0 --type hdd --medium ${VBOX_DISK_HOME}/${VM_NAME}.vdi
    DEPENDS ${VBOX_VM_HOME}/${VM_NAME}/${VM_NAME}.vbox
    DEPENDS ${VBOX_DISK_HOME}/${VM_NAME}.vdi
    DEPENDS setup_env
    COMMENT "Building empty VBOX 4GB Virtual Machine"
)

add_custom_target(
    demolish_empty_vbox_4gb
    COMMAND ${VBOX_CMD} unregistervm ${VM_NAME} --delete-all   
    COMMENT "Demolish empty VBOX 4GB Virtual Machine"
)

#
add_custom_target(
    vbox_showvminfo
    IF( EXISTS ${VBOX_HOME}/${VM_NAME}/${VM_NAME}.vbox )
         COMMAND ${VBOX_CMD} showvminfo ${VM_NAME}
    ENDIF()
    COMMENT "Show information of VBOX 4GB Virtual Machine"
)

#### Remove Virtual Machine
add_custom_target(
    remove_vbox_vm
    COMMENT "WARNING!!! Do It Manually"
)

########## VBOX COMMAND ##########

#### Create empty 4GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VM_NAME}.vdi
    COMMAND ${VBOX_CMD} createmedium disk --filename ${VBOX_DISK_HOME}/${VM_NAME} --format=VDI --variant Standard --size=3500
    COMMENT "Create 4GB VDI..."
    VERBATIM
)

#### Create empty 8GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VBOX_DISK_8GB}
    COMMAND ${VBOX_CMD} createmedium disk --filename ${VBOX_DISK_HOME}/${VBOX_DISK_8GB} --format=VDI --variant Standard --size=7500
    COMMENT "Create 8GB VDI..."
    VERBATIM
)

#### Create empty 16GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VBOX_DISK_16GB}
    COMMAND ${VBOX_CMD} createmedium disk --filename ${VBOX_DISK_HOME}/${VBOX_DISK_16GB} --format=VDI --variant Standard --size=15500
    COMMENT "Create 16GB VDI..."
)

#### Create empty 32GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VBOX_DISK_32GB}
    COMMAND ${VBOX_CMD} createmedium disk --filename ${VBOX_DISK_HOME}/${VBOX_DISK_32GB} --format=VDI --variant Standard --size=31500
    COMMENT "Create 32GB VDI..."
)

#### Create empty 64GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VBOX_DISK_64GB}
    COMMAND ${VBOX_CMD} createmedium disk --filename ${VBOX_DISK_HOME}/${VBOX_DISK_64GB} --format=VDI --variant Standard --size=63500
    COMMENT "Create 64GB VDI..."
)

#### Create VBOX Virtual Machine
add_custom_command(
    OUTPUT ${VBOX_VM_HOME}/${VM_NAME}/${VM_NAME}.vbox
    COMMAND ${VBOX_CMD} createvm --basefolder=${VBOX_VM_HOME} --name ${VM_NAME} --register 
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --description "Klaudizen Lab ${VM_NAME}"
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --memory=2048 --vram=128 --acpi=on --ioapic=on --cpus=3 --pae=on --long-mode=on
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --hwvirtex=on --paravirt-provider=kvm --nested-paging=on --nested-hw-virt=on
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --chipset=piix3
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --graphicscontroller vmsvga
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --tpm-type 2.0 
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --firmware efi64 
    COMMAND ${VBOX_CMD} modifynvram ${VM_NAME} inituefivarstore
    COMMAND ${VBOX_CMD} modifynvram ${VM_NAME} enrollmssignatures
    COMMAND ${VBOX_CMD} modifynvram ${VM_NAME} enrollorclpk

    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --mouse=ps2 --keyboard=ps2  
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --uart1 0x3f8 4 --uart-type1=16550A --uart-mode1 server /tmp/vbox 
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --nic1=nat --nic-type1=Am79C973 --cable-connected1=on 
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --nat-pf1 "SSH,tcp,,2200,,22" 
    COMMAND ${VBOX_CMD} modifyvm ${VM_NAME} --nat-pf1 "VNC,tcp,,15900,,5900" 

    COMMAND ${VBOX_CMD} storagectl ${VM_NAME} --name "SATA01" --add sata --controller IntelAHCI
    COMMAND ${VBOX_CMD} storageattach ${VM_NAME} --storagectl "SATA01" --port 0 --device 0 --type dvddrive --medium ${ISO_HOME}/${ISO_DEBIAN128_CD}
    COMMENT "Create VBOX VM ${VM_NAME}"
)

#### Control VBOX Virtual Machine

##### Partition Setup #####
add_custom_command(
    OUTPUT ${VBOX_VM_HOME}/${VM_NAME}/partsetup
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_LIST_DIR}/mnt
    COMMAND ${VBOX_IMG} info --filename ${VBOX_DISK_HOME}/${VM_NAME}.vdi 
    COMMAND ${VBOX_IMG_MOUNT} --image ${VBOX_DISK_HOME}/${VM_NAME}.vdi ${CMAKE_CURRENT_LIST_DIR}/mnt 
    COMMENT "Information of ${VM_NAME}'s VDI..."
)
