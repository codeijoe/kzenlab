## UNMOUNT
#!/bin/bash

# ... (Your code to mount /dev, /dev/pts, /proc, /sys and chroot) ...

# Inside the chroot (if necessary):
# umount /dev/pts # If you mounted devpts inside chroot.

# Exit the chroot:
exit

# Outside the chroot:
LOG_LINUX_DEV="/tmp/umount_dev.log" # Log file for unmounting errors

# Unmount /sys, /proc, /dev/pts (in this order):
sudo umount /media/ijoe/root/sys 2> ${LOG_LINUX_DEV}
if [[ $? -ne 0 ]]; then
    echo "Error unmounting /sys. Check ${LOG_LINUX_DEV}."
    cat ${LOG_LINUX_DEV}
fi

sudo umount /media/ijoe/root/proc 2> ${LOG_LINUX_DEV}
if [[ $? -ne 0 ]]; then
    echo "Error unmounting /proc. Check ${LOG_LINUX_DEV}."
    cat ${LOG_LINUX_DEV}
fi

sudo umount /media/ijoe/root/dev/pts 2> ${LOG_LINUX_DEV}
if [[ $? -ne 0 ]]; then
    echo "Error unmounting /dev/pts. Check ${LOG_LINUX_DEV}."
    cat ${LOG_LINUX_DEV}
fi


# Finally, unmount /dev:
sudo umount /media/ijoe/root/dev 2> ${LOG_LINUX_DEV}
if [[ $? -ne 0 ]]; then
    echo "Error unmounting /dev. Check ${LOG_LINUX_DEV}."
    cat ${LOG_LINUX_DEV}
fi

echo "/dev, /dev/pts, /proc, and /sys unmounted successfully."