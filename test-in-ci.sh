#!/bin/bash -e

clean_up () {
    echo "Removing Test Project"
}
trap clean_up EXIT

TEMPLATE_TYPE=$1
BROWSER_TYPE=$2

if [ "$TEMPLATE_TYPE" = "cucumber" ]; then
    TYPE=--cucumber=true
elif [ "$TEMPLATE_TYPE" = "scalatest" ]; then
    TYPE=--cucumber=false
else
    echo "$TEMPLATE_TYPE is not one of cucumber or scalatest. Exiting test"
    exit 1
fi

if [ -z $BROWSER_TYPE ]; then
    echo "BROWSER_TYPE is required. Should be one of chrome or firefox"
    exit 1
fi

echo "Setting $PWD as TEMPLATE_DIRECTORY"
TEMPLATE_DIRECTORY=$PWD

SANDBOX="$TEMPLATE_DIRECTORY/target/sandbox"
REPO_NAME="$TEMPLATE_TYPE-project"

initialize_repo() {
  #The template uses sbtAutoBuildPlugin which requires repository.yaml, licence.txt and an initial git local commit to compile
  cp $TEMPLATE_DIRECTORY/repository.yaml .
  cp $TEMPLATE_DIRECTORY/LICENSE .
  git init
  git add .
  git commit -m "initial commit"
}

mkdir -p $SANDBOX
cd $SANDBOX

echo "Creating $REPO_NAME"
g8 file:///$TEMPLATE_DIRECTORY --name="$REPO_NAME" $TYPE
cd "$SANDBOX"/"$REPO_NAME"
initialize_repo

echo "Test 1 :: Test with $BROWSER_TYPE"
./run_tests.sh local $BROWSER_TYPE

echo "Test 2 :: Test with ZAP"
./run_zap_tests.sh local $BROWSER_TYPE

echo "Clearing ZAP session for any subsequent test"
curl http://localhost:11000/JSON/core/action/newSession/?name=&overwrite=