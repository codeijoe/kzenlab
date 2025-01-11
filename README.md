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
12. `bash setup.sh --set-uefi-boot`
	(run vbox again)

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
