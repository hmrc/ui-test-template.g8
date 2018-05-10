package uk.gov.hmrc.integration.cucumber.utils.driver.browsers

import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.{ChromeDriver, ChromeOptions}
import org.openqa.selenium.remote.{CapabilityType, DesiredCapabilities}
import uk.gov.hmrc.integration.cucumber.utils.driver.ProxySupport

object ChromeBrowser extends ProxySupport {

  def initialise(javascriptEnabled: Boolean, headlessMode: Boolean): WebDriver = {
    val options = new ChromeOptions()
    options.addArguments("test-type")
    options.addArguments("--no-sandbox")
    options.addArguments("start-maximized")
    options.addArguments("disable-infobars")
    val capabilities: DesiredCapabilities = DesiredCapabilities.chrome()
    if (sys.props.get("qa.proxy").isDefined) {
      capabilities.setCapability(CapabilityType.PROXY, initialiseProxy())
    }
    options.setCapability("javascript.enabled", javascriptEnabled)
    options.merge(capabilities)
    if (headlessMode) {
      options.addArguments("headless")
    }
    new ChromeDriver(options)
  }

}
