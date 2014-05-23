#!/bin/bash

if [[ -z "$LIB_PATH" ]] ; then
  echo "ERROR: No se ha declarado la ruta de librerias"
  exit 1
fi

. $LIB_PATH/utils.sh

. $LIB_PATH/hard.sh

. $LIB_PATH/parted.sh