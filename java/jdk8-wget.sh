#!/usr/bin/env bash
wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u282-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u282b08.tar.gz
sudo tar xvf OpenJDK8U-jdk_x64_linux_hotspot_8u282b08.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk8u282-b08/bin/java 2
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk8u282-b08/bin/javac 2
sudo update-alternatives --config java
