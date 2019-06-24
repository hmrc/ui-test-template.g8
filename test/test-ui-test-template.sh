#!/bin/bash

# Check pre-reqs
if ! hash docker 2>/dev/null
then
    echo "'docker' was not found in PATH.  You will need docker installed to execute these tests.  https://docs.docker.com/install/ "
    exit 1
fi

[ -f /usr/local/bin/geckodriver ] && echo "geckodriver Found" || ( echo "geckodriver NOT FOUND. Please install the geckodriver binary on your local machine." ; exit 1 )
[ -f /usr/local/bin/chromedriver ] && echo "chromedriver Found" || ( echo "chromedriver NOT FOUND. Please install the chromedriver binary on your local machine." ; exit 1 )

start_mongo_container () {
    docker run --rm -d --name mongo -p 27017:27017 mongo:3.2.20
}

start_browser_container () {
    SM_OUTPUT=$(sm -s | egrep 'PASS|BOOT' | awk '{ print $12 }')
    if [ "x$SM_OUTPUT" = "x" ]; then
        echo "NO PORTS WITH STATUS PASS OR BOOT. EXITING SCRIPT"
        exit 1
    fi
    
    export MAPPED_PORTS=
    for PORT in $SM_OUTPUT; do
        MAPPED_PORTS="$MAPPED_PORTS$PORT->$PORT,"
    done
    MAPPED_PORTS=${MAPPED_PORTS%?}
    echo MAPPED_PORTS: $MAPPED_PORTS

    docker run --rm -d --name $1 -p 4444:4444 -p 5900:5900 -e SE_OPTS="-debug" -e PORT_MAPPINGS=$MAPPED_PORTS -e TARGET_IP='host.docker.internal' $1
}

start_zap () {

case "$OSTYPE" in
  darwin*) ZAP_INSTALLATION_DIR="/Applications/OWASP ZAP.app/Contents/Java" ;;
  linux*)  ZAP_INSTALLATION_DIR="~/.ZAP" ;;
  *)        echo "unknown OS TYPE: $OSTYPE"
            exit 1;;
esac

if [[ ! -d "$ZAP_INSTALLATION_DIR" ]]; then
  echo "ZAP Directory Not found. Check if ZAP is installed in $ZAP_INSTALLATION_DIR"
  exit 1
fi

echo "Starting ZAP from $ZAP_INSTALLATION_DIR"

"$ZAP_INSTALLATION_DIR/zap.sh" &>/dev/null &
   ZAP_PID=$!

   sleep 5

}
# SETUP
## Services
start_mongo_container
sm --start UI_TEST_TEMPLATE -f 
## Browsers
start_browser_container "chrome-3.14.0"

# Test 1 - chrome driver, local, scalatest
g8 file://ui-test-template.g8/ --name=test-1
( cd test-1 ; ./run_tests.sh )
rm -rf test-1

# Test 2 - chrome docker, local, scalatest
g8 file://ui-test-template.g8/ --name=test-2
( cd test-2 ; ./run_tests.sh local remote-chrome )
rm -rf test-2

# Test 3 - chrome docker, local, cucumber
g8 file://ui-test-template.g8/ --name=test-3 --cucumber=true
( cd test-3 ; ./run_tests.sh local remote-chrome )
rm -rf test-3

# Test 4 - firefox docker, local, cucumber
docker kill chrome-3.14.0
start_browser_container firefox-3.14.0
g8 file://ui-test-template.g8/ --name=test-4 --cucumber=true
( cd test-4 ; ./run_tests.sh local remote-firefox )
rm -rf test-4
docker kill firefox-3.14.0
start_browser_container chrome-3.14.0

# Test 5 - firefox driver, local, cucumber
g8 file://ui-test-template.g8/ --name=test-5 --cucumber=true
( cd test-5 ; ./run_tests.sh local firefox )
rm -rf test-5

# Test 6 - zap, chrome driver, local, scalatest
start_zap
g8 file://ui-test-template.g8/ --name=test-6
( cd test-6 ; ./run_zap_tests.sh local chrome )
rm -rf test-6

# Test 7 - zap, firefox driver, local, cucumber
start_zap
g8 file://ui-test-template.g8/ --name=test-7 --cucumber=true
( cd test-7 ; ./run_zap_tests.sh local firefox )
rm -rf test-7

# TEAR DOWN
docker kill chrome-3.14.0
sm --stop UI_TEST_TEMPLATE
docker kill mongo
kill -9 ${ZAP_PID}

