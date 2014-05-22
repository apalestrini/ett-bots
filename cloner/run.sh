#!/bin/bash
# description: Shell scripts para el clonado de imágenes en diferentes arquitecturas de hardware.
# autor: Dte-ba

# first check if is root
if [ "$UID" -ne 0 ] ; then
	echo "You must be root to run this script!"
	exit 1
fi

# define the lib path
LIB_PATH=$(dirname $0)/lib/

# load lib functions
. $LIB_PATH/source.sh

# load configuration file
. $(dirname $0)/config.sh

if [[ -z "$DISK" ]]; then
	DISK=$1
fi

# check if the first parameter is a disk
if echo $DISK | grep -Eq '(s|h)d[a-e]$'
then

	# is a disk
	if ( hd_exist "$DISK" )
	then

		if [[ -z "$TASKS" ]]; then
			echo "No tasks for me :(, please define TASKS into config.sh"
			exit 0
		else
			D_SIZE=`hd_size "$DISK"`
			exit 0			
		fi

		# D_SIZE=`hd_size "$DISK"`
		# echo `convert_bytes_gb $D_SIZE`
		# RAM_SIZE=`ram_size`
		# echo `convert_kb_gb $RAM_SIZE`

	else
		echo "the disk $DISK not exists"
		exit 1
	fi

else
	echo "Give me a disk name into the first parameter or into config.sh ;)"
	exit 1
fi