#!/bin/bash

set -ex

# MODIFICARE QUESTO FILE e mettere il numero di scheda audio voluta
sudo cp --remove-destination config/asound.conf /etc/asound.conf

# Add music user to tty
sudo usermod -a -G tty music

# Add nodejs Debian package as source.
# Note the need to allow releaseinfo changes. See https://askubuntu.com/questions/989906/explicitly-accept-change-for-ppa-label
curl -sL https://deb.nodesource.com/setup_14.x | sed -e 's/apt-get /apt-get --allow-releaseinfo-change /g' | sudo bash -

# Debian packages
sudo apt install -y python-pygame python-liblo python-alsaaudio python-pip libffi-dev nodejs
sudo apt install libboost-filesystem1.62.0

# Python packages
sudo pip install psutil cherrypy numpy JACK-Client
sudo apt-get install --no-install-recommends -y puredata

# Node packages
cd web/node && npm install && cd ../..

# Move service files into place and make sure perms are set correctly.
sudo chmod 644 slsystemd/*
sudo cp systemd/* /etc/systemd/system

# Move PD into place.
#cp pd/externals/*.pd_linux ../../pdexternals

# Reload services.
sudo systemctl daemon-reload

cd /home/music/EYESY_OS

mv ./config/openFrameworks /home/music/
mv ./config/openFrameworks-10 /home/music/

sudo ./install_dependencies.sh
sudo ./install_codecs.sh
sudo rm install_dependencies.sh
sudo rm install_codecs.sh


# ------------------ todo: controllare se servono ancora
#pushd /usr/lib/arm-linux-gnueabihf
#sudo cp librtaudio.so librtaudio.so.5
#popd


#sudo systemctl enable eyesy-web.service
#sudo systemctl enable eyesy-web-socket.service
#sudo systemctl enable eyesy-pd.service
