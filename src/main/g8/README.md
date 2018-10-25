
# $name$

This repository can be used by teams who are building a new service that will need browser driven tests.

It is built using:

* Cucumber 1.2.4
* Java 1.8
* Scala 2.11.7
* sbt 0.13.16

By default, it supports the following browsers:

* Chrome
* Firefox
* BrowserStack

### Support
This repository is supported by the Test Community for any information on how to use it, or if you'd like any help please come to #community-testing in Slack.

### Contributions
If you'd like to contribute, please raise a PR and notify us in #community-testing - one of the core maintainers will take a look and merge the PR.

### Testing your contributions
To ensure your changes haven't broken the template, you can run the following commands locally before submitting your PR.  This will run the example specs/features with local chrome against local services :

    sudo mongod
    sm --start ACCEPTANCE_TEST_TEMPLATE -f
    ./run_tests.sh

### How to use this template

We _always_ keep UI driven tests to a minimum, preferring instead to drive tests down into Unit and Integration layers. Please read the MDTP Test Approach for more details.

Additionally, we want you to make smart choices that suit your project and team - if this template doesn't work for you please go ahead and implement your tests without using it! Or, come to #community-testing and we can chat about how you can best solve your issues.

To be able to execute tests with this template you will need Geckodriver and/or Chromedriver to run against a local installation of Chrome or Firefox. If you have a Mac, you can simply use homebrew to install these drivers:


    brew install geckodriver
    brew install chromedriver

If you don't have homebrew installed, follow the guidance on https://brew.sh/

For anyone using an Ubuntu device, we created helpful scripts to do the installation work for you. These can be found in the drivers/ directory of this template and can be executed on the command line. From the root directory of the project, simply execute on of the following scripts:


    drivers/installGeckodriver.sh
    drivers/installChromedriver.sh


These scripts use sudo to get the right permissions so you will likely be prompted to enter your password.

**Note** you will need up to date versions of Firefox and Chrome installed on your device to be able to use these drivers.

###  Project structure
Each part of the application's functionality is described by feature files. The feature files are arranged into folders inside src/test/features and grouped into the main areas of the application.

Each step of the feature files is defined by executable test steps in the scala code inside the src/test/scala/uk/gov/hmrc/test/ui/cucumber/stepdefs package and those utilise Page object models inside src/test/scala/uk/gov/hmrc/test/ui/pages which are the single place where page specific properties and variables are configured.

###  Example Feature
The example feature calls the Authority Wizard page and relies on the following services being started:

    ASSETS_FRONTEND
    AUTH
    AUTH_LOGIN_API
    AUTH_LOGIN_STUB
    USER_DETAILS
