
# ui-test-template

This repository can be used by teams who are building a new service that will need browser driven tests.

It is built using:

* Java 1.8
* Scala 2.11.7
* sbt 0.13.16
* giter8 0.11.0-M3

By default, it supports the following browsers:

* Chrome
* Firefox

### Support
This repository is supported by the Test Community for any information on how to use it, or if you'd like any help please come to #community-testing in Slack.

### Contributions
If you'd like to contribute, please raise a PR and notify us in #community-testing - one of the core maintainers will take a look and merge the PR.

### Testing your contributions
To ensure your changes haven't broken the template, you can run the following commands locally before submitting your PR:

    sudo mongod
    sm --start ACCEPTANCE_TEST_TEMPLATE -f
    ./run_local.sh

### How to use this template

giter8 is required to generate a test suite from ui-test-template. Due to the limitations in SBT giter8 plugin, this template cannot be generated with SBT. 

giter8 can be installed from [here](http://www.foundweekends.org/giter8/setup.html).

To generate a test suite, execute the command `g8 hmrc/ui-test-template.g8`

This will then prompt for:

**name** -> The name of the test suite

**cucumber** -> An optional boolean property to determine if the test suite will use Cucumber or ScalaTest FeatureSpec. True would provide the required Cucumber dependencies and examples.
            False would provide the relevant ScalaTest FeatureSpec files. The default value for `cucumber` is set to false and hence will use ScalaTest FeatureSpec.

Answering these questions will result in a blank test suite with all the basic requirements needed for ui tests in your current directory.

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

###  Example Feature
The example test calls the Authority Wizard page and relies on the following services being started:

    ASSETS_FRONTEND
    AUTH
    AUTH_LOGIN_API
    AUTH_LOGIN_STUB
    USER_DETAILS
    PAYMENTS_FRONTEND

### Browser Testing
In order to run the tests via BrowserStack you will need to apply the BrowserStack scaffold to your new project using the following command:

```sbtshell
sbt 'g8Scaffold browserstack'
```

This will overlay the contents of the `.g8/browserstack` project folder into the project.  Once done, you will need to create a properties file (**./src/test/resources/browserConfig.properties**) containing your BrowserStack username and automate key (this is _not_ your password):

```properties
username=
automatekey=
```

To get your username and automate key go [here](https://www.browserstack.com/accounts/settings)

Alternatively if you access [www.browserstack.com/automate](http://www.browserstack.com/automate) and select **Username and Access Keys** on the left tab your credentials will be displayed

>**Note:** The settings page displays the automate key as the access key.

Then you need to change the project name and description within the BrowserStack.scala file.

You can use the search everywhere function within IntelliJ (Ctrl + Shift + F) to find these entries.
 - desCaps.setCapability("project", "Template")
 - desCaps.setCapability("build", "Template Build_1.0")

For our first run this was set to:
 - desCaps.setCapability("project", "projectName")
 - desCaps.setCapability("build", "Local Complete TestBuild_0.1")

To add a browser to be tested via BrowserStack, a JSON object needs to be created within the src/test/resources/browserstackdata folder with the following information:

    Desktop browser:
        - browser
        - browser_version
        - os
        - os_version

    Mobile Browser:
        - browserName
        - platform
        - device

> **Note:** ideally these should be representing the latest versions of the chosen browser and/or devices.

The title of the JSON file should be as follows:
BS_OS/Device_Version_Browser_BrowserVersion

For Example:

    BS_Win8_Chrome_v64

Once the JSON objects have been created, these need to be added to the run_browserstack.sh script.

To execute, first run the **run_browserstackbinary.sh** script from the root directory of the project and leave it running in a separate terminal window.

Now run the **run_browserstack.sh** script.

>**Note:** if you only wish to run either the browsers or devices you need to remove the relevant entry from within run_browserstack.sh

>**Note:** the changes made to browserConfig.properties should not be pushed to GitHub and therefore you should make sure that this file is included on the `.gitignore` file for your project.

