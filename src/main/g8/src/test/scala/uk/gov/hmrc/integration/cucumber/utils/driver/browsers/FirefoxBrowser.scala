package uk.gov.hmrc.integration.cucumber.utils.driver.browsers

import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.{FirefoxDriver, FirefoxOptions, FirefoxProfile}
import org.openqa.selenium.remote.DesiredCapabilities

object FirefoxBrowser {

  def initialise(javascriptEnabled: Boolean): WebDriver = {
    System.setProperty(FirefoxDriver.SystemProperty.DRIVER_USE_MARIONETTE, "true")
    System.setProperty(FirefoxDriver.SystemProperty.BROWSER_LOGFILE, "/dev/null")
    val profile = new FirefoxProfile()
    profile.setAcceptUntrustedCertificates(true)
    profile.setPreference("javascript.enabled", javascriptEnabled)

    val options = new FirefoxOptions()
    val capabilities = DesiredCapabilities.firefox()

    options.merge(capabilities)
    options.setProfile(profile)
    options.setAcceptInsecureCerts(true)

    new FirefoxDriver(options)
  }

}
