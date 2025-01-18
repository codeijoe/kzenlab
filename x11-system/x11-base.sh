######################################
# base-os.sh
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
#!/bin/bash

function set_x11_base(){
    DEBIAN_FRONTEND=noninteractive \
    apt install -yqq \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        xorg \
        xserver-xorg \
        xserver-xorg-core \
        xserver-xorg-legacy \
        xserver-xorg-input-all xserver-xorg-video-all \
        x11-xserver-utils \
        x11-xkb-utils \
        x11-utils     
}

function set_ssh_server(){
	apt install -yqq openssh-server
	#systemctl enable --now ssh
}

function set_base_tools(){
	DEBIAN_FRONTEND=noninteractive apt install -yqq vim nano less wget curl git zsh
}