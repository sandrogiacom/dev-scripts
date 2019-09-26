#!/usr/bin/env bash
wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz
sudo tar xvf OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk8u222-b10/bin/java 2
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk8u222-b10/bin/javac 2
sudo update-alternatives --config java
