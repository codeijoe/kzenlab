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

set(PATH_ROOT "`cat ${LOG_ROOT}`" CACHE INTERNAL "ROOT mount path")

set(DEV_LOOPS "`cat ${LOG_LOOPS}`" CACHE INTERNAL "Loop Device")


set(LOG_LINUX_PROC "${CMAKE_BINARY_DIR}/log/linux-proc" CACHE INTERNAL "/proc mount path")
set(LOG_LINUX_SYS "${CMAKE_BINARY_DIR}/log/linux-sys" CACHE INTERNAL "/sys mount path")
set(LOG_LINUX_DEV "${CMAKE_BINARY_DIR}/log/linux-dev" CACHE INTERNAL "/dev mount path")
set(LOG_LINUX_PTS "${CMAKE_BINARY_DIR}/log/linux-pts" CACHE INTERNAL "/dev/pts mount path")

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
    COMMAND ${LOSETUP_PATH} --raw | grep ${VM_NAME}.raw | cut -f 1 -d " " | xargs -I {} ${UDISKCTL_PATH} unmount -b {}p1 

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
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    VERBATIM
)


######################################
# TARG: make_loops
# PROC: init/disk
# DESC: Make loop device manually. Mostly after reboot
######################################
add_custom_target(
    make_loops
    DEPENDS ${LOG_LOOPS}
    COMMENT "Make loops for ${VM_NAME}.raw..."
)

######################################
# TARG: make_loops_mounted
# PROC: init/disk
# DESC: Make loop device mounted manually. Mostly after reboot
######################################
add_custom_target(
    make_loops_mounted

    # Remounting Root Partition
    # note: mount path match with partition table  
    # TODO: Find better solution for removing explicit path

    COMMAND cat ${LOG_LOOPS} | xargs -I {} sh -c 'sudo mount -o remount,exec {}p3 `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`'

    # Remounting EFI Partition
    # note: mount path match with partition table  
    COMMAND cat ${LOG_LOOPS} | xargs -I {} sh -c 'sudo mount -o remount,exec {}p1 `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_EFI}`'

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

    #COMMAND cat ${LOG_LOOPS} | xargs -I {} sudo chmod 666 {}

    COMMENT "Create loop device for ${VM_NAME}.raw..."
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
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

    #COMMAND bash -c "sudo mkdir -p /media/$ENV{USER}/root && sudo mount ${DEV_LOOPS}p3 /media/$ENV{USER}/root"

    DEPENDS ${LOG_LOOPS}
	COMMENT "Mounting ROOT"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
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
    # EFI should place on /boot/efi
    COMMAND cat ${LOG_LOOPS} | xargs -I {} ${UDISKCTL_PATH} mount -b {}p1 --filesystem-type=auto | cut -f 4 -d " " > ${LOG_EFI}

    DEPENDS ${LOG_LOOPS}
    DEPENDS ${LOG_ROOT}
	COMMENT "Mounting EFI"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    VERBATIM
)

#=========================================
