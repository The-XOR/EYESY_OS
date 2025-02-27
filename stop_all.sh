#!/bin/bash
#amixer cset numid=11 off

sudo systemctl stop cherrypy.service
sudo systemctl stop eyesy-python.service
sudo systemctl stop eyesy-web.service
sudo systemctl stop eyesy-web-socket.service
sudo systemctl stop eyesy-pd.service
sudo systemctl stop splashscreen.service
sudo systemctl stop ttymidi.service
sudo service lightdm stop
sudo pkill -9 -f power_switch_monitor.py
