#!/bin/bash

# helper functions

calculate_partition(){
  
  if echo $1 | grep -Eq '^[0-9]+%$'
  then
    local per=$(echo $1 | sed -r 's/%//')
    per=$(echo "scale=4; ($per/100)" | bc)
    local s=$(echo "scale=4; ($2*$per)" | bc)
    s=`convert_bytes_mb $s`
    s=`math_round $s 4`
    #echo "percent `convert_bytes_mb $s`"
    echo "`mb_fix_gb $s`"
  elif echo $1 | grep -Eq '^[0-9]+(GB|MB)$'
  then
    local u=$(echo $1 | sed -r 's/[0-9]+//')
    local s=$(echo $1 | sed -r 's/(GB|MB)//')
    local su=$1
    
    if [ "$u" = "MB" ]
    then
      su=`convert_bytes_increase $su`
    fi

    echo "`convert_gb_mb $s`"
  elif [ "$1" = "EXT" ]
  then
    echo "EXT"
  elif [ "$1" = "SWAP" ]
  then
    local ramsize=`ram_size`
    local  s=$(( $ramsize * 2))
    s=`convert_kb_mb $s`
    s=`math_round $s 2`
    echo "`mb_fix_gb $s`"
  elif [ "$1" = "DATA" ]
  then
    echo "DATA"
  else
    echo_error "Unknown partition type $1"
  fi
}

create_partitions(){
 local dsize
 local p
 local sizes

 dsize=`hd_size "$DISK"`
 
 local i=0
 for p in "${PARTITIONS[@]}"
 do
  sizes[$i]=`calculate_partition $p $dsize`
  true $((i++))
 done

 local smb=`convert_bytes_mb $dsize`
 smb=`math_round $smb`
 local others=$(( ${sizes[$IDX_GNU]}+${sizes[$IDX_WIN]}+${sizes[$IDX_SWAP]}+${sizes[$IDX_RECOVERY]} ))

 # calculate DATA
 sizes[$IDX_DATA]=$(( $smb - $others ))

 # calculate DATA
 sizes[$IDX_EXT]=$(( ${sizes[$IDX_SWAP]} + ${sizes[$IDX_DATA]} ))

 # create partitions

 local from=1
 local to=$(( $from + ${sizes[$IDX_WIN]} ))

 local disk="${DISK}1"

 # WIN
 if (parted_mkpart_mb "$disk" "$from" "$to" "primary" "ntfs" "WIN" )
 then
  echo_ok "$disk was created successfully"
 else
  echo_error "$disk creation fail"
  return 1
 fi

 from=$(( $to + 1 ))
 to=$(( $from + ${sizes[$IDX_GNU]} ))
 disk="${DISK}2"

 # GNU
 if (parted_mkpart_mb "$disk" "$from" "$to" "primary" "ext4" "GNU" )
 then
  echo_ok "$disk was created successfully"
 else
  echo_error "$disk creation fail"
  return 1
 fi

 # save point
 local fromlogic=$(($to+1))

 from=$(($to+1))
 to=$(($from+${sizes[$IDX_EXT]}))

 # save point
 local toext=$to

 # EXTENDED
 disk="${DISK}3"

 if (parted_mkpart_mb "$disk" "$from" "$to" "extended")
 then
  echo_ok "$disk was created successfully"
 else
  echo_error "$$diskcreation fail"
  return 1
 fi

 # save point for recovery partition
local fromrec=$(($to+1))
local torec=$(($fromrec+${sizes[$IDX_RECOVERY]}))
  
 # logical partition

 # SWAP
 from=$fromlogic
 to=$(($from+${sizes[$IDX_SWAP]}))
 disk="${DISK}5"

 if (parted_mkpart_mb "$disk" "$from" "$to" "logical" "linux-swap" )
 then
  echo_ok "$disk was created successfully"
 else
  echo_error "$disk creation fail"
  return 1
 fi

 # DATA
 from=$(( $to+1 ))
 to=$(($from+${sizes[$IDX_DATA]}))
 disk="${DISK}6"

 if (parted_mkpart_mb "$disk" "$from" "$toext" "logical" "ntfs" "DATA" )
 then
  echo_ok "$disk was created successfully"
 else
  echo_error "$disk creation fail"
  return 1
 fi

 # recovery partition
 disk="${DISK}4"

 if (parted_mkpart_mb "$disk" "$fromrec" "$smb" "primary" "ext4" "RECOVERY")
 then
  echo_ok "$disk was created successfully"

  if (parted_set_boot "$DISK" "4")
  then
   echo_ok "${DISK}4 boot on"
  else
   echo_error "${DISK}4 setting boot flag"
   return 1
  fi

 else
  echo_error "$disk creation fail"
  return 1
 fi

 echo_ok "Partitions ${DISK}1 ${DISK}2 { ${DISK}5 ${DISK}6 } ${DISK}4 created successfully"
}