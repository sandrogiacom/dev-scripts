#login as root
apt remove openjdk*
apt remove java*
apt install openjdk-11-jdk
echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/environment
source /etc/environment
echo $JAVA_HOME
