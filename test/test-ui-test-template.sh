#!/bin/bash

CHROME_IMAGE="my-local-chrome"
FIREFOX_IMAGE="my-local-firefox"

# Check pre-reqs
if ! hash docker 2>/dev/null; then
  echo "'docker' was not found in PATH.  You will need docker installed to execute these tests.  https://docs.docker.com/install/ "
  exit 1
fi

if [ -f /usr/local/bin/geckodriver ]; then
  echo "geckodriver Found"
else
  echo "geckodriver NOT FOUND. Please install the geckodriver binary on your local machine."
  exit 1
fi

if [ -f /usr/local/bin/chromedriver ]; then
  echo "chromedriver Found"
else
  echo "chromedriver NOT FOUND. Please install the chromedriver binary on your local machine."
  exit 1
fi

start_mongo_container() {
  echo "starting Mongo container"
  docker run --rm -d --name mongo -p 27017:27017 mongo:3.6
}

start_browser_container() {
  if [ "$1" = $CHROME_IMAGE ]; then
    FOLDER="chrome_LATEST"
  elif [ "$1" = $FIREFOX_IMAGE ]; then
    FOLDER="firefox_LATEST"
  fi

  echo "Removing existing image $1 if present"
  docker image rm "$1"

  echo "Building new $1 image using the Dockerfile generated from the template"
  docker build docker/$FOLDER -q --tag "$1"

  echo "Running script to start $1 container"
  ./docker/run-browser-with-docker.sh $1

  if docker ps | grep "$1"; then
    echo "$1 container started"
  else
    echo "$1 cotainer failed to start"
    exit 1
  fi
}

start_zap() {

  case "$OSTYPE" in
  darwin*) ZAP_INSTALLATION_DIR="/Applications/OWASP ZAP.app/Contents/Java" ;;
  linux*) ZAP_INSTALLATION_DIR="~/.ZAP" ;;
  *)
    echo "unknown OS TYPE: $OSTYPE"
    exit 1
    ;;
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

# Test 1 - chrome driver, local, scalatest
g8 file://ui-test-template.g8/ --name=test-1
(
  cd test-1 || exit
  ./run_tests.sh
)
rm -rf test-1

# Test 2 - chrome docker, local, scalatest
g8 file://ui-test-template.g8/ --name=test-2
cd test-2 || exit
start_browser_container $CHROME_IMAGE
./run_tests.sh local remote-chrome
cd - || exit
rm -rf test-2
docker kill $CHROME_IMAGE

# Test 3 - chrome docker, local, cucumber
g8 file://ui-test-template.g8/ --name=test-3 --cucumber=true
cd test-3 || exit
start_browser_container $CHROME_IMAGE
./run_tests.sh local remote-chrome
cd - || exit
rm -rf test-3
docker kill $CHROME_IMAGE

# Test 4 - firefox docker, local, cucumber
g8 file://ui-test-template.g8/ --name=test-4 --cucumber=true
cd test-4 || exit
start_browser_container $FIREFOX_IMAGE
./run_tests.sh local remote-firefox
cd - || exit
rm -rf test-4
docker kill $FIREFOX_IMAGE

# Test 5 - firefox driver, local, cucumber
g8 file://ui-test-template.g8/ --name=test-5 --cucumber=true
(
  cd test-5 || exit
  ./run_tests.sh local firefox
)
rm -rf test-5

# Test 6 - zap, chrome driver, local, scalatest
start_zap
g8 file://ui-test-template.g8/ --name=test-6
(
  cd test-6 || exit
  ./run_zap_tests.sh local chrome
)
rm -rf test-6

# Test 7 - zap, firefox driver, local, cucumber
start_zap
g8 file://ui-test-template.g8/ --name=test-7 --cucumber=true
(
  cd test-7 || exit
  ./run_zap_tests.sh local firefox
)
rm -rf test-7

# TEAR DOWN
sm --stop UI_TEST_TEMPLATE
docker kill mongo
