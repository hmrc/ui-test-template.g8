#!/bin/bash -e

# The script tests the ui-test-template.g8 in CI environment
#
# Prerequisite:
# The script expects the following to be running already:
# - Mongo
# - Service Manager profile for the ui-test-template.g8. See the README for the SM profile details
# - A browser instance: Can be one of Chrome, Firefox, remote-chrome, remote-firefox
# - ZAP
# - Giter8
#
# What does the script do?
# - Creates a sandbox folder under target
# - Generates a template from ui-test-template.g8 for the provided TEMPLATE_TYPE.
# - Runs the journey tests against locally running services for the provided BROWSER_TYPE
# - Runs the ZAP tests against locally running services for the provided BROWSER_TYPE
#
# When does the test fail in CI?
# When running in CI, Jenkins relies on the exit code from this script to mark the build as failed.
# - When the template is not created successfully
# - When Journey test or ZAP tests returns a failure
#
# How to run the tests locally?
# From the project root folder run the script as
# - ./test-in-ci.sh scalatest chrome  (or)
# - ./test-in-ci.sh cucumber firefox
#
# How to run the tests in CI?
# From the project root folder run the script as
# - ./test-in-ci.sh scalatest remote-chrome  (or)
# - ./test-in-ci.sh cucumber remote-firefox

TEMPLATE_TYPE=$1
BROWSER_TYPE=$2

print() {
  echo
  echo -----------------------------------------------------------------------------------------------------------------
  echo $1
  echo -----------------------------------------------------------------------------------------------------------------
  echo
}

print "INFO: Testing ui-test-template.g8 with TEMPLATE_TYPE: $TEMPLATE_TYPE and BROWSER_TYPE: $BROWSER_TYPE"

if [ "$TEMPLATE_TYPE" = "cucumber" ]; then
    TYPE=--cucumber=true
elif [ "$TEMPLATE_TYPE" = "scalatest" ]; then
    TYPE=--cucumber=false
else
    print "ERROR: TEMPLATE_TYPE is not one of cucumber or scalatest. Exiting test"
    exit 1
fi

if [ -z $BROWSER_TYPE ]; then
    print "ERROR: BROWSER_TYPE is required. Should be one of chrome, remote-chrome, firefox, remote-firefox"
    exit 1
fi

#Creates a sandbox folder to generate test repository
setup_sandbox() {
print "INFO: Setting TEMPLATE_DIRECTORY as $PWD"
TEMPLATE_DIRECTORY=$PWD
SANDBOX="$TEMPLATE_DIRECTORY/target/sandbox"
REPO_NAME="$TEMPLATE_TYPE-ui-test"

print "INFO: Creating folder: $SANDBOX"
mkdir -p $SANDBOX
cd $SANDBOX
}


generate_repo_from_template() {
  print "INFO: Using ui-test-template.g8 to generate new test repository: $REPO_NAME."
  g8 file:///$TEMPLATE_DIRECTORY --name="$REPO_NAME" $TYPE
}

#The template uses sbtAutoBuildPlugin which requires repository.yaml, licence.txt and an initial git local commit to compile
initialize_repo() {
  print "INFO: Initializing repository for sbtAutoBuildPlugin with repository.yaml, licence.txt and an initial git commit"
  cd "$SANDBOX"/"$REPO_NAME"
  cp $TEMPLATE_DIRECTORY/repository.yaml .
  cp $TEMPLATE_DIRECTORY/LICENSE .
  git init
  git add .
  git commit -m "initial commit"
}

run_test() {
print "INFO: Changing Directory to "$SANDBOX"/"$REPO_NAME""
cd "$SANDBOX"/"$REPO_NAME"

print "INFO: Test 1 :: STARTING: $REPO_NAME $BROWSER_TYPE Journey tests"
./run_tests.sh local $BROWSER_TYPE
print "INFO: Test 1 :: COMPLETED: $REPO_NAME $BROWSER_TYPE Journey tests"

print "INFO: Test 2 :: STARTING: $REPO_NAME ZAP test"
./run_zap_tests.sh local $BROWSER_TYPE
print "INFO: Test 2 :: COMPLETED: $REPO_NAME ZAP test"

print "INFO: Clearing ZAP session for any subsequent test"
curl http://localhost:11000/JSON/core/action/newSession/?name=&overwrite=
print "INFO: $REPO_NAME test completed"
}

setup_sandbox
generate_repo_from_template
initialize_repo
run_test