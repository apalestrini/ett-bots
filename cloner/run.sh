#!/bin/bash
# description: Shell scripts para el clonado de imágenes en diferentes arquitecturas de hardware.
# autor: Dte-ba

# first check if is root
if [ "$UID" -ne 0 ] ; then
  echo "You must be root to run this script!"
  exit 1
fi

echo ""
echo -e " \e[94mHi there i'm an ETT bot i belong to Dte-ba bot army, my job is help you to clone some netbooks.\e[39m"
echo -e " \e[94mIf you find BUGS please report them on https://github.com/Dte-ba/ett-bots/issues\e[39m"
echo ""

# define the lib path
LIB_PATH=$(dirname $0)/lib/

# define the log
mkdir -p "/var/log/ett_bot"
NOW=$(date +"%Y%m%d")
LOGS="/var/log/ett_bot/$NOW.log"

log(){
  echo $@ >> $LOGS
}

log ""
log $(date +"%Y-%m-%d %H:%M:%S")
log ""

# load lib functions
. $LIB_PATH/source.sh

# load configuration file
. $(dirname $0)/config.sh

# load executer functions
. $(dirname $0)/executer.sh

if [[ -z "$DISK" ]]; then
  if echo $1 | grep -Eq '(s|h)d[a-e]$'
  then
    DISK=$1
  else
    select sdisk in `hd_list`
    do
      DISK=$sdisk
      break
    done
  fi
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
      echo ""
      echo -e " \e[91mWARNING: \e[39m ALL DATA on $DISK_FULLNAME WILL BE LOST"
      echo ""
      read -p " Continue? [y/N]" promp

      if [[ "$promp" = "y" ]]
      then
        if (execute "${TASKS[*]}")
        then
          echo ""
          echo " Bye! ;)"
          echo ""
          exit 0
        else
          echo ""
          echo " :S Oops! Something wrong!"
          echo " See the log $LOGS"
          echo " You can report the error on https://github.com/Dte-ba/ett-bots/issues"
          echo ""
          exit 1
        fi
      else
        echo ""
        echo " Bye! ;)"
        echo ""
        exit 0
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
