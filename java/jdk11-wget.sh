#!/usr/bin/env bash
wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz
sudo tar xvf OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11.0.6+10/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-11.0.6+10/bin/javac 1
sudo update-alternatives --config java


