#!/usr/bin/env bash
echo ==============================
echo install node 10.x
echo ==============================
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

sudo apt-get install -y nodejs

echo ==============================
echo install npm
echo ==============================
apt-get install -y npm
