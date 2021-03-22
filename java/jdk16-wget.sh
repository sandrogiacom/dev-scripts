#!/usr/bin/env bash
wget https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16%2B36/OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz
sudo tar xvf OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-16+36/bin/java 5
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-16+36/bin/javac 5
sudo update-alternatives --config java
rm OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz
