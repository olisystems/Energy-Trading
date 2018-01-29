#!/bin/bash

echo "Installing latest software for raspbian stretch..."
sudo apt-get update && sudo apt-get upgrade -yy
echo "...done."

echo "Installing latest Node-RED Version"
bash <(curl -sL https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/update-nodejs-and-nodered)
echo "...done."

echo "Installing latest SmartPi Release"

sudo apt install apt-transport-https
wget https://repro.enerserve.eu/packages/Release.key && apt-key add Release.key && rm Release.key
echo "deb https://repro.enerserve.eu/packages jessie main" > /etc/apt/sources.list.d/enerserve.list
apt-get update
apt-get install smartpi
echo "...done."

echo "Installing latest remot3.it package"
sudo apt-get install weavedconnectd
echo "...done."

echo "Installing x11vnc server"
sudo apt-get install x11vnc
echo "...done."
