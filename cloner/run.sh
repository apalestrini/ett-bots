#!/bin/bash
# description: Shell scripts para el clonado de imágenes en diferentes arquitecturas de hardware.
# autor: Dte-ba

# first check if is root
if [ "$UID" -ne 0 ] ; then
  echo "You must be root to run this script!"
  exit 1
fi

echo ""
echo " Hi there i'm an ETT bot from Dte-ba bot army, my job is help you to clone some nets."
echo ""

# define the lib path
LIB_PATH=$(dirname $0)/lib/

# load lib functions
. $LIB_PATH/source.sh

# load configuration file
. $(dirname $0)/config.sh

# load executer functions
. $(dirname $0)/executer.sh

if [[ -z "$DISK" ]]; then
  DISK=$1
fi

# check if the first parameter is a disk
if echo $DISK | grep -Eq '(s|h)d[a-e]$'
then

  # is a disk
  if ( hd_exist "$DISK" )
  then

    DISK_FULLNAME="/dev/$DISK"

    if [[ -z "$TASKS" ]]; then
      echo "No tasks for me :(, please define TASKS into config.sh"
      exit 0
    else
      if (execute "${TASKS[*]}")
      then
        echo ""
        echo " Bye! ;)"
        echo ""
        exit 0
      else
        echo ""
        echo " :S Oops! Something wrong!"
        echo ""
        exit 1
      fi
    fi

  else
    echo_error "the disk $DISK not exists"
    exit 1
  fi

else
  echo_error "Unknown disk"
  echo " I need a disk name into the first parameter or into config.sh"
  echo ""
  exit 1
fi