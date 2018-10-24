**This is a template README.md.  Be sure to update this with project specific content that describes your ui test project.**

# $name$
The $name$ ui test project.  

## Running the tests

Prior to executing the tests ensure you have the appropriate [drivers installed](#install-driver-binary), install [MongoDB](https://docs.mongodb.com/manual/installation/) and install/configure [service manager](https://github.com/hmrc/service-manager).  

Run the following command to start services locally:

    sudo mongod
    sm --start UI_TEST_TEMPLATE

Then execute the `run_tests.sh` script:
    
    ./run_tests.sh <environment> <browser-driver>

The `run_tests.sh` script defaults to the `local` environment with the locally installed `chrome` driver binary.  For a complete list of supported param values, see:
 - `src/test/resources/application.conf` for **environment** 
 - `src/test/scala/uk/gov/hmrc/test/ui/driver/Driver.scala` for **browser-driver**


## [Installing local driver binaries](#install-driver-binaries)

This project supports UI test execution using Firefox (Geckodriver) and Chrome (Chromedriver) browsers. 

See the `drivers/` directory for some helpful scripts to do the installation work for you.  They should work on both Mac and Linux by running the following command:

    ./installGeckodriver.sh <operating-system> <driver-version>
    or
    ./installChromedriver <operating-system> <driver-version>

- *<operating-system>* defaults to **linux64**, however it also supports **macos**
- *<driver-version>* defaults to **0.19.1** for Gecko/Firefox, and the latest release for Chrome.  You can, however, however pass any version available at the [Geckodriver]() or [Chromedriver](http://chromedriver.storage.googleapis.com/) repositories.

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