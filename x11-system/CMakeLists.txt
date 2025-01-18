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
project(x11-system)


set(SET_X11_BASE "${CMAKE_BINARY_DIR}/log/set-x11-base" CACHE INTERNAL "APT Source")

##### BUILD RAW TARGET #####
######################################
# TARG: x11-base
# PROC: setup/x11
# DESC: Install X11 Base
######################################
add_custom_target(
    x11-base
    DEPENDS ${SET_X11_BASE}
    COMMENT "X11 Base"
)

#======================================

############### COMMAND ###############
######################################
# COMD: log/set-x11-base
# PROC: setup/x11
# DESC: Install X11 Base
######################################
add_custom_command(
    OUTPUT ${SET_X11_BASE}
    COMMAND bash -c "${CHROOT_CMD} ${CHROOT_DIR} bash -c '. /root/x11-base.sh; set_x11_base'" &> ${SET_X11_BASE}

    DEPENDS ${SET_KERNEL}
    COMMENT "Installing X11 Base"  
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
 	VERBATIM
)