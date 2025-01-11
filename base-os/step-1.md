# STEP 1 
## Installing Debian using debootstrap

### Paste-in-command
```
### INSTALL 
sudo debootstrap --arch amd64 --include=curl bookworm /media/ijoe/root http://ftp.uk.debian.org/debian



### DOWNLOAD DEBIAN BASE

####### DEBIAN 11
sudo debootstrap --arch amd64 --include=curl bullseye /tmp/debian-11 http://deb.debian.org/debian/

sudo chroot /tmp/debian-11
	apt update
	apt install salt-minion
	exit

sudo tar -czf debian-11.tar.gz -C /tmp debian-11



####### DEBIAN 9
sudo debootstrap --arch=amd64 --include=curl --make-tarball=debian-9.tar stable /tmp/debian http://deb.debian.org/debian

sudo debootstrap --arch amd64 --include=curl,git,zsh,gdisk stretch /media/ijoe/root http://archive.debian.org/debian

sudo tar -czf debian-9.tar.gz -C /tmp debian-9




debootstrap --arch amd64 --make-tarball=debian-base.tar stable /tmp/debian --include=salt-minion bullseye http://ftp.uk.debian.org/debian



tar -tf debian-base.tar | less

#### UNPACK
sudo debootstrap --arch=amd64 --unpack-tarball=debian-base.tar stable /media/ijoe/root/

tar -xzvf debootstrap.tar.gz -C /media/user/root
/media/user/root/debootstrap stable /media/user/root http://deb.debian.org/debian

### MOUNTING
mkdir -p /media/ijoe/root/proc
mkdir -p /media/ijoe/root/sys
mkdir -p /media/ijoe/root/dev
mkdir -p /media/ijoe/root/run

sudo mount --make-rslave --rbind /proc /media/ijoe/root/proc
sudo mount --make-rslave --rbind /sys /media/ijoe/root/sys
sudo mount --make-rslave --rbind /dev /media/ijoe/root/dev
sudo mount --make-rslave --rbind /run /media/ijoe/root/run
TERM=xterm-color LANG=C.UTF-8 sudo chroot /media/ijoe/root /bin/bash

sudo umount /media/ijoe/root/proc
sudo umount /media/ijoe/root/sys
sudo umount /media/ijoe/root/dev
sudo umount /media/ijoe/root/run

sudo lsof +D /media/ijoe/root/proc
sudo fuser -m /media/ijoe/root/proc

sudo fuser -k -m /media/ijoe/root/proc



# Ensure keyrings dir exists
mkdir -p /etc/apt/keyrings
# Download public key
curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
# Create apt repo target configuration
curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources

echo 'Package: salt-*
Pin: version 3006.*
Pin-Priority: 1001' | sudo tee /etc/apt/preferences.d/salt-pin-1001
```


convert      --srcfilename <filename>
               --dstfilename <filename>
               [--stdin]|[--stdout]
               [--srcformat VDI|VMDK|VHD|RAW|..]
               [--dstformat VDI|VMDK|VHD|RAW|..]
               [--variant Standard,Fixed,Split2G,Stream,ESX]

vbox-img convert --srcfilename build/$VM_NAME.raw --srcformat RAW --dstfilename build/$VM_NAME.vdi --dstformat VDI --variant Standard

vboxmanage createmedium disk --filename build/$VM_NAME.vmdk --format=VMDK --variant RawDisk --property RawDrive=/dev/loop31

sudo grub-install --boot-directory=/mnt/boot --uefi-secure-boot /dev/sda

grub-install --target=x86_64-efi /dev/loop31 --bootloader-id=GRUB --modules="tpm" --efi-directory=/media/ijoe/EFI/ --boot-directory=/media/ijoe/root/boot --uefi-secure-boot --removable


=== LOOP DEVICE Common Issues and Fixes

-- Loop Device chown issue to permission
`sudo chmod 666 /dev/loop31` 

-- Caching Issue on VBOX
Disable the Use Host I/O Cache

-- Create VMDK image right way
```
vboxmanage internalcommands createrawvmdk -filename build/$VM_NAME.vmdk -rawdisk /dev/loop32


```


qemu-system-x86_64 \ 
  -drive file=.iso,media=cdrom \
  -drive file=build/KZENLAB_BASE_OS_2GB.raw,format=raw,if=virtio \
  -enable-kvm \                       
  -bios /usr/share/OVMF/OVMF_CODE.fd \
  -boot menu=on

qemu-system-x86_64 -drive file=build/KZENLAB_BASE_OS_2GB.raw,format=raw,if=virtio -enable-kvm -bios /usr/share/OVMF/OVMF_CODE.fd -boot menu=on



--- Kernel SYNC
`sync`

+++++++++++ SCRIPT
-- CHROOT SCRIPT
```
#!/bin/bash

CHROOT_DIR="/media/"
DVD_MOUNT="/mnt"

# Mount essential filesystems
mount --bind /proc $CHROOT_DIR/proc
mount --bind /sys $CHROOT_DIR/sys
mount --bind /dev $CHROOT_DIR/dev
mount --bind /dev/pts $CHROOT_DIR/dev/pts
mount --bind $DVD_MOUNT $CHROOT_DIR/media/dvd

# Copy resolv.conf for networking (if needed)
cp /etc/resolv.conf $CHROOT_DIR/etc/

# Enter chroot
chroot $CHROOT_DIR /bin/bash
```


--- MOTD

cat << EOF > /etc/update-motd.d/00-header
#!/bin/sh
export TERM=linux
clear
printf "\n"
printf "'##:::'##:'########:'########:'##::: ##:'##::::::::::'###::::'########::\n"
printf " ##::'##::..... ##:: ##.....:: ###:: ##: ##:::::::::'## ##::: ##.... ##:\n"
printf " ##:'##::::::: ##::: ##::::::: ####: ##: ##::::::::'##:. ##:: ##:::: ##:\n"
printf " #####::::::: ##:::: ######::: ## ## ##: ##:::::::'##:::. ##: ########::\n"
printf " ##. ##::::: ##::::: ##...:::: ##. ####: ##::::::: #########: ##.... ##:\n"
printf " ##:. ##::: ##:::::: ##::::::: ##:. ###: ##::::::: ##.... ##: ##:::: ##:\n"
printf " ##::. ##: ########: ########: ##::. ##: ########: ##:::: ##: ########::\n"
printf "..::::..::........::........::..::::..::........::..:::::..::........:::\n"
printf "Ver 0.1.5-SNAPSHOT Tathir (c)2024. Indra Wahjoedi<indra.wahjoedi@tathir.xyz>\n"
printf "Kzenlab is pronounced as "kei-zen-lab"\n"
printf "Provide by Tathir to support Bimbel Informatika Klaudizen\n"
printf "\n"
EOF

chmod +x /etc/update-motd.d/00-header
rm /etc/update-motd.d/10-uname
rm /etc/motd


