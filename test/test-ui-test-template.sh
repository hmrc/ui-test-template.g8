#!/bin/bash

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
  if docker ps | grep "mongo"; then
    echo "Mongo container is already running"
  else
    docker run --rm -d --name mongo -p 27017:27017 mongo:3.6
    echo "Mongo container started"
  fi

}

start_browser_container() {
  echo "Running script to start $1 container"
  ./run-browser-with-docker.sh "$1"

  if docker ps | grep "$1"; then
    echo "$1 container started"
  else
    echo "$1 container failed to start"
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

initialize_repo() {
  #The repo uses sbtAutoBuildPlugin which requires repository.yaml, licence.txt and an initial git local commit to compile
  cp $WORKSPACE/ui-test-template.g8/repository.yaml .
  cp $WORKSPACE/ui-test-template.g8/LICENSE .
  git init
  git add .
  git commit -m "initial commit"
}

# SETUP
## Services
start_mongo_container
sm --start UI_TEST_TEMPLATE --appendArgs '{"PAY_FRONTEND":["-Dplay.http.session.sameSite=Lax"]}' -f

# Test 1 - chrome driver, local, scalatest
g8 file://ui-test-template.g8/ --name=test-1
(
  cd test-1 || exit
  initialize_repo
  ./run_tests.sh
)
rm -rf test-1

# Test 2 - chrome docker, local, scalatest
g8 file://ui-test-template.g8/ --name=test-2
cd test-2 || exit
initialize_repo
start_browser_container remote-chrome
./run_tests.sh local remote-chrome
cd - || exit
rm -rf test-2
docker stop remote-chrome

# Test 3 - chrome docker, local, cucumber
g8 file://ui-test-template.g8/ --name=test-3 --cucumber=true
cd test-3 || exit
initialize_repo
start_browser_container remote-chrome
./run_tests.sh local remote-chrome
cd - || exit
rm -rf test-3
docker stop remote-chrome

# Test 4 - firefox docker, local, cucumber
g8 file://ui-test-template.g8/ --name=test-4 --cucumber=true
cd test-4 || exit
initialize_repo
start_browser_container remote-firefox
./run_tests.sh local remote-firefox
cd - || exit
rm -rf test-4
docker stop remote-firefox

# Test 5 - firefox driver, local, cucumber
g8 file://ui-test-template.g8/ --name=test-5 --cucumber=true
(
  cd test-5 || exit
  initialize_repo
  ./run_tests.sh local firefox
)
rm -rf test-5

# Test 6 - zap, chrome driver, local, scalatest
start_zap
g8 file://ui-test-template.g8/ --name=test-6
(
  cd test-6 || exit
  initialize_repo
  ./run_zap_tests.sh local chrome
)
rm -rf test-6

# Test 7 - zap, firefox driver, local, cucumber
start_zap
g8 file://ui-test-template.g8/ --name=test-7 --cucumber=true
(
  cd test-7 || exit
  initialize_repo
  ./run_zap_tests.sh local firefox
)
rm -rf test-7

# TEAR DOWN
sm --stop UI_TEST_TEMPLATE
docker stop mongo