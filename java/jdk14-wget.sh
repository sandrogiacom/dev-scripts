#!/usr/bin/env bash
wget https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36/OpenJDK14U-jdk_x64_linux_hotspot_14_36.tar.gz
sudo tar xvf OpenJDK14U-jdk_x64_linux_hotspot_14_36.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-14+36/bin/java 3
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-14+36/bin/javac 3
sudo update-alternatives --config java
