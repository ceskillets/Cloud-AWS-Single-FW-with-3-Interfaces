#!/bin/bash -ex
cd /var/tmp 
sudo apt-get update
sudo apt-get update
sudo echo '#!/bin/bash -ex' > initialize_webserver.sh
sudo echo 'until resp=$(curl -s -S -g --max-time 3 --insecure "https://10.0.2.10/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=<api key>");do' >> initialize_webserver.sh
sudo echo 'if [[ $resp == *"[CDATA[yes"* ]] ; then' >> initialize_webserver.sh
sudo echo '    break' >> initialize_webserver.sh
sudo echo '  fi' >> initialize_webserver.sh
sudo echo '  sleep 10s' >> initialize_webserver.sh
sudo echo 'done' >> initialize_webserver.sh
sudo echo 'sudo apt-get update &&' >> initialize_webserver.sh
sudo echo 'sudo apt-get install -y apache2 php7.0 &&' >> initialize_webserver.sh
sudo echo 'sudo apt-get install -y libapache2-mod-php7. &&' >> initialize_webserver.sh
sudo echo 'sudo rm -f /var/www/html/index.html &&' >> initialize_webserver.sh
sudo echo 'sudo wget -O /var/www/html/index.php https://raw.githubusercontent.com/wwce/Scripts/master/showheaders.php &&' >> initialize_webserver.sh
sudo echo 'sudo service apache2 restart &&' >> initialize_webserver.sh
sudo echo 'sudo echo "done"' >> initialize_webserver.sh
sudo chmod 755 initialize_webserver.sh
sudo /bin/bash ./initialize_webserver.sh