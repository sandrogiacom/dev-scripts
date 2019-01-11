wget https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
sudo tar xvf openjdk-11.0.1_linux-x64_bin.tar.gz --directory /usr/lib/jvm/
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11.0.1/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-11.0.1/bin/javac 1
sudo update-alternatives --config java
