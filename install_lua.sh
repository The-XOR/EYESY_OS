#!/bin/bash
cd 
rm -rf ~/openFrameworks
wget https://github.com/openframeworks/openFrameworks/releases/download/0.12.0/of_v0.12.0_linuxarmv6l_release.tar.gz
tar -xzvf of_v*.tar.gz
rm of_v*.tar.gz
mv of_v* ~/openFrameworks
cd ~/openFrameworks/scripts/linux/debian
sudo ./install_dependencies.sh
sudo ./install_codecs.sh
cd ~/openFrameworks/scripts/linux
./compileOF.sh
make Release -C /home/music/openFrameworks/libs/openFrameworksCompiled/project
cd ~/openFrameworks/addons/
git clone https://github.com/danomatika/ofxLua.git --depth=1
cd ofxLua
git submodule init
git submodule update


