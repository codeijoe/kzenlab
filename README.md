# kzenlab
Kzenlab (pronouns: kaizen lab) is a DryLab and Dev Environment OS with intended to run on UFD Only. Kzenlab used in Codeijoe Mentorship. Kzenlab comes with some variants.

1. kzenlab-base
2. kzenlab-localdev   (32GB)
3. kzenlab-remotedev  (32GB)
4. kzenlab-eval-retro (64GB) 
5. kzenlab-eval-osx (64GB)
6. kzenlab-eval-win (64GB)
7. kzenlab-eval-linux (64GB)

## Motivations
When a mentee join the mentorship, no matter the have they own laptop or not but tools should be standardize.

## How to build ?
### Pre-build
1. Download Debian 12 DVD at least DVD1 put at outside of repository
2. Follow the requirement at CMake

### Build
Follow these steps __paste-in-command__:
#### Download Debootstrap
1. `bash setup.sh --download-debian12`
2. `cp build/debian-12.tar.gz ..`

#### Setting Up
1. `bash setup.sh --clean`
2. `bash setup.sh --setup`
3. `bash setup.sh --build-raw`
4. `cp ../debian-12.tar.gz build/`
5. `bash setup.sh --set-base-os`
6. `bash setup.sh --mount-dvd`
7. `bash setup.sh --set-kernel`
8. `bash setup.sh --set-uefi-boot`
9. `bash setup.sh --create-vmdk`
10. `bash setup.sh --create-vboxvm`
    (run vbox, stop vm after boot fail)
11. `rm -rf build/log/set-*` 
12.	`bash setup.sh --unmount-dvd`
13. `bash setup.sh --set-uefi-boot`
	(run vbox again)


```
Creating config file /etc/default/grub with new version
Processing triggers for libc-bin (2.36-9+deb12u9) ...
Processing triggers for shim-signed:amd64 (1.44~1+deb12u1+15.8-1~deb12u1) ...
set_devicemap()>>>> /dev/loop31
ESP UUID: 8ED7-AC54
Root UUID: d4c14a95-3fca-4657-bd42-2dac4984049d
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.1.0-27-amd64
Found initrd image: /boot/initrd.img-6.1.0-27-amd64
done
```

```
grub-install: info: copying `/usr/lib/shim/shimx64.efi.signed' -> `/boot/efi/EFI/BOOT/BOOTX64.EFI'.
grub-install: info: copying `/usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed' -> `/boot/efi/EFI/BOOT/grubx64.efi'.
grub-install: info: copying `/usr/lib/shim/mmx64.efi.signed' -> `/boot/efi/EFI/BOOT/mmx64.efi'.
grub-install: info: copying `/usr/lib/shim/BOOTX64.CSV' -> `/boot/efi/EFI/BOOT/BOOTX64.CSV'.
grub-install: info: copying `/boot/grub/x86_64-efi/load.cfg' -> `/boot/efi/EFI/BOOT/grub.cfg'.
Installation finished. No error reported.
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.1.0-27-amd64
Found initrd image: /boot/initrd.img-6.1.0-27-amd64
done

```
#### Removing
Follow these steps __paste-in-command__:
1. `bash setup.sh --remove-vboxvm`
2. `bash setup.sh --unmount-dvd`
3. `bash setup.sh --unmount-linux` 
	(repeat until no-output)
4. `bash setup.sh --unloop`
5. `bash setup.sh --clean`

Checking up result:
`losetup -a | grep $USER`
`mount | grep $USER`

`losetup --find --show `

`losetup -d /dev/loop31`

`udisksctl loop-setup -f build/${VM_NAME}.raw | head -c -2 | cut -f 5 -d " " &> build/DEV_LOOP`

`cat build/DEV_LOOP | xargs -I {} udisksctl mount --block-device {}p3 --filesystem-type=auto --no-user-interaction | cut -f 4 -d " " &> build/ROOT_PART` 


sudo chroot /media/$USER/root bash -c 'df -h'