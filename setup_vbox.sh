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


function create_vbox_disk_4gb(){
	cmake --build build --target vbox_create_disk_4gb
}

function check_qemu(){
	echo -e "-- Checking QEMU Path ${QEMU_PATH}"
	which $QEMU_PATH > /dev/null 2>&1 || (echo 'QEMU not installed. Please install QEMU.' && exit 1)
}

#####  
cmake --build build --target clean_build &&
cmake -S . -B build \
-DQEMU_HOME="/media/89fbfc92-6afb-4c5a-a889-199bc5f66e21/ijoe/QEMU_VM" \
-DVBOX_HOME="/media/89fbfc92-6afb-4c5a-a889-199bc5f66e21/ijoe/VBOX_VM" \
-DVM_ISO_HOME="/media/89fbfc92-6afb-4c5a-a889-199bc5f66e21/ijoe/ISO/LINUX/DEBIAN" \
-DVM_NAME="KZENLAB_BASE_OS_4GB" 

create_vbox_disk_4gb

#cmake --build build --target vbox_showvminfo
#cmake --build build --target demolish_empty_vbox_4gb

## Make
