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

import com.typesafe.scalalogging.LazyLogging
import org.openqa.selenium.WebDriver
import uk.gov.hmrc.test.ui.driver.browsers._

object Driver extends LazyLogging with WindowControls {

  val instance: WebDriver = {
    sys.props.get("browser").map(_.toLowerCase) match {
      case Some("chrome") => ChromeBrowser.initialise(javascriptEnabled, sys.props.contains("headless"))
      case Some("chrome-headless") => ChromeBrowser.initialise(javascriptEnabled, headlessMode = true)
      case Some("firefox") => FirefoxBrowser.initialise(javascriptEnabled)
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

trait BrowserDriver {
  implicit lazy val driver: WebDriver = Driver.instance
}
