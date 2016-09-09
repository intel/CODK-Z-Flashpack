#!/bin/sh 
set -e
#
# Script to flash Arduino 101 firmware via USB and dfu-util
#
PID="8087:0aba"
BIN="bin/dfu-util"
DFU="$BIN -d,$PID"

help() {
  echo "Usage: $0 ble_image"
  exit 1
}

flash() {
  echo "

** Flashing BLE **

"
  $DFU -a 8 -R -D $IMG
}

trap_to_dfu() {
  # If trapped.bin already exists, clean up before starting the loop
  [ -f "trapped.bin" ] && rm -f "trapped.bin"

  # Loop to read from 101 so that it stays on DFU mode afterwards
  until $DFU -a 4 -U trapped.bin > /dev/null 2>&1
  do
    sleep 0.1
  done

  # Clean up
  [ -f "trapped.bin" ] && rm -f "trapped.bin"
}

# Check for supplied BLE image
if [ -z "$1" ]; then
  help
fi
if [ ! -e "$1" ]; then 
  echo "Image not found: $1"
  exit 1
fi
IMG="$1"

echo "*** Reset the board to begin..."
trap_to_dfu

flash

if [ $? -ne 0 ]; then
  echo
  echo "***ERROR***"
  exit 1
else
  echo
  echo "!!!SUCCESS!!!"
  exit 0
fi

