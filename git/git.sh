#!/usr/bin/env bash
echo ==============================
echo install git
echo ==============================
sudo apt-get install -y git

echo ==============================
echo config git
echo ==============================
echo git name, example: Lord Voldemort
read gitName
git config --global user.name $gitName  && \
echo git email, example: lord.voldemort@fluig.com
read gitEmail
git config --global user.email $gitEmail  && \
git config --global core.precomposeunicode true  && \
git config --list

echo ==============================
echo git ssh key
echo ==============================
ssh-keygen -t rsa -C $gitEmail
