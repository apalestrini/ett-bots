#!/bin/bash
# description: Utils functions

echo_ok(){
  echo -e " [ \e[92mok\e[39m ] $1"
}

echo_error(){
  echo -e " [ \e[91merror\e[39m ] $1"
}

math_round()
{
  echo $( echo "$1" | awk '{printf("%d\n",$1 + 0.5)}')
}

# Arrays
array_contains() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

# convertions
convert_blocks_bytes(){
  echo $(($1*1024))
}

convert_bytes_decrease(){
  local i
  i=$((1024**$2))
  echo $(echo "scale=2; ($1/$i)" | bc)
}

convert_bytes_increase(){
  local i
  i=$((1024**$2))
  echo $(echo "scale=2; ($1*$i)" | bc)
}

convert_bytes_kb() {
  echo `convert_bytes_decrease $1 1`
}

convert_bytes_mb() {
  echo `convert_bytes_decrease $1 2`
}

convert_bytes_gb() {
  echo `convert_bytes_decrease $1 3`
}

convert_kb_mb() {
  echo `convert_bytes_decrease $1 1`
}

convert_gb_mb() {
  echo `convert_bytes_increase $1 1`
}

convert_mb_gb() {
  echo `convert_bytes_increase $1 1`
}

convert_kb_gb() {
  echo `convert_bytes_decrease $1 2`
}

mb_fix_gb(){
  local c=1024
  while [ $c -le $1 ]; do
    c=$(( $c + 1024))
  done

  echo $c
}