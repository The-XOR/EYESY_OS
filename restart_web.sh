#/bin/bash
echo Starting Eyesy Web Services

sudo systemctl stop eyesy-web-socket.service
sudo systemctl stop eyesy-web.service

sudo systemctl start eyesy-web.service
sudo systemctl start eyesy-web-socket.service
