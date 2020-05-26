#!/bin/bash

GDRIVE_DIR=/home/dennis/googledrive/Sicherheit

echo '[rclone] Syncing local -> remote.'

if [ -d "$GDRIVE_DIR" ]; then
	if ! ps ax | grep -v grep | grep "rclone sync" > /dev/null; then
		rclone sync "$GDRIVE_DIR" googledrive:/Sicherheit && echo 'Finished local -> remote sync.'
	else
		echo '[rclone] A sync is already running.'
	fi
fi
