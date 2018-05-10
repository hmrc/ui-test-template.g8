package uk.gov.hmrc.integration.cucumber.utils.driver

import com.typesafe.scalalogging.LazyLogging
import org.openqa.selenium.WebDriver
import uk.gov.hmrc.integration.cucumber.utils.driver.browsers._

object Driver extends LazyLogging with WindowControls {

  val instance: WebDriver = {
    sys.props.get("browser").map(_.toLowerCase) match {
      case Some("chrome") => ChromeBrowser.initialise(javascriptEnabled, sys.props.contains("headless"))
      case Some("chrome-headless") => ChromeBrowser.initialise(javascriptEnabled, headlessMode = true)
      case Some("firefox") => FirefoxBrowser.initialise(javascriptEnabled)
      case Some("browserstack") => BrowserStack.initialise()
      case Some(name) => sys.error(s"'browser' property '\$name' not recognised.")
      case None => {
        logger.warn("'browser' property is not set, defaulting to 'chrome'")
        ChromeBrowser.initialise(javascriptEnabled, headlessMode = false)
      }
    }
  }

  lazy val javascriptEnabled: Boolean = {
    sys.props.get("javascript").map(_.toLowerCase) match {
      case Some("true") => true
      case Some("false") => false
      case Some(_) => sys.error("'javascript' property must be 'true' or 'false'.")
      case None => {
        logger.warn("'javascript' property not set, defaulting to true.")
        true
      }
    }
  }
}
