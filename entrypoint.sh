#!/bin/bash

#Do you have the ROS robot location env var set?
[[ -z "${ROS_ROBOT_LOCATION}" ]] && echo "PLEASE SET ROS_ROBOT_LOCATION environment variable" && exit

# run nginx first
nginx -g 'daemon off;' &

# Start ffmpeg stuff
bash -c "ffmpeg -nostats -loglevel 0 -i tcp://${ROS_ROBOT_LOCATION}:5005 -c copy -f h264 - | ffmpeg -nostats -loglevel 0 -i - -c copy -f flv rtmp://192.168.1.5:1935/live/robot" &

wait -n
exit $?
