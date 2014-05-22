#!/bin/bash

# D_SIZE=`hd_size "$DISK"`
# echo `convert_bytes_gb $D_SIZE`
# RAM_SIZE=`ram_size`
# echo `convert_kb_gb $RAM_SIZE`

create_table(){
  echo_ok "Partition table created on $DISK_FULLNAME"
  return 0
}

create_partitions(){
 echo_ok "Partitions created on $DISK_FULLNAME"
 return 0
}

restore_recu(){
 echo_ok "Recovery partition restored"
 return 0
}

restore_data(){
 echo_ok "Data partition restored"
 return 0
}

mount_swap(){
 echo_ok "SWAP mounted"
 return 0
}

copy_img_gnu(){
 echo_ok "GNU image copied"
 return 0
}

copy_img_win(){
 echo_ok "WIN image copied"
 return 0
}

restore_gnu(){
 echo_ok "GNU image restored"
 return 0
}

restore_win(){
 echo_ok "WIN image restored"
 return 0
}

# execute each operations

execute() {
  local t

  # check the taks
  for t in $*
  do
    case $t in
      "CREATE_TABLE"|"CREATE_PARTITIONS"|"RESTORE_RECU"|"RESTORE_DATA"|"MOUNT_SWAP"|"COPY_IMG_GNU"|"COPY_IMG_WIN"|"RESTORE_GNU"|"RESTORE_WIN")
      ;;
      *)
      echo_error "Unknown task $t"
      exit 1
      ;;
    esac
  done

  for t in $*
  do
    case $t in
      "CREATE_TABLE")
        if !(create_table)
        then
          echo_error "Trying to create the partition table on $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "CREATE_PARTITIONS")
        if !(create_partitions)
        then
          echo_error "Trying to create partitions on $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "RESTORE_RECU")
        if !(restore_recu)
        then
          echo_error "Restoring Recovery partition on $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "RESTORE_DATA")
        if !(restore_data)
        then
          echo_error "Restoring Data partition on $DISK_FULLNAME"
          exit 1
        fi
      ;;
      "MOUNT_SWAP")
        if !(mount_swap)
        then
          echo_error "Mounting SWAP"
          exit 1
        fi
      ;;
      "COPY_IMG_GNU")
        if !(copy_img_gnu)
        then
          echo_error "Coping GNU image"
          exit 1
        fi
      ;;
      "COPY_IMG_WIN")
        if !(copy_img_win)
        then
          echo_error "Coping WIN image"
          exit 1
        fi
      ;;
      "RESTORE_GNU")
        if !(restore_gnu)
        then
          echo_error "Restoring GNU image"
          exit 1
        fi
      ;;
      "RESTORE_WIN")
        if !(restore_win)
        then
          echo_error "Restoring WIN image"
          #exit 1
        fi
      ;;
    esac
  done

  return 0
}