#!/bin/bash
# description: Parted functions

parted_mktable(){
  log "parted --script $1 mktable msdos"
  parted --script $1 mktable msdos >> $LOGS
}

parted_mkpart_mb(){
  local disk=$1
  local from=$2
  local to=$3
  local mode=$4
  local typee=$5
  local label=$6

  local dname=$( echo $disk | sed -r 's/[0-9]+//' )
  local pnumber=$( echo $disk | sed -r 's/[a-zA-Z]+//' )

  dname="/dev/${dname}"

  if [[ "$mode" = "primary" ]] || [[ "$mode" = "logical" ]]; then
    log "parted -a cylinder $dname --script -- unit MiB mkpart $mode $typee $from $to"
    parted -a cylinder $dname --script -- unit MiB mkpart $mode $typee $from $to >> $LOGS

    case $typee in
      "ntfs")
        log "mkfs.ntfs -Q -L $label ${dname}${pnumber}"
        mkfs.ntfs -Q -L $label ${dname}${pnumber} >> $LOGS
      ;;
      "ext4")
        log "mkfs.ext4 -L $label ${dname}${pnumber}"
        mkfs.ext4 -L $label ${dname}${pnumber} >> $LOGS
      ;;
      "linux-swap"|"swap")
        log "mkswap -L SWAP ${dname}${pnumber}"
        mkswap -L SWAP ${dname}${pnumber} >> $LOGS
      ;;
      *)
        echo "Unknown type $typee"
        return 1
      ;;
    esac

  else
    log "parted -a cylinder $dname --script -- unit MiB mkpart extended $from $to"
    parted -a cylinder $dname --script -- unit MiB mkpart extended $from $to >> $LOGS
  fi
}

parted_set_boot(){
  local disk=$1
  local partition=$2

  local dname="/dev/$disk"

  log "parted $dname --script set $partition boot on"
  parted $dname --script set $partition boot on >> $LOGS
}