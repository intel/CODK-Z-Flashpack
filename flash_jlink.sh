#!/bin/sh
set -e
#
# Script to flash Arduino 101 firmware via JTAG and Flyswatter2
#
scriptdir=$(dirname $(readlink -f $0))
help() {
	echo "Usage: $0 -a arc_binary -x x86_binary"
	exit 1
}

flash() {
	if [ x$arc_bin != "x" ] ; then
		$scriptdir/bin/openocd \
			-c "set arc_bin $arc_bin" \
			-f $scriptdir/scripts/interface/ftdi/jlink.cfg \
			-f $scriptdir/scripts/board/quark_se.cfg \
			-f $scriptdir/scripts/flash-arc-jlink.cfg
	fi
	if [ x$x86_bin != "x" ] ; then
		$scriptdir/bin/openocd \
			-c "set x86_bin $x86_bin" \
			-f $scriptdir/scripts/interface/ftdi/jlink.cfg \
			-f $scriptdir/scripts/board/quark_se.cfg \
			-f $scriptdir/scripts/flash-x86-jlink.cfg
	fi
}

# Parse command args
if [ $# -lt 2 ]; then
    help
fi

while [ $# -ge 1 ]; do
    arg="$1"
    case $arg in
        -a)
            arc_bin=$2
            shift
            ;;
        -x)
            x86_bin=$2
            shift # past argument
            ;;
        *)
            help # unknown option
            ;;
    esac
    shift # past argument or value
done

# Flash the board using JTAG
flash

if [ $? -ne 0 ]; then
  echo
  echo "***ERROR***"
  exit 1
else
  echo
  echo "!!!SUCCESS!!!"
fi
