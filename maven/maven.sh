echo ==============================
echo install maven - run as sudo
echo ==============================
cd /opt/ && wget http://ftp.unicamp.br/pub/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz && \
tar -xvzf apache-maven-3.5.4-bin.tar.gz && \
mv apache-maven-3.5.4 maven

echo ================================
echo Adicionado variável de ambiente
echo ================================
export M2_HOME=/opt/maven
echo "export M2_HOME=/opt/maven" > /etc/profile.d/mavenenv.sh && \
echo "export PATH="\$M2_HOME"/bin:\$PATH" >> /etc/profile.d/mavenenv.sh && \
chmod +x /etc/profile.d/mavenenv.sh && source /etc/profile.d/mavenenv.sh
