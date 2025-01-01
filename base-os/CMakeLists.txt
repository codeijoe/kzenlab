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
project(base-os)

set(EFI_DIR "`cat ${LOG_EFI}`" CACHE INTERNAL "CHROOT mount path")
set(CHROOT_DIR "`cat ${LOG_ROOT}`" CACHE INTERNAL "CHROOT mount path")
set(CHROOT_CMD "sudo chroot" CACHE INTERNAL "CHROOT Command")
set(DVD1 "/mnt/DVD1" CACHE INTERNAL "DVD mount path")

set(SET_APT "${CMAKE_BINARY_DIR}/log/set-apt" CACHE INTERNAL "APT Source")
set(SET_KERNEL "${CMAKE_BINARY_DIR}/log/set-kernel" CACHE INTERNAL "Setting Kernel")
set(SET_GRUB "${CMAKE_BINARY_DIR}/log/set-grub" CACHE INTERNAL "Setting GRUB")
set(SET_EFI_MOUNT "${CMAKE_BINARY_DIR}/log/set-efi-mount" CACHE INTERNAL "Setting GRUB")

##### BUILD RAW TARGET #####

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
# TARG: download_debian12
# PROC: setup/base
# DESC: Download debian 12 bookworm using debootstrap
######################################
add_custom_target(
    download_debian12
    # Debian 12 Bookworm
    COMMAND sudo rm -rf /tmp/debian-12 && sudo debootstrap --arch amd64 --include=curl,git,zsh,gdisk bookworm /tmp/debian-12 http://deb.debian.org/debian && sudo tar -czf ${CMAKE_BINARY_DIR}/debian-12.tar.gz -C /tmp debian-12
    COMMENT "Downloading DEBIAN 12 Bookworm..."
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
# TARG: unpack_debian12
# PROC: setup/base
# DESC: Extract debian tar to ROOT partition
######################################
add_custom_target(
    unpack_debian12
    COMMAND cat ${LOG_ROOT} | xargs -I {} sudo tar --strip-components=1 -xzvf ${CMAKE_BINARY_DIR}/debian-12.tar.gz -C {} 
    COMMENT "${CMAKE_BINARY_DIR} >> Unpack DEBIAN 12 Bookworm to raw disk..."
)

######################################
# TARG: chroot_debian
# PROC: setup/base
# DESC: Debian `chroot`-ing test
######################################
add_custom_target(
    chroot_debian
    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} cat /etc/os-release"
    COMMENT "`chroot` to Debian Base..."
    VERBATIM
)

######################################
# TARG: set_uefi_boot
# PROC: setup/base
# DESC: Create UEFI Secure Boot
######################################
add_custom_target(
    set_uefi_boot

    ### CAUTION INSTALL GRUB INSIDE CHROOT STRONG RECOMENDED
    ## 1 install grub 
    ## 2 set
    ## 3 test using QEMU

	#COMMAND bash -c "echo $ENV{VM_HOSTNAME}"

	#COMMAND bash -c "sudo grub-install --target=x86_64-efi `grep -oP '\/[A-Za-z0-9]+' ${LOG_LOOPS}` --bootloader-id=GRUB --modules=tpm --efi-directory=`grep -oP '\/[A-Za-z0-9]+' ${LOG_EFI}` --boot-directory=`grep -oP '\/[A-Za-z0-9]+' ${LOG_EFI}`/EFI/BOOT --uefi-secure-boot --removable"
	
	#COMMAND sudo grub-install --verbose --target=x86_64-efi ${DEV_LOOPS} --bootloader-id=GRUB --modules=tpm --efi-directory=${PART_EFI} --boot-directory=${PART_EFI}/BOOT --uefi-secure-boot --removable 

	#grub-install --target=x86_64-efi /dev/sda --bootloader-id=GRUB --modules="tpm" --efi-directory=/mnt/efi --boot-directory=/boot --uefi-secure-boot --removable

	#COMMAND sudo grub-install --verbose --target=x86_64-efi --efi-directory=`grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_EFI}` --bootloader-id=GRUB --recheck

	#COMMAND sudo grub-mkconfig -o `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/boot/grub/grub.cfg

	#COMMAND grub-install --target=x86_64-efi --efi-directory=${} --boot-directory=/mnt/efi/boot --removable ${LOG_LOOPS}

    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} bash -c '. /root/base-os.sh; set_uefi'"

    DEPENDS ${SET_EFI_MOUNT}
    DEPENDS ${SET_GRUB}
    DEPENDS ${LOG_LOOPS} 
    COMMENT "Create UEFI Secure Boot..."
    VERBATIM
)

add_custom_command(
	OUTPUT ${SET_EFI_MOUNT}

	COMMAND bash -c "echo ${DEV_LOOPS}p1 && echo ${PATH_ROOT}/boot/efi"

	# Mounting EFI
    #COMMAND bash -c "sudo mount ${DEV_LOOPS}p1 ${PATH_ROOT}/boot/efi &> ${SET_EFI_MOUNT}"

	COMMENT "Mouting EFI for UEFI Grub "
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
 	VERBATIM
)
add_custom_command(
	OUTPUT ${SET_GRUB}

    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} bash -c '. /root/base-os.sh; set_grub'" &> ${SET_GRUB}

    #COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} apt install -yq grub-efi-amd64-signed " &> ${SET_GRUB} 

	DEPENDS ${SET_APT}
    DEPENDS ${LOG_ROOT}
	COMMENT "Installing Grub "
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
 	VERBATIM
)

add_custom_target(
    set_kernel
    DEPENDS KERNEL_SETUP
    DEPENDS ${SET_APT}
    COMMENT "Setting kernel to debian base"
    VERBATIM
)

add_custom_target(
    mounting_linux
    DEPENDS ${LOG_LINUX_DEV}
    DEPENDS ${LOG_LINUX_SYS}
    DEPENDS ${LOG_LINUX_PROC}

    COMMENT "Mounting linux system partition..."
)


add_custom_target(
    unmounting_linux
    DEPENDS unmount_proc
    DEPENDS unmount_sys
    DEPENDS unmount_dev

    COMMENT "Unmounting linux system partition..."
)

add_custom_target(
    unmount_proc
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/proc && rm ${LOG_LINUX_PROC}" 

    DEPENDS unmount_proc_tail
    COMMENT "Un Mounting `/proc`"
    VERBATIM
)

add_custom_target(
    unmount_sys
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/sys && rm ${LOG_LINUX_SYS}" 

    DEPENDS unmount_sys_tail
    COMMENT "Un Mounting `/sys`"
    VERBATIM
)

add_custom_target(
    unmount_dev
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/dev && rm ${LOG_LINUX_DEV}" 

    DEPENDS unmount_dev_tail
    COMMENT "Un Mounting `/dev`"
    VERBATIM
)

#======================================

############### COMMAND ###############

add_custom_command(
	OUTPUT KERNEL_SETUP

    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} bash -c '. /root/base-os.sh; set_kernel'"

    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} bash -c '. /root/base-os.sh; set_locale'"

	DEPENDS ${SET_APT}
    DEPENDS ${LOG_ROOT}

	COMMENT "Installing Kernel "
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
 	VERBATIM
)

add_custom_command(
	OUTPUT ${SET_APT}

    COMMAND bash -c "sudo cp -f ${CMAKE_SOURCE_DIR}/base-os/sources.list ${CHROOT_DIR}/etc/apt/sources.list &> ${SET_APT}"

    COMMAND bash -c "sudo cp -f ${CMAKE_SOURCE_DIR}/base-os/DVD1.list ${CHROOT_DIR}/etc/apt/sources.list.d/ &> ${SET_APT}"

    COMMAND bash -c "sudo cp -f ${CMAKE_SOURCE_DIR}/base-os/debootstrap.list ${CHROOT_DIR}/etc/apt/sources.list.d/ &> ${SET_APT}"


    COMMAND bash -c "sudo cp -f ${CMAKE_SOURCE_DIR}/base-os/base-os.sh ${CHROOT_DIR}/root && sudo chmod +x ${CHROOT_DIR}/root/base-os.sh" &> ${SET_APT}

    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} apt update"

    DEPENDS ${LOG_ROOT}
	COMMENT "Setting APT and Locale..."
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
 	VERBATIM
)


######################################
# COMD: log/linux-dev
# PROC: setup/base
# DESC: Mounting Linux `dev` directory from loop device 
######################################
add_custom_command(
    OUTPUT ${LOG_LINUX_DEV}
    COMMAND bash -c  "sudo mount --make-rslave --rbind /dev `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/dev 2> ${LOG_LINUX_DEV}"

    DEPENDS ${LOG_ROOT}
    COMMENT "Mounting `/dev`"  
    VERBATIM
)

add_custom_command(
    OUTPUT ${LOG_LINUX_SYS}
    COMMAND bash -c  "sudo mount --make-rslave --rbind /dev `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/sys &> ${LOG_LINUX_SYS}"

    DEPENDS ${LOG_ROOT}
    COMMENT "Mounting `/sys`"
    VERBATIM
)


add_custom_command(
    OUTPUT ${LOG_LINUX_PROC}

    COMMAND bash -c  "sudo mount --make-rslave --rbind /dev ${PATH_ROOT}/proc &> ${LOG_LINUX_PROC}"

    DEPENDS ${LOG_ROOT}
    COMMENT "Mounting `/proc`"
    VERBATIM
)   


add_custom_command(
    OUTPUT unmount_proc_tail

    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/proc/hugepages" 
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/proc/mqueue"     
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/proc/shm" 
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/proc/pts" 

    COMMENT "Remove `/proc` tails..."
    VERBATIM
)

add_custom_command(
    OUTPUT unmount_sys_tail

    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/sys/hugepages" 
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/sys/mqueue"     
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/sys/shm" 
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/sys/pts" 

    COMMENT "Remove `/sys` tails..."
    VERBATIM
)

add_custom_command(
    OUTPUT unmount_dev_tail

    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/dev/hugepages" 
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/dev/mqueue"     
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/dev/shm" 
    COMMAND bash -c "sudo umount `grep -oP '/media/[A-Z-a-z\/]\+' ${LOG_ROOT}`/dev/pts" 

    COMMENT "Remove `/dev` tails..."
    VERBATIM
)
