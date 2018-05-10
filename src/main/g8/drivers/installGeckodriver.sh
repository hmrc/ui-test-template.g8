#!/usr/bin/env bash

#Depending on the OS of your device, change the value of OS appropriately
OS="linux64"
#OS="macos"

#These match the configuration on Jenkins - you should only have to adjust these values when the platform makes changes
GECKO_VERSION="0.19.1"
GECKO_PARENT_DIR="/usr/local/bin/"

GECKO_DOWNLOAD_URL="https://github.com/mozilla/geckodriver/releases/download/v\${GECKO_VERSION}/geckodriver-v\${GECKO_VERSION}-\${OS}.tar.gz"
GECKO_TEMP="/tmp/geckodriver-v\${GECKO_VERSION}-\${OS}.tar.gz"

wget -N \${GECKO_DOWNLOAD_URL} -P ~/
tar xvzf ~/geckodriver-v\${GECKO_VERSION}-\${OS}.tar.gz -C ~/
rm ~/geckodriver-v\${GECKO_VERSION}-\${OS}.tar.gz
sudo mv -f ~/geckodriver \${GECKO_PARENT_DIR}geckodriver
sudo chown root:root \${GECKO_PARENT_DIR}geckodriver
sudo chmod 755 \${GECKO_PARENT_DIR}geckodriver