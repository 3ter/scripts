#!/bin/bash

GDRIVE_DIR=/home/dennis/googledrive/Sicherheit

echo '[rclone] Watching locally.'

if [ -d "$GDRIVE_DIR" ]; then
    while true; do
        # sync at max every 10 minutes
        inotifywait --event close_write --recursive "$GDRIVE_DIR" && bash /home/dennis/Documents/scripts/rclone_local2remote.sh && sleep 10m 
    done
fi
