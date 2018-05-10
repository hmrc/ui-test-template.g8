#!/usr/bin/env bash

#Depending on the OS of your device, change the value of OS appropriately
OS="linux64"
#OS="mac64"

#These match the configuration on Jenkins - you should only have to adjust these values when the platform makes changes
CHROME_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
CHROME_PARENT_DIR="/usr/local/bin/"

CHROME_DOWNLOAD_URL="http://chromedriver.storage.googleapis.com/\$CHROME_VERSION/chromedriver_\${OS}.zip"
CHROME_TEMP="/tmp/chromedriver-v\${CHROME_VERSION}-\${OS}.tar.gz"

wget -N \${CHROME_DOWNLOAD_URL} -P ~/
unzip ~/chromedriver_\${OS}.zip -d ~/
rm ~/chromedriver_\${OS}.zip
sudo mv -f ~/chromedriver \${CHROME_PARENT_DIR}chromedriver
sudo chown root:root \${CHROME_PARENT_DIR}chromedriver
sudo chmod 755 \${CHROME_PARENT_DIR}chromedriver