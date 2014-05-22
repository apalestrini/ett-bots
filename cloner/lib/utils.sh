#!/bin/bash
# description: Utils functions

# Arrays
array_contains() {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

# convertions
convert_blocks_bytes(){
	echo $(($1*1024))
	return 0
}

convert_bytes_decrease(){
	local i
	i=$((1024**$2))
	echo $(echo "scale=2; ($1/$i)" | bc)
	return 0
}

convert_bytes_increase(){
	local i
	i=$((1024**$2))
	echo $(echo "scale=2; ($1*$i)" | bc)
	return 0
}

convert_bytes_kb() {
	echo `convert_bytes_decrease $1 1`
	return 0
}

convert_bytes_mb() {
	echo `convert_bytes_decrease $1 2`
	return 0
}

convert_bytes_gb() {
	echo `convert_bytes_decrease $1 3`
	return 0
}

convert_kb_gb() {
	echo `convert_bytes_decrease $1 2`
	return 0
}