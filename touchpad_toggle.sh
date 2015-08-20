#!/usr/bin/env bash
cmd=synclient 
opt=`$cmd -l | grep TouchpadOff | cut -d= -f2`

if [[ "$opt" == " 0" ]]; then
	$cmd TouchpadOff=1
else
	$cmd TouchpadOff=0
fi

