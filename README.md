
# ui-test-template

This repository can be used by teams who are in need of a UI test suite that verifies interactions between multiple frontend services.  If your tests' scope is limited to a single frontend service this **might** not be the template for you.  While it will still serve as a good reference, you may want to consider writting your UI tests in the same git repository as the service under test.  

The ui-test-template.g8 is developed and tested using:
* Java 1.8
* Scala 2.11.7
* sbt 0.13.16
* giter8 0.11.0-M3

It supports UI testing with the following **browsers** (local driver binary and selenium-docker container):
* Chrome
* Firefox

Using the following **test execution frameworks**:
* Scalatest
* Cucumber

## Support
This repository is supported by HMRC Digital's Test Community.  If you have a query or find an issue please drop in to the #community-testing channel in Slack.

## Contributions
If you'd like to contribute we welcome you to raise a PR or issue against the project and notify one of the core maintainers in #community-testing.

## Generating a UI Test project
You **DO NOT** need to clone this project to generate a UI Test project from the template.  You simply need to have giter8 installed, and run the `g8` command below.

### [Install giter8 CLI](#install-giterate) 
You will need to have giter8 installed in order to generate a test suite from ui-test-template. Due to some limitations with the SBT giter8 plugin, unfortunately this template will not generate successfully. 

Instructions to install giter8 can be found [here](http://www.foundweekends.org/giter8/setup.html).

### Generating a UI Test project from master
To generate a test suite, execute the following command in the parent directory of where you'd like your UI Test project created:
    
    g8 hmrc/ui-test-template.g8

This will prompt you for:
- **name** -> The name of the ui test repository.  I.e. my-digital-service-ui-tests
- **cucumber** -> [OPTIONAL] A Boolean property which defaults to `false`.  By default, the project will be created with an example Scalatest Spec.  Selecting `true` will provide you with all the required dependencies to run Cucumber, an example test Feature, example StepDef and TestRunner objects. 

To execute the example test, follow the steps in the project README.md

### A Note on the Example Spec/Feature
The example test created by this template is quite limited in what it does.  It calls the Authority Wizard page to authenticate with and redirect to the PAYMENTS_FRONTEND, then completes a simple VAT Registraion journey.  This depends on the services in the `UI_TEST_TEMPLATE` being available:

    ASSETS_FRONTEND
    AUTH
    AUTH_LOGIN_API
    AUTH_LOGIN_STUB
    USER_DETAILS
    PAY_FRONTEND
    PAY_API
    IDENTITY_VERIFICATION 

## Development
If you'd like to contribute to the ui-test-template you'll need to test your changes before raising a PR (see below).  

### Generating a UI test project from your local changes
To create a test project from your local changes, execute the following command from the parent directory of your local copy of the template:

    g8 file://ui-test-template.g8/ --name=my-test-project --cucumber=true

This will create a new UI test project in a folder named `my-test-project/`.  
 
### Testing the template
The repository provides two scripts to test the template:
- [test-in-local-environment.sh](test-in-local-environment.sh) - To test the changes locally
- [test-in-ci.sh](test-in-ci.sh) - A small set of tests to run in CI environment

#### Testing Locally 
The bash script [test-ui-test-template-locally.sh](test-in-local-environment.sh) is intended to run locally in an engineer's machine.
 The script is not suitable to run in a CI environment. The script generates a new repository from this template and runs
  the UI Journeys and ZAP tests available in the test repository for different browsers and test-runner configuration. 
 
To successfully run the tests you will need to satisfy the following pre-requisites: 

- [Install Giterate CLI](#install-giterate)
- Install [Docker]()
- Install chromedriver and geckodriver (reference the project [README.md](./src/main/g8/README.md) )
- Install and configure [Service Manager](https://github.com/hmrc/service-manager) (see Confluence)
- Install Mongo (see Confluence)
- Install ZAP (see Confluence)

Copy `test-in-local-environment.sh` to the parent directory of your local copy of the ui-test-template.g8 project. 
 Execute the script without params:

```
./test-in-local-environment.sh
```

**Note:** At present these tests create different types of projects off the template, and run the UI test off those projects. 
 No assertions are made to ensure that the test ran and passed, you will have to consult the logs to ensure that the tests 
 ran successfully.
 
#### Testing in CI
The bash script [test-in-ci.sh](test-in-ci.sh) is used to test the ui-test-template.g8 template
 in a pipeline via a PR builder before merging changes to master. The script generates a new repository for the
  provided template type, and runs UI Journeys and ZAP tests against locally running services for the provided browser type.
  
```
./test-in-ci.sh cucumber remote-chrome
```

While this script can be also used to run locally in an engineer's machine it does not provide the necessary set up by default.
Use [test-ui-test-template-locally.sh](test-in-local-environment.sh) instead.  

### Scalafmt
The generated template has already been formatted using `scalafmt` as well as containing a `.scalafmt.conf` configuration and sbt `scalafmt` plugin ready for teams to use. 

Currently, formatting the files to include in a generated project is a manual task. This involves generating a new template from this project, formatting the generated files and then updating this repository to reflect the new formatting.