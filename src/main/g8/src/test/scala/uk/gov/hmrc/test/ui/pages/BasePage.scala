package uk.gov.hmrc.test.ui.pages

$if(cucumber.truthy)$
import org.scalatest.Matchers

trait BasePage extends Matchers {
  val url: String
}

$else$
import org.scalatest.Matchers
import org.scalatestplus.selenium.{Page, WebBrowser}

trait BasePage extends Matchers with Page with WebBrowser {

  val url: String

}
$endif$