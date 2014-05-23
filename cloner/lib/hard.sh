#!/bin/bash
# description: Hardware functions

hd_list() {
  echo $(cat /proc/partitions | grep -E '(s|h)d[a-e]$' | awk '{ print $4 }')
}

hd_exist() {
  array_contains $1 `hd_list`
  return $?
}

hd_size() {
  if ( hd_exist "$1" )
  then
    local s
    s=$(cat /proc/partitions | grep "$1" | awk '{ print $3 }')
    echo `convert_blocks_bytes $s`
  else
    return 1
  fi
}

ram_size() {
  echo $(cat /proc/meminfo | grep "MemTotal:" | awk '{ print $2 }')
}