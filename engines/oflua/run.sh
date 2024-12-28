#!/bin/bash
export LUA_PATH="/home/music/EYESY_OS/engines/oflua/?.lua;;"

# make sure log ownership is not root
sudo chown music:music /tmp/video.log

cd /home/music/EYESY_OS/engines/oflua/eyesy/
export DISPLAY=:0; stdbuf -o0 bin/eyesy &> /tmp/video.log
