#!/usr/bin/env bash
# A trivial script to toggle the touchpad on/off
#
# This is a bit hackish way, but I haven't yet found a better on

# We'll use the Synaptics driver CLI
cmd=synclient 
# This is the most brittle part. If the output format changes a bit, we're screwed
opt=`$cmd -l | grep TouchpadOff | cut -d= -f2`

if [ $opt == 0 ]; then
	$cmd TouchpadOff=1
else
	$cmd TouchpadOff=0
fi

