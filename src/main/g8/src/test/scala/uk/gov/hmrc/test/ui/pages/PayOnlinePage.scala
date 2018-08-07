package uk.gov.hmrc.test.ui.pages

import uk.gov.hmrc.test.ui.conf.TestConfiguration

object PayOnlinePage extends BasePage {
  val url: String = TestConfiguration.url("payments-frontend")
  val title = "Select the tax you want to pay - Pay a tax bill - Gov.UK"

}