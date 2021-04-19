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
package uk.gov.hmrc.test.ui.cucumber.stepdefs

import org.openqa.selenium.By
import uk.gov.hmrc.test.ui.pages.{ExamplePage, PayOnlinePage}

class ExampleStepDef extends BaseStepDef {

  Given("a user logs in to access payments page") { () =>
    driver.navigate().to(ExamplePage.url)

    driver.findElement(By.name("redirectionUrl")).clear()
    driver.findElement(By.name("redirectionUrl")).sendKeys(PayOnlinePage.url)
    driver.findElement(By.cssSelector("Input[value='Submit']")).click()

    eventually {
      driver.getTitle should be(PayOnlinePage.title)
    }
  }

  Given("a user navigates to payments page") { () =>
    driver.navigate().to(PayOnlinePage.url)
  }

  When("the user chooses to pay VAT tax") { () =>
    val vatId = "tax_to_pay-2"
    driver.findElement(By.id(vatId)).click()
    driver.findElement(By.id("next")).click()
  }

  Then("payment details page is displayed") { () =>
    eventually {
      driver.getTitle should be("Choose a way to pay - Pay your VAT - GOV.UK")
    }
  }

}
