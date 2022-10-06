#!/usr/bin/env bash
wget https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_x64_linux_hotspot_19_36.tar.gz
sudo tar xvf OpenJDK19U-jdk_x64_linux_hotspot_19_36.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-19+36/bin/java 6
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-19+36/bin/javac 6
sudo update-alternatives --config java
rm OpenJDK19U-jdk_x64_linux_hotspot_19_36.tar.gz
