#!/bin/bash

check_ffmpeg_running() {
  while true; do
    if ! ps -p $1 > /dev/null; then
      echo "ffmpeg stopped, exiting"
      exit 1
    fi
    sleep 1
  done
}

[[ -z "${ROS_ROBOT_LOCATION}" ]] && echo "PLEASE SET ROS_ROBOT_LOCATION environment variable" && exit

# run nginx first
nginx -g 'daemon off;' &

# Start ffmpeg with revised command
ffmpeg -nostats -loglevel 0 -i tcp://${ROS_ROBOT_LOCATION}:5005 -c copy -f flv rtmp://192.168.1.5:1935/live/robot &
FFMPEG_PID=$!

# check if ffmpeg is still running
check_ffmpeg_running $FFMPEG_PID &

wait -n
exit $?
