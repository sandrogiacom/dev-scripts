#!/usr/bin/env bash
wget https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13%2B33/OpenJDK13U-jdk_x64_linux_hotspot_13_33.tar.gz
sudo tar xvf OpenJDK13U-jdk_x64_linux_hotspot_13_33.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-13+33/bin/java 2
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-13+33/bin/javac 2
sudo update-alternatives --config java
