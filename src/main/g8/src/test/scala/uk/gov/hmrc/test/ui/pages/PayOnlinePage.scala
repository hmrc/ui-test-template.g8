package uk.gov.hmrc.test.ui.pages

import uk.gov.hmrc.test.ui.conf.TestConfiguration

object PayOnlinePage extends BasePage {
  val url = TestConfiguration.url("payments-frontend")
  val header = "Select the tax you want to pay"
}