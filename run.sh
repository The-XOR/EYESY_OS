#/bin/bash
echo starting Eyesy
cd /home/music/Eyesy

# make sure the log file exists
touch /tmp/video.log
sudo chown music:music /tmp/video.log
#amixer cset numid=11 on

systemctl start eyesy-python.service
systemctl start eyesy-web.service
systemctl start eyesy-web-socket.service
systemctl start eyesy-pd.service
