#!/bin/bash

unset SUCCESS
on_exit() {
  if [ -z "$SUCCESS" ]; then
    echo "ERROR: $0 failed.  Please fix the above error."
    exit 1
  else
    echo "SUCCESS: $0 has completed."
    exit 0
  fi
}
trap on_exit EXIT

# Sanity check
if [ -d ../.repo ]; then
  cd ..
fi
if [ ! -d .repo ]; then
  echo "ERROR: Must run this script from the base of the repo."
  SUCCESS=true
  exit 255
fi

# Save Base Directory
BASEDIR=$(pwd)

################ Apply Patches Below ####################

PATCHES=""
if [[ $1 == "d2spr" ]]; then
  PATCHES="$PATCHES 56077 56078" # Lte Tile
  PATCHES="$PATCHES 55626 55399" # Lockscreen
  PATCHES="$PATCHES 56100" # Statusbar Clock and Date actions
  PATCHES="$PATCHES 56002 56001" # BT / audio
  PATCHES="$PATCHES 55903" # sending apk 
fi

if [[ -n $PATCHES ]]; then
  . build/envsetup.sh
  repo abandon auto &>/dev/null
  set -e
  repopick -b $PATCHES
  SUCCESS=true
  exit 0
else
  echo "ERROR: No target specified."
  SUCCESS=
  exit 1
fi