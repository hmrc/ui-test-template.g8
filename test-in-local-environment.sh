#!/bin/bash -e

print() {
  echo
  echo -----------------------------------------------------------------------------------------------------------------
  echo $1
  echo -----------------------------------------------------------------------------------------------------------------
  echo
}

print "INFO: Running 'sbt clean' command to clean target folder"
sbt clean

print "INFO: Setting TEMPLATE_DIRECTORY as $PWD"
TEMPLATE_DIRECTORY=$PWD

print "INFO: Setting SANDBOX directory as $PWD/target/sandbox"
SANDBOX="$TEMPLATE_DIRECTORY/target/sandbox"
REPO_NAME="$TEMPLATE_TYPE-ui-test"

print "INFO: Creating folder: $SANDBOX"
mkdir -p $SANDBOX

check_prerequisites() {
  if ! hash docker 2>/dev/null; then
    print "ERROR: 'docker' was not found in PATH.  You will need docker installed to execute these tests.  https://docs.docker.com/install/ "
    exit 1
  fi

  if [ -f /usr/local/bin/geckodriver ]; then
    print "INFO: geckodriver Found"
  else
    print "ERROR: geckodriver NOT FOUND. Please install the geckodriver binary on your local machine."
    exit 1
  fi

  if [ -f /usr/local/bin/chromedriver ]; then
    print "INFO: chromedriver Found"
  else
    print "ERROR: chromedriver NOT FOUND. Please install the chromedriver binary on your local machine."
    exit 1
  fi
}

setup_local_environment() {
  print "INFO: Starting Mongo container"

  if docker ps | grep "mongo"; then
    print "INFO: Mongo container is already running"
  else
    docker run --rm -d --name mongo -p 27017:27017 mongo:3.6
    print "INFO: Mongo container started"
  fi

  print "INFO: Starting SM profile"
  sm --start UI_TEST_TEMPLATE --appendArgs '{"PAY_FRONTEND":["-Dplay.http.session.sameSite=Lax"]}' -r --wait 100
}

generate_test_repo() {
  print "Changing to $SANDBOX directory to generate new repository"
  cd $SANDBOX
  print "INFO: Using ui-test-template.g8 to generate new test repository with values: $1 $2"
  g8 file:///$TEMPLATE_DIRECTORY $1 $2
}

initialize_repo() {
  #The repo uses sbtAutoBuildPlugin which requires repository.yaml, licence.txt and an initial git local commit to compile
  cp $WORKSPACE/ui-test-template.g8/repository.yaml .
  cp $WORKSPACE/ui-test-template.g8/LICENSE .
  git init
  git add .
  git commit -m "initial commit"
}

start_browser_container() {
  print "INFO: Running script to start $1 container"
  ./run-browser-with-docker.sh "$1"

  if docker ps | grep "$1"; then
    print "INFO: $1 container started"
  else
    print "INFO: $1 container failed to start"
    exit 1
  fi
}

start_zap() {

  case "$OSTYPE" in
  darwin*) ZAP_INSTALLATION_DIR="/Applications/OWASP ZAP.app/Contents/Java" ;;
  linux*) ZAP_INSTALLATION_DIR="~/.ZAP" ;;
  *)
    print "ERROR: Unknown OS TYPE: $OSTYPE"
    exit 1
    ;;
  esac

  if [[ ! -d "$ZAP_INSTALLATION_DIR" ]]; then
    print "ERROR: ZAP Directory Not found. Check if ZAP is installed in $ZAP_INSTALLATION_DIR"
    exit 1
  fi

  print "INFO: Starting ZAP from $ZAP_INSTALLATION_DIR"
  "$ZAP_INSTALLATION_DIR/zap.sh" &>/dev/null &
  ZAP_PID=$!

  sleep 5
}

clear_zap_session() {
  print "INFO: Clearing ZAP session for any subsequent test"
  curl "http://localhost:11000/JSON/core/action/newSession/?name=&overwrite="
}

run_scalatest_tests() {
  generate_test_repo --name=scalatest-repo
  print "INFO: Test 1 - chrome driver, local, scalatest"
  cd "$SANDBOX/scalatest-repo"
  initialize_repo
  ./run_tests.sh

  print "INFO: Test 2 - chrome docker, local, scalatest"
  start_browser_container remote-chrome
  ./run_tests.sh local remote-chrome
  docker stop remote-chrome

  print "INFO: Test 3 - zap, chrome driver, local, scalatest"
  start_zap
  ./run_zap_tests.sh local chrome
  clear_zap_session
}

run_cucumber_tests() {
  generate_test_repo --name=cucumber-repo

  print "INFO: Test 4 - chrome docker, local, cucumber"
  cd "$SANDBOX/cucumber-repo"
  initialize_repo
  start_browser_container remote-chrome
  ./run_tests.sh local remote-chrome
  docker stop remote-chrome

  print "INFO: Test 5 - firefox docker, local, cucumber"
  start_browser_container remote-firefox
  ./run_tests.sh local remote-firefox
  docker stop remote-firefox

  print "INFO: Test 6 - firefox driver, local, cucumber"
  ./run_tests.sh local firefox

  print "INFO: Test 7 - zap, firefox driver, local, cucumber"
  ./run_zap_tests.sh local firefox
  clear_zap_session
}

tear_down() {
  print "INFO: Stopping SM profile"
  sm --stop UI_TEST_TEMPLATE
  print "INFO: Stopping Mongo container"
  docker stop mongo
  print "INFO: Shutdown ZAP"
  curl http://localhost:11000/JSON/core/action/shutdown/?
}

check_prerequisites
setup_local_environment
run_scalatest_tests
run_cucumber_tests
tear_down