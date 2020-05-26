#!/bin/bash

GDRIVE_DIR=/home/dennis/googledrive/Sicherheit

echo '[rclone] Syncing remote -> local.'

if [ -d "$GDRIVE_DIR" ]; then
	if ! ps ax | grep -v grep | grep "rclone sync" > /dev/null; then
		rclone sync googledrive:/Sicherheit "$GDRIVE_DIR" && echo '[rclone] Finished remote -> local sync.'
	else
		echo '[rclone] A sync is already running.'
	fi
fi
