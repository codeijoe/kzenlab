#!/bin/bash
_dev=default

function mount_dvd1(){
	_id=1
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd2(){
	_id=2
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd3(){
	_id=3
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd4(){
	_id=4
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd5(){
	_id=5
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd6(){
	_id=6
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd7(){
	_id=7
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd8(){
	_id=8
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd9(){
	_id=9
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd10(){
	_id=10
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd11(){
	_id=11
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd12(){
	_id=12
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd13(){
	_id=13
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd14(){
	_id=14
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd15(){
	_id=15
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd16(){
	_id=16
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd17(){
	_id=17
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd18(){
	_id=18
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd19(){
	_id=19
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd20(){
	_id=20
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

function mount_dvd21(){
	_id=21
	_dvd=$(blkid | sed -n "/amd64 $_id\"/p" | grep -oP "^/dev/sr[0-9]+")
	if  ! mount | grep -q "DVD$_id"  ; then
    	mkdir -p /mnt/DVD$_id || true 
		mount -t iso9660 -o loop $_dvd /mnt/DVD$_id 
	fi
}

# for i in {1..21}; do
 	# _dev=$(blkid | sed -n "/amd64 $i\"/p" | grep -oP "^/dev/sr[0-9]+") 
	# if  ! mount | grep -q "DVD$_id"  ; then
		# mkdir -p /mnt/DVD$i || true 
		# mount -t iso9660 -o loop $_dev /mnt/DVD$i
	# fi
# done

# unmount : `for i in {1..21}; do umount /mnt/DVD$i; done`
mount_dvd1
mount_dvd2
mount_dvd3
mount_dvd4
mount_dvd5
mount_dvd6
mount_dvd7
mount_dvd8
mount_dvd9
mount_dvd10
mount_dvd11
mount_dvd12
mount_dvd13
mount_dvd14
mount_dvd15
mount_dvd16
mount_dvd17
mount_dvd18
mount_dvd19
mount_dvd20
mount_dvd21
# main
