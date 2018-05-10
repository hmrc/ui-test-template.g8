package uk.gov.hmrc.integration.cucumber.utils.driver

import org.openqa.selenium.WebDriver

import scala.collection.JavaConversions._

trait WindowControls {
  val instance: WebDriver
  lazy val baseWindowHandle: String = instance.getWindowHandle

  def closeExtraWindows(): Unit = {
    instance.getWindowHandles.toList
      .filter(handle => handle != baseWindowHandle)
      .foreach(instance.switchTo().window(_).close())
    instance.switchTo().window(baseWindowHandle)
  }
}
