#login as root
sudo su
apt remove openjdk*
apt remove java*
add-apt-repository ppa:openjdk-r/ppa
apt-get update
apt install openjdk-11-jdk
echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment
source /etc/environment
echo $JAVA_HOME
