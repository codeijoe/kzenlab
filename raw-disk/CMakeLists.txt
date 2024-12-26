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
project(raw-disk)


#### VARS
set(RAWDISK "${CMAKE_BINARY_DIR}/${VM_NAME}.raw" CACHE INTERNAL "RAW Disk File")
set(LOG_LOOPS "${CMAKE_BINARY_DIR}/log/loops" CACHE INTERNAL "Loop Device")
set(LOG_ROOT "${CMAKE_BINARY_DIR}/log/root" CACHE INTERNAL "ROOT mount path")
set(LOG_EFI "${CMAKE_BINARY_DIR}/log/efi" CACHE INTERNAL "EFI mount path")

set(CHROOT_DIR "${LOG_ROOT}" CACHE INTERNAL "CHROOT mount path")
set(DVD_MOUNT "${LOG_ROOT}" CACHE INTERNAL "DVD mount path")


##### BUILD RAW TARGET #####

######################################
# TARG: create_raw_disk
# PROC: init/disk
# DESC: Creating RAWDISK 
######################################
add_custom_target(
    create_raw_disk
    DEPENDS ${RAWDISK}
    COMMENT "Create RAW Disk 2GB with EFI, Swap and Root Partition"
)

######################################
# TARG: mounting_raw_disk
# PROC: init/disk
# DESC: Mounting RAWDISK to loop device
######################################
add_custom_target(
    mounting_raw_disk

    # Remounting Root Partition
    # note: mount path match with partition table  
    COMMAND cat ${LOG_LOOPS} | xargs -I {} sudo mount -o remount,exec {}p3 /media/$ENV{USER}/root

    DEPENDS ${LOG_EFI}
    DEPENDS ${LOG_ROOT}
    DEPENDS formating_raw_disk
    COMMENT "Mounting ROOT and EFI partition on RAW DISK..."
)

######################################
# TARG: unmounting_raw_disk
# PROC: init/disk
# DESC: Unmounting RAWDISK from loop device
######################################
add_custom_target(
    unmounting_raw_disk
    # EFI Partition
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${UDISKCTL_PATH} unmount -b {}p3 
    # ROOT Partition
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${UDISKCTL_PATH} unmount -b {}p3 
    COMMENT "Unmounting..."
)

######################################
# TARG: formating_raw_disk
# PROC: init/disk
# DESC: Formating RAWDISK after mounted
######################################
add_custom_target(
    formating_raw_disk
    ## Formating EFI
    COMMAND cat ${LOG_LOOPS} | xargs -I {} mkfs -t vfat -F 32 -n EFI {}p1 
    ## Formating SWAP
    COMMAND cat ${LOG_LOOPS} | xargs -I {} mkswap -L swap {}p3 
    ## Formating ROOT
    COMMAND cat ${LOG_LOOPS} | xargs -I {} mkfs -t ext4 -L root -E root_owner=1000:1000 {}p3 
    ## Display partitions
    COMMAND cat ${LOG_LOOPS} | xargs -I {} fdisk -l {}
    DEPENDS ${LOG_LOOPS}
    COMMENT "Formating RAW Disk..."
)

######################################
# TARG: unloop_raw_disk
# PROC: init/disk
# DESC: Removing RAWDISK from loop device
######################################
add_custom_target(
    unloop_raw_disk
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${LOSETUP_PATH} -d {}
    COMMENT "Unlooping..."
)

######################################
# TARG: download_debian9
# PROC: setup/base
# DESC: Download debian 9 stretch using debootstrap
######################################
add_custom_target(
    download_debian9
    # Debian 9 Stretch
    COMMAND sudo rm -rf /tmp/debian-9 && sudo debootstrap --arch amd64 --include=curl,git,zsh,gdisk stretch /tmp/debian-9 http://archive.debian.org/debian && sudo tar -czf ${CMAKE_BINARY_DIR}/debian-9.tar.gz -C /tmp debian-9
    COMMENT "Downloading DEBIAN 9 Stretch..."
)

######################################
# TARG: unpack_debian9
# PROC: setup/base
# DESC: Extract debian tar to ROOT partition
######################################
add_custom_target(
    unpack_debian9
    COMMAND cat ${LOG_ROOT} | xargs -I {} sudo tar --strip-components=1 -xzvf ${CMAKE_BINARY_DIR}/debian-9.tar.gz -C {} 
    COMMENT "${CMAKE_BINARY_DIR} >> Unpack DEBIAN 9 Stretch to raw disk..."
)

######################################
# TARG: chroot_debian9
# PROC: setup/base
# DESC: Debian `chroot`-ing test
######################################
add_custom_target(
    chroot_debian9
    COMMAND cat ${LOG_ROOT} | xargs -I {} sudo chroot {} cat /etc/os-release
    COMMENT "`chroot` to Debian 9 Stretch in raw disk..."
)

######################################
# TARG: make_loops
# PROC: setup/base
# DESC: Make loop device manually. Mostly after reboot
######################################
add_custom_target(
    make_loops
    DEPENDS ${LOG_LOOPS}
    COMMENT "Make loops for ${VM_NAME}.raw..."
)

######################################
# TARG: make_loops_mounted
# PROC: setup/base
# DESC: Make loop device mounted manually. Mostly after reboot
######################################
add_custom_target(
    make_loops_mounted

    # Remounting Root Partition
    # note: mount path match with partition table  
    # TODO: Find better solution for removing explicit path
    COMMAND cat ${LOG_LOOPS} | xargs -I {} sh -c 'sudo mount -o remount,exec {}p3 /media/$ENV{USER}/root'

    # Remounting EFI Partition
    # note: mount path match with partition table  
    COMMAND cat ${LOG_LOOPS} | xargs -I {} sh -c 'sudo mount -o remount,exec {}p1 /media/$ENV{USER}/EFI'

    DEPENDS ${LOG_ROOT}
    DEPENDS ${LOG_EFI}
    COMMENT "Make loops for ${VM_NAME}.raw..."
)

#======================================

############### COMMAND ###############

######################################
# COMD: RAWDISK
# PROC: init/disk
# DESC: Generate RAWDISK with partitions 
######################################
add_custom_command(
    OUTPUT ${RAWDISK}
    COMMAND ${FALLO_PATH} -l 2GiB ${RAWDISK}
    COMMAND ${PARTED_PATH} -s -a optimal ${RAWDISK} mklabel gpt mkpart primary fat32 1MiB 270MiB name 1 uefi mkpart primary linux-swap 270MiB 500MiB name 2 swap mkpart primary ext4 500MiB 2000MiB name 3 root set 1 esp on
    COMMENT "2 GB RAW disk created for ${VM_NAME} then create partition..."
    VERBATIM
)

######################################
# COMD: log/loops
# PROC: init/disk
# DESC: Create loop device from RAW IMAGE
######################################
add_custom_command(
    OUTPUT ${LOG_LOOPS}
    COMMAND ${UDISKCTL_PATH} loop-setup -f ${RAWDISK} | head -c -2 | cut -f 5 -d " " > ${LOG_LOOPS}
    COMMAND cat ${LOG_LOOPS} | xargs -I {} sudo chmod 666 {}
    COMMENT "Create loop device for ${VM_NAME}.raw..."
    VERBATIM
)

######################################
# COMD: log/root
# PROC: init/disk
# DESC: Mounting ROOT partition from loop device 
######################################
add_custom_command(
	OUTPUT ${LOG_ROOT}
    # ROOT Partition
	COMMAND cat ${LOG_LOOPS} | xargs -I {} ${UDISKCTL_PATH} mount --block-device {}p3 --filesystem-type=auto --no-user-interaction | cut -f 4 -d " " > ${LOG_ROOT}
    DEPENDS ${LOG_LOOPS}
	COMMENT "Mounting ROOT"
    VERBATIM
)

######################################
# COMD: log/efi
# PROC: init/disk
# DESC: Mounting EFI partition from loop device 
######################################
add_custom_command(
	OUTPUT ${LOG_EFI}
    # EFI Partition
    COMMAND cat ${LOG_LOOPS} | xargs -I {} ${UDISKCTL_PATH} mount -b {}p1 --filesystem-type=auto | cut -f 4 -d " " > ${LOG_EFI}
    DEPENDS ${LOG_LOOPS}
	COMMENT "Mounting EFI"
    VERBATIM
)


#=========================================
