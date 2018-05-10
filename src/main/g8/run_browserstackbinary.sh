#!/bin/bash

if pidof BrowserStackLocal; then
  echo "BrowserStackLocal running already."
else
    echo "BrowserStackLocal not currently running."
	if [ -f ./BrowserStackLocal ];
	then
	   echo "BrowserStackLocal binary exists, using local copy."
	else
	    echo "Downloading BrowserStack binary"
	    platform="\$(tr [A-Z] [a-z] <<< `uname`)"
	   	wget "https://www.browserstack.com/browserstack-local/BrowserStackLocal-\$platform-x64.zip"
  	    unzip "BrowserStackLocal-\$platform-x64.zip"
  	    rm -r "BrowserStackLocal-\$platform-x64.zip"
	fi
  . ./src/test/resources/browserConfig.properties
  ./BrowserStackLocal \$automatekey
fi

echo "Finished"