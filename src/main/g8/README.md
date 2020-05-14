**This is a template README.md.  Be sure to update this with project specific content that describes your ui test project.**

# $name$
UI test suite for the `<digital service name>` using WebDriver and `<scalatest/cucumber>`.  

## Running the tests

Prior to executing the tests ensure you have the appropriate [drivers installed](#install-driver-binary), install [MongoDB](https://docs.mongodb.com/manual/installation/) and install/configure [service manager](https://github.com/hmrc/service-manager).  

Run the following command to start services locally:

    sudo mongod
    sm --start UI_TEST_TEMPLATE -f

Then execute the `run_tests.sh` script:
    
    ./run_tests.sh <environment> <browser-driver>

The `run_tests.sh` script defaults to the `local` environment with the locally installed `chrome` driver binary.  For a complete list of supported param values, see:
 - `src/test/resources/application.conf` for **environment** 
 - [webdriver-factory](https://github.com/hmrc/webdriver-factory#2-instantiating-a-browser-with-default-options) for **browser-driver**
 
#### Running the tests against an environment

To run the tests against an environment set the corresponding `host` environment property as specified under
 `<env>.host.services` in the [application.conf](/src/test/resources/application.conf). 
 
For example, to execute the `run_tests.sh` script against QA  environment using Chrome remote-webdriver
     
    ./run_tests.sh qa remote-chrome

## Running ZAP tests

ZAP tests can be automated using the HMRC [zap-automation](https://github.com/hmrc/zap-automation) library. It is not mandatory to do so and should not be considered a substitute for manual exploratory testing using OWASP ZAP.

#### Tagging tests for ZAP

It is not required to proxy every journey test via ZAP. The intention of proxying a test through ZAP is to expose all the
 relevant pages of an application to ZAP. So tagging a subset of the journey tests or creating a 
 single ZAP focused journey test is sufficient.
 
#### Configuring the browser to proxy via ZAP 

Setting the system property `zap.proxy=true` configures the browser specified in `browser` property to proxy via ZAP. 
This is achieved using [webdriver-factory](https://github.com/hmrc/webdriver-factory#proxying-trafic-via-zap).  

#### zap-automation config
Running ZAP tests require passing a zap-automation config object to the zap-automation library. `zap-automation` config is 
defined in the [application.conf](/src/test/resources/application.conf). The config is passed to the `zap-automation`
library via [ZapSpec](/src/test/scala/uk/gov/hmrc/test/ui/ZapSpec.scala) from which the ZAP tests are triggered.

#### Executing a ZAP test

The shell script `run_zap_tests.sh` is available to execute ZAP tests. The script first proxies a set of journey tests, 
tagged as `ZapTests`, via ZAP. Upon completion, the script then triggers a ZAP scan for the provided `zap-automation` config. 

For example, to execute ZAP tests locally using a Chrome browser
 
    ./run_zap_test.sh local chrome
    
For more information about ZAP tests, please refer to the `zap-automation` [documentation](https://github.com/hmrc/zap-automation/blob/master/README.md).


## [Installing local driver binaries](#install-driver-binaries)

This project supports UI test execution using Firefox (Geckodriver) and Chrome (Chromedriver) browsers. 

See the `drivers/` directory for some helpful scripts to do the installation work for you.  They should work on both Mac and Linux by running the following command:

    ./installGeckodriver.sh <operating-system> <driver-version>
    or
    ./installChromedriver <operating-system> <driver-version>

- *<operating-system>* defaults to **linux64**, however it also supports **macos**
- *<driver-version>* defaults to **0.21.0** for Gecko/Firefox, and the latest release for Chrome.  You can, however, however pass any version available at the [Geckodriver](https://github.com/mozilla/geckodriver/tags) or [Chromedriver](http://chromedriver.storage.googleapis.com/) repositories.

**Note 1:** *You will need to ensure that you have a recent version of Chrome and/or Firefox installed for the later versions of the drivers to work reliably.*

**Note 2** *These scripts use sudo to set the right permissions on the drivers so you will likely be prompted to enter your password.*

## Applying Scaffolds
This repo comes with scaffolds that are located in the project's `scaffolds/` directory.  

At present only BrowserStack support is provided via g8 scaffolds.  This can be applied to the repo by running the following command from the project root directory:

```sbtshell
sbt 'g8Scaffold browserstack'
```

Feel free to delete the `scaffolds/` directory if you have no need for BrowserStack.

More information on the supported Scaffolds can be found in the [ui-test-template.g8 github README.md](https://github.com/hmrc/ui-test-template.g8/blob/master/README.md).