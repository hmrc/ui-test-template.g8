package uk.gov.hmrc.test.ui.specs

import uk.gov.hmrc.test.ui.pages.{ExamplePage, PayOnlinePage}
import uk.gov.hmrc.test.ui.spec.BaseSpec
import uk.gov.hmrc.test.ui.specs.tags.ZapTests

class ExampleSpec extends BaseSpec {

  info("Example Spec using ScalaTest")

  feature("User accessing payments page") {

    scenario("A logged in user is able to access payment details page", ZapTests) { //Remove ZapTests tag if not required

      Given("A logged in user accesses payments page")

      go to ExamplePage
      pageTitle shouldBe ExamplePage.title
      ExamplePage.login(PayOnlinePage.url)

      eventually {
        pageTitle shouldBe PayOnlinePage.title
      }

      When("User chooses to pay VAT tax")
      click on radioButton("vat")
      click on "next"
      eventually {
        pageTitle shouldBe "Choose a way to pay - Pay HMRC - GOV.UK"
      }

      Then("Choose a way to pay page is displayed")
      tagName("h1").element.text shouldBe "Choose a way to pay"
    }
  }
}