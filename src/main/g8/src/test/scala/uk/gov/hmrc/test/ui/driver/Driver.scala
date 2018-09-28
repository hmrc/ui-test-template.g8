/*
 * Copyright 2018 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package uk.gov.hmrc.test.ui.driver

import java.net.URL

import com.typesafe.scalalogging.LazyLogging
import org.openqa.selenium.{MutableCapabilities, WebDriver}
import org.openqa.selenium.chrome.{ChromeDriver, ChromeOptions}
import org.openqa.selenium.firefox.{FirefoxDriver, FirefoxOptions, FirefoxProfile}
import org.openqa.selenium.remote.{CapabilityType, DesiredCapabilities, RemoteWebDriver}

object Driver extends LazyLogging with WindowControls with ProxySupport {

  private val defaultSeleniumHubUrl: String = s"http://localhost:4444/wd/hub"

  val instance: WebDriver = {
    sys.props.get("browser").map(_.toLowerCase) match {
      case Some("chrome") => chromeInstance(chromeOptions)
      case Some("chrome-headless") => chromeInstance(chromeOptions.addArguments("headless"))
      case Some("firefox") => firefoxInstance(firefoxOptions)
      case Some("remote-chrome") => remoteWebdriverInstance(chromeOptions)
      case Some("remote-firefox") => remoteWebdriverInstance(firefoxOptions)
      case Some(name) => sys.error(s"'browser' property '$name' not recognised.")
      case None => {
        logger.warn("'browser' property is not set, defaulting to 'chrome'")
        chromeInstance(chromeOptions)
      }
    }
  }

  private def chromeInstance(options: ChromeOptions): WebDriver = {
    new ChromeDriver(options)
  }

  private def firefoxInstance(options: FirefoxOptions): WebDriver = {
    System.setProperty(FirefoxDriver.SystemProperty.DRIVER_USE_MARIONETTE, "true")
    System.setProperty(FirefoxDriver.SystemProperty.BROWSER_LOGFILE, "/dev/null")
    new FirefoxDriver(options)
  }

  private def remoteWebdriverInstance(hubUrl: String, options: MutableCapabilities): WebDriver = {
    new RemoteWebDriver(new URL(hubUrl), options)
  }

  private def remoteWebdriverInstance(options: MutableCapabilities): WebDriver = {
    remoteWebdriverInstance(defaultSeleniumHubUrl, options)
  }

  private def chromeOptions: ChromeOptions = {
    val capabilities: DesiredCapabilities = DesiredCapabilities.chrome()
    if (Option(System.getProperty("qa.proxy")).isDefined) capabilities.setCapability(CapabilityType.PROXY, initialiseProxy())

    val options = new ChromeOptions()
    options.addArguments("test-type")
    options.addArguments("--no-sandbox")
    options.addArguments("start-maximized")
    options.addArguments("disable-infobars")
    options.setCapability("takesScreenshot", true)
    options.setCapability("javascript.enabled", javascriptEnabled)
    options.merge(capabilities)

    options
  }

  private def firefoxOptions: FirefoxOptions = {
    val profile = new FirefoxProfile()
    profile.setAcceptUntrustedCertificates(true)
    profile.setPreference("javascript.enabled", javascriptEnabled)

    val capabilities = DesiredCapabilities.firefox()
    val options = new FirefoxOptions()
    options.merge(capabilities)
    options.setProfile(profile)
    options.setAcceptInsecureCerts(true)

    options
  }

  private lazy val javascriptEnabled: Boolean = {
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

trait BrowserDriver {
  implicit lazy val driver: WebDriver = Driver.instance
}