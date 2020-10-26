**This is a template README.md.  Be sure to update this with project specific content that describes your ui test project.**

# $name$
UI test suite for the `<digital service name>` using WebDriver and `<scalatest/cucumber>`.  

## Running the tests

Prior to executing the tests ensure you have:
 - Docker - to run mongo and browser (Chrome or Firefox) inside a container 
 - Appropriate [drivers installed](#installing-local-driver-binaries) - to run tests against locally installed Browser
 - Installed/configured [service manager](https://github.com/hmrc/service-manager).  

When running these example tests locally, Chrome requires the additional `appendArgs` to be set otherwise the tests will fail. This is due to payments which is used in the examples having specific cross site settings in order for the Barclaycard iframe to work.

Run the following command to start services locally:

    docker run --rm -d --name mongo -d -p 27017:27017 mongo:3.6
    sm --start UI_TEST_TEMPLATE --appendArgs '{"PAY_FRONTEND":["-Dplay.http.session.sameSite=Lax"]}' -r

Then execute the `run_tests.sh` script:
    
    ./run_tests.sh <environment> <browser-driver>

The `run_tests.sh` script defaults to the `local` environment with the locally installed `chrome` driver binary.  For a complete list of supported param values, see:
 - `src/test/resources/application.conf` for **environment** 
 - [webdriver-factory](https://github.com/hmrc/webdriver-factory#2-instantiating-a-browser-with-default-options) for **browser-driver**
 
## Running tests against a containerised browser - on a developer machine

The script `./run-browser-with-docker.sh` can be used to start a Chrome or Firefox container on a developer machine. 
The script requires `remote-chrome` or `remote-firefox` as an argument.

Read more about the script's functionality [here](run-browser-with-docker.sh).

To run against a containerised Chrome browser:

```bash
./run-browser-with-docker.sh remote-chrome 
./run_tests.sh local remote-chrome
```

`./run-browser-with-docker.sh` is **NOT** required when running in a CI environment. 

#### Running the tests against a test environment

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
 
```
./run_zap_test.sh local chrome
```
    
To execute ZAP tests locally using a Chrome browser

```
./run-browser-with-docker.sh remote-chrome 
./run_zap_test.sh local remote-chrome
``` 

`./run-browser-with-docker.sh` is **NOT** required when running in a CI environment.
        
    
For more information about ZAP tests, please refer to the `zap-automation` [documentation](https://github.com/hmrc/zap-automation/blob/master/README.md).

### Running tests using BrowserStack
If you would like to run your tests via BrowserStack from your local development environment please refer to the [webdriver-factory](https://github.com/hmrc/webdriver-factory/blob/master/README.md/#user-content-running-tests-using-browser-stack) project.

## Installing local driver binaries

This project supports UI test execution using Firefox (Geckodriver) and Chrome (Chromedriver) browsers. 

See the `drivers/` directory for some helpful scripts to do the installation work for you.  They should work on both Mac and Linux by running the following command:

    ./installGeckodriver.sh <operating-system> <driver-version>
    or
    ./installChromedriver <operating-system> <driver-version>

- *<operating-system>* defaults to **linux64**, however it also supports **macos**
- *<driver-version>* defaults to **0.21.0** for Gecko/Firefox, and the latest release for Chrome.  You can, however, however pass any version available at the [Geckodriver](https://github.com/mozilla/geckodriver/tags) or [Chromedriver](http://chromedriver.storage.googleapis.com/) repositories.

**Note 1:** *You will need to ensure that you have a recent version of Chrome and/or Firefox installed for the later versions of the drivers to work reliably.*

**Note 2** *These scripts use sudo to set the right permissions on the drivers so you will likely be prompted to enter your password.*