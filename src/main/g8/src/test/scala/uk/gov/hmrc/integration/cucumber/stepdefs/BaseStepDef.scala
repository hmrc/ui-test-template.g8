package uk.gov.hmrc.integration.cucumber.stepdefs

import cucumber.api.scala.{EN, ScalaDsl}
import uk.gov.hmrc.integration.cucumber.pages.BasePage._

class BaseStepDef extends ScalaDsl with EN {

  And("""^The user refreshes the page\$""") { () =>
    pageRefresh()
  }

  And("""^the (Continue|Submit) button is clicked\$""") { () =>
    clickContinue()
  }

  Then("""^the browser is shutdown\$""") { () =>
    ShutdownTest()
  }


}
