#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Load customised configuration
xrdb -merge ~/.Xresources

# Shortcuts
xbindkeys

# Set traditional cursor instead of the default X cross
xsetroot -cursor_name left_ptr &

# Start LXDE
exec startlxde

