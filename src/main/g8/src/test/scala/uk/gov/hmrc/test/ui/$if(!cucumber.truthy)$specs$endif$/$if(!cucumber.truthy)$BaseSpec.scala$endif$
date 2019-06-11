package uk.gov.hmrc.test.ui.spec

import org.scalatest.concurrent.Eventually
import org.scalatestplus.selenium.WebBrowser
import org.scalatest.{BeforeAndAfterAll, FeatureSpec, GivenWhenThen, Matchers}
import uk.gov.hmrc.test.ui.driver.BrowserDriver
import uk.gov.hmrc.webdriver.SingletonDriver

import scala.util.Try

trait BaseSpec extends FeatureSpec
  with GivenWhenThen
  with BeforeAndAfterAll
  with Matchers
  with WebBrowser
  with BrowserDriver
  with Eventually{

  override def afterAll() {
    Try(SingletonDriver.closeInstance)
  }
}
