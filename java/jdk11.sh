sudo apt install openjdk-11-jdk
echo "set JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin/java"
sudo update-alternatives --config java
sudo nano /etc/environment
source /etc/environment
echo $JAVA_HOME
