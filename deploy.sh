#!/bin/bash
set -ex

# MODIFICARE QUESTO FILE e mettere il numero di scheda audio voluta
#sudo cp --remove-destination ./config/asound.conf /etc/asound.conf
aplay -l | grep "USB Audio"|awk  '{print "default.pcm.card " substr($2,1,1) "\ndefault.ctl.card " substr($2,1,1)}' | sudo tee /etc/asound.conf


# Blacklist scheda audio interna del raspberry
echo "blacklist snd_bcm2835" | sudo tee -a /etc/modprobe.d/alsa-blacklist.conf

# Add music user to tty
sudo usermod -a -G tty music

# Add nodejs Debian package as source.
# Note the need to allow releaseinfo changes. See https://askubuntu.com/questions/989906/explicitly-accept-change-for-ppa-label
curl -sL https://deb.nodesource.com/setup_14.x | sed -e 's/apt-get /apt-get --allow-releaseinfo-change /g' | sudo bash -

sudo touch /boot/ssh

# Debian packages
sudo apt install -y python-pygame python-liblo python-alsaaudio python-pip libffi-dev nodejs
sudo apt install -y libboost-filesystem1.62.0 liblua5.3-dev swig fbi raspi-config

# Python packages
sudo pip install psutil cherrypy numpy JACK-Client
sudo apt-get install --no-install-recommends -y puredata

# Node packages
cd web/node
npm install
npm install websocket
npm install tail

cd ~/EYESY_OS
# Move service files into place and make sure perms are set correctly.
# copy files
mkdir tmp
cp -r ./config/rootfs tmp/
sudo chown -R root:root tmp/rootfs
sudo chown -R music:music tmp/rootfs/home/music
sudo cp -fr --preserve=mode,ownership tmp/rootfs/* /

sudo cat ./config/cat2fstab>>./tmp/fstab
cp /etc/fstab ./tmp
sudo cp --remove-destination ./tmp/fstab /etc/fstab
sudo rm -fr tmp
mv ./config/openFrameworks /home/music/
sudo mv .config/libs/* /usr/lib/arm-linux-gnueabihf/
sync

#Installazione luajit:
cd /home/music
git clone https://luajit.org/git/luajit.git
cd luajit
make
export PKG_CONFIG_PATH=/home/music/luajit/etc

cd /home/music/openframeworks/addons/
git clone git://github.com/danomatika/ofxLua.git
cd ofxLua
git submodule init
git submodule update

sudo cp --remove-destination ./config/cmdline.txt /boot/
sudo cp --remove-destination ./config/config.txt /boot/

cd /home/music/EYESY_OS

sudo ./install_dependencies.sh
sudo ./install_codecs.sh
sudo rm install_dependencies.sh
sudo rm install_codecs.sh

sudo apt-get install -y xserver-xorg-video-fbturbo xterm 
