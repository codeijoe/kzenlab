#!/bin/bash

# DESC: Define Script Debugging
# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace       # Trace the execution of the script (debug)
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
_dvd1=default
_dvd2=default
_dvd3=default
_dvd4=default
_dvd5=default
_dvd6=default

_loops=default

##### KZENLAB Functions #####

# DESC: Import external .env file to script
# ARGS: None
# OUTS: None
# RETS: None
function import_env() {
	_iso_home=$(grep -F -- "ISO_HOME" .env | cut -d'=' -f2)
	_dvd1=$(grep -F -- "DVD1" .env | cut -d'=' -f2)
	_dvd2=$(grep -F -- "DVD2" .env | cut -d'=' -f2)
	_dvd3=$(grep -F -- "DVD3" .env | cut -d'=' -f2)
	_dvd4=$(grep -F -- "DVD4" .env | cut -d'=' -f2)
	_dvd5=$(grep -F -- "DVD5" .env | cut -d'=' -f2)
	_dvd6=$(grep -F -- "DVD6" .env | cut -d'=' -f2)
    _qemu_home=$(grep -F -- "QEMU_HOME" .env | cut -d'=' -f2)
    _vbox_home=$(grep -F -- "VBOX_HOME" .env | cut -d'=' -f2)
    _vbox_vm_home=$(grep -F -- "VBOX_VM_HOME" .env | cut -d'=' -f2)
    _vbox_disk_home=$(grep -F -- "VBOX_DISK_HOME" .env | cut -d'=' -f2)
    _vm_hyper_type=$(grep -F -- "VM_HYPER_TYPE" .env | cut -d'=' -f2)
    _vm_name=$(grep -F -- "VM_NAME" .env | cut -d'=' -f2)
    _vm_hostname=$(grep -F -- "VM_HOSTNAME" .env | cut -d'=' -f2)
    _vm_domain=$(grep -F -- "VM_DOMAIN" .env | cut -d'=' -f2)
    _vm_disk_size=$(grep -F -- "VM_DISK_SIZE" .env | cut -d'=' -f2)
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
-DVM_DOMAIN=$_vm_domain
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
function create_raw_disk(){
    cmake --build build --target create_raw_disk && \
    cmake --build build --target mounting_raw_disk
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
	cmake --build build --target unpack_debian12
}

function unloop(){
	# Unloop RAWDISK
    _loops=$(losetup -a | grep $_vm_name | cut -d' ' -f1 | grep -oE '/dev/loop[0-9]+' )

    losetup -d $_loops 
    if [ $? -ne 0 ]; then
    	echo "Error unloop..."
    else
	    echo $_loops" unloopped"
	fi

    #echo $_loops | xargs -I {} losetup -d {}
	#losetup -a | grep $_vm_name | cut -d' ' -f1 | grep -oE '/dev/loop[0-9]+' \
	#| xargs -I {} losetup -d {}

}

function start_qemu_uefi(){
	_file=$_vm_name
	_file+='.raw'
	echo $_file
	qemu-system-x86_64 -drive file=build/$_file,format=raw,if=virtio \
	-enable-kvm \
	-bios /usr/share/OVMF/OVMF_CODE.fd \
	-boot menu=on
}

function unmount_linux(){

	## /dev
	if mount | grep -q "on /media/$USER/root/dev "; then
		mount | grep ${USER}'/root/dev' | cut -d' ' -f3 | sort -r | xargs -I {} sudo umount {}
    	echo "/root/dev unmounted"
	fi
	#if mount | grep -q "on /media/$USER/root/dev "; then
    #	sudo umount /media/$USER/root/dev
    #	echo "/root/dev unmounted"
	#fi
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
	#if mount | grep -q "on /media/$USER/root/run "; then
    #	sudo umount /media/$USER/root/run
    #	echo "/root/run unmounted"
	#fi
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
		cmake --build build --target make_loops_mounted --verbose && \
		cmake --build build --target mounting_linux
	fi
}

function mount_dvd(){
	mount_dvd1 && \
	mount_dvd2 && \
	mount_dvd3 && \
	mount_dvd4 && \
	mount_dvd5 && \
	mount_dvd6 && \
	sudo cp -f base-os/DVD.list /media/$USER/ijoe/etc/apt/sources.list.d/
}

function unmount_dvd(){
	unmount_dvd1 && \
	unmount_dvd2 && \
	unmount_dvd3 && \
	unmount_dvd4 && \
	unmount_dvd5 && \
	unmount_dvd6 && \
	sudo rm -rf /media/$USER/ijoe/etc/apt/sources.list.d/DVD.list
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


function set_base_os(){
    unpack_debian12 && \
	cmake --build build --target mounting_linux && \
	cmake --build build --target chroot_debian
}

function set_kernel(){
	if [ ! -d "/mnt/DVD1" ]; then
    	echo "Mount DVD1 before installing some packages."
    else
		cmake --build build --target set_kernel 
	fi
}

function set_uefi_boot(){
	cmake --build build --target set_uefi_boot --verbose
}

# DESC: Demolish empty virtual disk
# ARGS: None
# OUTS: None
# RETS: None
function demolish_disk(){
	cmake --build build --target demolish_empty_vbox_4gb
}


# DESC: Setup partition for virtual disk
# ARGS: None
# OUTS: None
# RETS: None
function build_partition(){
    case $_hyper_type in
    	"VBOX")
			# cmake --build build --target build_empty_vbox_${_vm_disk_size}gb
			# cmake --build build --target check_tools
			setup_cmake
			part_setup
		;;
    	"QEMU")
			echo -n "QEMU matched"
		;;
	esac
}

function part_setup(){
	cmake --build build --target check_tools
	cmake --build build --target partition_setup
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
					create_raw_disk
				;;
	   	    -d9|--download-debian9)
					download_debian9
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