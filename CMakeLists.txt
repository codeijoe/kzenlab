# CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project(VMSetup)

## Environment variables as CMake cache variables
set(HYPER_TYPE "VBOX" CACHE STRING "Hypervisor Type")

set(VBOX_PATH "/usr/bin/VBoxManage" CACHE STRING "Path to VBoxManage executable")
set(QEMU_PATH "/usr/bin/qemu-system-x86_64" CACHE STRING "Path to VBoxManage executable")

#### VM
set(VM_NAME "KZENLAB" CACHE STRING "VM Name")
set(VM_DOMAIN "codeijoe.org" CACHE STRING "VM Domain")
set(VM_HOSTNAME "kzenlab" CACHE STRING "VM Hostname")

#### ISO
set(VM_ISO_HOME "/home/ijoe/ISO/LINUX/DEBIAN" CACHE STRING "ISO DEBIAN Directory")
set(VM_ISO_DEBIAN127_DVD "debian-12.7.0-amd64-DVD-1.iso" CACHE STRING "Debian ISO File")
set(VM_ISO_DEBIAN128_CD "debian-12.8.0-amd64-netinst.iso" CACHE STRING "Debian Netinstall CD ISO File")
set(VM_ISO_DEBIAN128_DVD_1 "debian-12.8.0-amd64-DVD-1.iso" CACHE STRING "Debian Netinstall CD ISO File")


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
set(VM_DISK_4GB "${VM_NAME}--4GB.vdi" CACHE STRING "4GB Disk")
set(VM_DISK_8GB "${VM_NAME}--8GB.vdi" CACHE STRING "8GB Disk")
set(VM_DISK_16GB "${VM_NAME}--16GB.vdi" CACHE STRING "16GB Disk")
set(VM_DISK_32GB "${VM_NAME}--32GB.vdi" CACHE STRING "32GB Disk")
set(VM_DISK_64GB "${VM_NAME}--64GB.vdi" CACHE STRING "64GB Disk")


### Create a target to print the variables for debugging
add_custom_target(
    print_vm_env
    COMMAND ${CMAKE_COMMAND} -E echo "HYPER_TYPE: ${HYPER_TYPE}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_PATH: ${VBOX_PATH}"
    COMMAND ${CMAKE_COMMAND} -E echo "QEMU_PATH: ${QEMU_PATH}"

    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_HOME: ${VBOX_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_VM_HOME: ${VBOX_VM_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_NAME: ${VM_NAME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_ISO_HOME: ${VM_ISO_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_ISO_DEBIAN12_CD: ${VM_ISO_DEBIAN12_CD}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_ISO_DEBIAN12_DVD: ${VM_ISO_DEBIAN12_DVD}"    
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_HOME: ${VBOX_DISK_HOME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_4GB: ${VM_RAWDISK_4GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_8GB: ${VM_RAWDISK_8GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB: ${VM_RAWDISK_16GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_32GB: ${VM_RAWDISK_32GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_64GB: ${VM_RAWDISK_64GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_4GB: ${VM_DISK_4GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_8GB: ${VM_DISK_8GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_16GB: ${VM_DISK_16GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_32GB: ${VM_DISK_32GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_64GB: ${VM_DISK_64GB}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_HOSTNAME: ${VM_HOSTNAME}"
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DOMAIN: ${VM_DOMAIN}"
    COMMENT "Printing VM environment variables"
)

# Optionally, write the environment variables to a file
add_custom_target(
    write_vm_env
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_HOME=${VBOX_HOME}" > vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "HYPER_TYPE=${HYPER_TYPE}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_VM_HOME=${VBOX_VM_HOME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_PATH=${VBOX_PATH}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "QEMU_PATH=${QEMU_PATH}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_NAME=${VM_NAME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_ISO_HOME=${VM_ISO_HOME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_ISO_DEBIAN12_CD=${VM_ISO_DEBIAN12_CD}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_ISO_DEBIAN12_DVD=${VM_ISO_DEBIAN12_DVD}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX_DISK_HOME=${VBOX_DISK_HOME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_4GB=${VM_RAWDISK_4GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_8GB=${VM_RAWDISK_8GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB=${VM_RAWDISK_16GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB=${VM_RAWDISK_32GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_RAWDISK_16GB=${VM_RAWDISK_64GB}" >> vm_env.sh

    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_4GB=${VM_DISK_4GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_8GB=${VM_DISK_8GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_16GB=${VM_DISK_16GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_32GB=${VM_DISK_32GB}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DISK_64GB=${VM_DISK_64GB}" >> vm_env.sh

    COMMAND ${CMAKE_COMMAND} -E echo "VM_HOSTNAME=${VM_HOSTNAME}" >> vm_env.sh
    COMMAND ${CMAKE_COMMAND} -E echo "VM_DOMAIN=${VM_DOMAIN}" >> vm_env.sh
    #COMMAND ${CMAKE_COMMAND} -E env bash -c "build/vm_env.sh 2>&1" || (echo 'Fail to export ENV.' && exit 1)
    #COMMAND ${CMAKE_COMMAND} -E env -- bash -c "source vm_env.sh"
    COMMENT "Writing VM environment variables to vm_env.sh"
)

##### COMMON TARGET #####
add_custom_target(
    check_vbox
    COMMAND ${CMAKE_COMMAND} -E echo "Checking for VBOX at ${VBOX_PATH}..."
    COMMAND ${CMAKE_COMMAND} -E env sh -c "which ${VBOX_PATH} > vbox 2>&1 || (echo 'VBOX not installed. Please install VirtualBox.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E env sh -c "which ${VBOX_PATH}"    
    COMMAND ${CMAKE_COMMAND} -E echo "VBOX found at ${VBOX_PATH}."
    COMMENT "Checking VBOX installation"
    VERBATIM
)

add_custom_target(
    check_qemu
    COMMAND ${CMAKE_COMMAND} -E echo "Checking for QEMU at ${QEMU_PATH}..."
    COMMAND ${CMAKE_COMMAND} -E env bash -c "which ${QEMU_PATH} > qemu 2>&1 || (echo 'QEMU not installed. Please install QEMU.' && exit 1)"
    COMMAND ${CMAKE_COMMAND} -E echo "QEMU found at ${QEMU_PATH}."
    COMMENT "Checking QEMU installation"
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
    COMMAND ${CMAKE_COMMAND} -E make_directory ${VM_ISO_HOME}
    COMMAND ${CMAKE_COMMAND} -E echo "Directory ${VM_ISO_HOME} is ready."
    COMMENT "Checking and creating directory"
)

add_custom_target(
	clean_build
    COMMAND ${CMAKE_COMMAND} -E rm -rf ${CMAKE_BINARY_DIR}/*    
    COMMENT "Cleaning the build directory ${CMAKE_BINARY_DIR}"
)

### Group all targets under a single "setup" target
add_custom_target(
    setup_env
    #if ( ${HYPER_TYPE} STREQUAL "VBOX" )
    #message(STATUS "YAELAAAH...")
    DEPENDS write_vm_env print_vm_env check_or_create_directory 
    COMMENT "Running all setup tasks"
)

##### VBOX TARGET #####

add_custom_target(
    build_empty_vbox_4gb
    COMMAND ${VBOX_PATH} storageattach ${VM_NAME} --storagectl "SATA01" --port 1 --device 0 --type hdd --medium "${VBOX_DISK_HOME}/${VM_DISK_4GB}"    
    DEPENDS ${VBOX_VM_HOME}/${VM_NAME}/${VM_NAME}.vbox
    DEPENDS ${VBOX_DISK_HOME}/${VM_DISK_4GB}
    DEPENDS setup_env
    COMMENT "Building empty VBOX 4GB Virtual Machine"
)

add_custom_target(
    demolish_empty_vbox_4gb
    COMMAND ${VBOX_PATH} unregistervm ${VM_NAME} --delete-all   
    COMMENT "Demolish empty VBOX 4GB Virtual Machine"
)

add_custom_target(
    vbox_showvminfo
    IF( EXISTS ${VBOX_HOME}/${VM_NAME}/${VM_NAME}.vbox )
         COMMAND ${VBOX_PATH} showvminfo ${VM_NAME}
    ENDIF()
    COMMENT "Show information of VBOX 4GB Virtual Machine"
)


#### Remove Virtual Machine
add_custom_target(
    remove_vbox_vm
    COMMENT "WARNING!!! Do It Manually"
)

########## VBOX BUILD ##########

#### Create empty 4GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VM_DISK_4GB}
    COMMAND ${VBOX_PATH} createmedium disk --filename ${VBOX_DISK_HOME}/${VM_DISK_4GB} --format=VDI --variant Standard --size=3500
    COMMENT "Create 4GB VDI..."
    VERBATIM
)

#### Create empty 8GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VM_DISK_8GB}
    COMMAND ${VBOX_PATH} createmedium disk --filename ${VBOX_DISK_HOME}/${VM_DISK_8GB} --format=VDI --variant Standard --size=7500
    COMMENT "Create 8GB VDI..."
    VERBATIM
)

#### Create empty 16GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VM_DISK_16GB}
    COMMAND ${VBOX_PATH} createmedium disk --filename ${VBOX_DISK_HOME}/${VM_DISK_16GB} --format=VDI --variant Standard --size=15500
    COMMENT "Create 16GB VDI..."
)

#### Create empty 32GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VM_DISK_32GB}
    COMMAND ${VBOX_PATH} createmedium disk --filename ${VBOX_DISK_HOME}/${VM_DISK_32GB} --format=VDI --variant Standard --size=31500
    COMMENT "Create 32GB VDI..."
)

#### Create empty 64GB VDI
add_custom_command(
    OUTPUT ${VBOX_DISK_HOME}/${VM_DISK_64GB}
    COMMAND ${VBOX_PATH} createmedium disk --filename ${VBOX_DISK_HOME}/${VM_DISK_64GB} --format=VDI --variant Standard --size=63500
    COMMENT "Create 64GB VDI..."
)

#### Create VBOX Virtual Machine
add_custom_command(
    OUTPUT ${VBOX_VM_HOME}/${VM_NAME}/${VM_NAME}.vbox
    COMMAND ${VBOX_PATH} createvm --basefolder=${VBOX_VM_HOME} --name ${VM_NAME} --register 
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --description "Klaudizen Lab ${VM_NAME}"
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --memory=2048 --vram=128 --acpi=on --ioapic=on --cpus=3 --pae=on --long-mode=on
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --hwvirtex=on --paravirt-provider=kvm --nested-paging=on --nested-hw-virt=on
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --chipset=piix3
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --graphicscontroller vmsvga
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --tpm-type 2.0 
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --firmware efi64 
    COMMAND ${VBOX_PATH} modifynvram ${VM_NAME} inituefivarstore
    COMMAND ${VBOX_PATH} modifynvram ${VM_NAME} enrollmssignatures
    COMMAND ${VBOX_PATH} modifynvram ${VM_NAME} enrollorclpk

    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --mouse=ps2 --keyboard=ps2  
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --uart1 0x3f8 4 --uart-type1=16550A --uart-mode1 server /tmp/vbox 
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --nic1=nat --nic-type1=Am79C973 --cable-connected1=on 
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --nat-pf1 "SSH,tcp,,2200,,22" 
    COMMAND ${VBOX_PATH} modifyvm ${VM_NAME} --nat-pf1 "VNC,tcp,,15900,,5900" 

    COMMAND ${VBOX_PATH} storagectl ${VM_NAME} --name "SATA01" --add sata --controller IntelAHCI
    COMMAND ${VBOX_PATH} storageattach ${VM_NAME} --storagectl "SATA01" --port 0 --device 0 --type dvddrive --medium ${VM_ISO_HOME}/${VM_ISO_DEBIAN128_CD}
    COMMENT "Create VBOX VM ${VM_NAME}"
)

#### Control VBOX Virtual Machine
