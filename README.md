
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

And also supports execution of tests using BrowserStack.

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

## Available Scaffolds
### BrowserStack Scaffold
If you would like to include BrowserStack support in your project you will need to apply the BrowserStack scaffold.  To do this, run the following command from within the project you generated from the template (note that this **DOES** use the giter8 sbt plugin):

```sbtshell
sbt 'g8Scaffold browserstack'
```

This will overlay the contents of the `.g8/browserstack` project folder into your UI test project.  

You will then need to make the following changes to your project:

#### 1. Include "browserstack" in Driver.scala
You will need to the following change to the `src/test/scala/uk/gov/hmrc/test/ui/driver/Driver.scala` object to make use of `src/test/scala/uk/gov/hmrc/test/ui/driver/browsers/BrowserStack.scala`:

```scala
   ...
   case Some("remote-firefox") => remoteWebdriverInstance(firefoxOptions)
   case Some("browserstack") => BrowserStack.initialise()   //include this line
   case Some(name) => sys.error(s"'browser' property '$name' not recognised.")
   ...
```

#### 2. Create a properties file for BrowserStack authentication
Create the following properties file (**./src/test/resources/browserConfig.properties**) containing your BrowserStack username and automate key (this is _not_ your password):

```properties
username=
automatekey=
```

To get your username and automate key go [here](https://www.browserstack.com/accounts/settings)

Alternatively if you access [www.browserstack.com/automate](http://www.browserstack.com/automate) and select **Username and Access Keys** on the left tab your credentials will be displayed

>**Note:** The settings page displays the automate key as the access key.

#### 3. Update the BrowserStack.scala file with your project details
Then you need to change the projectName and buildName properties in `src/test/scala/uk/gov/hmrc/test/ui/driver/browsers/`.

#### 4. Include any other Browsers you'd like to test with in the src/test/resources/browserstackdata directory
If you'd like to add a browser for testing via BrowserStack, you'll have to create a JSON file within the `src/test/resources/browserstackdata` folder either of the two following structures:

**Desktop Browser**
```json
{
  "os": "<operating-system>",
  "os_version": "<>",
  "browser": "samsung",
  "browser_version": "",
  "device": "Samsung Galaxy S8"
}
```

**Mobile Browser**      
```json 
{
  "browser":"Chrome",
  "browser_version":"64.0",
  "os":"Windows",
  "os_version":"7"
}
```
**Note:** ideally these should be representing the latest versions of the chosen browser and/or devices.

The json filename must take the form (with **device-name** being optional) `BS_<OS>_<device-name>_<browser>_<browser-version>`.  For example, the following are all appropriately named files:

    BS_Win8_Chrome_v64.json
    BS_Android_GalaxyS8_v7.json
    BS_Win10_Edge_v16.json

Once the JSON objects have been created, these need to be added to the run_browserstack.sh script.

#### 5. Running a BrowserStack test from your local development environment
To run a test using BrowserStack, first execute the **run_browserstackbinary.sh** script (which will now be present in your project root) to download/start the browserstack binary. 

To run the tests, execute the **run_browserstack.sh** script.

>**Note 1:** if you only wish to run either the browsers or devices you need to remove the relevant entry from within run_browserstack.sh

>**Note 2:** the changes made to browserConfig.properties should not be pushed to GitHub and therefore you should make sure that this file is included on the `.gitignore` file for your project.

## Development
If you'd like to contribute to the ui-test-template you'll need to test your changes before raising a PR (see below).  

### Generating a UI Test project from you local changes
To create a test project from your local changes, execute the following command from the parent directory of your local copy of the template:

    g8 file://ui-test-template.g8/ --name=my-test-project --cucumber=true

This will create a new UI test project in a folder named `my-test-project/`.  
 
### Running the ui-test-template.g8 tests
There are test scripts (written in bash) in the `tests/` folder which run UI tests against serveral combinations of browser->test-runner->test-environment.  To successfully run the tests you will need to satisfy the following pre-requisites: 

- [Install Giterate CLI](#install-giterate)
- Install [Docker]()
- Build the latest HMRC Digital Chrome and Firefox images (see Confluence)
- Install chromedriver and geckodriver (reference the project [README.md](./src/main/g8/README.md) )
- Install and configure [Service Manager](https://github.com/hmrc/service-manager) (see Confluence)
- Install Mongo (see Confluence)
- Install ZAP (see [zaproxy](https://github.com/zaproxy/zaproxy/wiki/Downloads))

Copy `tests/ui-test-template-tests.sh` to the parent directory of your local copy of the ui-test-template.g8 project.  Execute the script without params:

    ./ui-test-template-tests.sh

**Note:** At present these tests create different types of projects off the template, and run the UI test off those projects.  No assertions are made to ensure that the test ran and passed, you will have to consult the logs to ensure that the tests ran successfully.
