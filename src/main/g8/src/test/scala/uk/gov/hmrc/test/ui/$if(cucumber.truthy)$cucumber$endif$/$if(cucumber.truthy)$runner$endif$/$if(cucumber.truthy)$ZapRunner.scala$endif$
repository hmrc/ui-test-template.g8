package uk.gov.hmrc.test.ui.cucumber.runner

import io.cucumber.junit.Cucumber
import io.cucumber.junit.CucumberOptions
import org.junit.runner.RunWith

@RunWith(classOf[Cucumber])
@CucumberOptions(
  features = Array("src/test/resources/features"),
  glue = Array("uk.gov.hmrc.test.ui.cucumber.stepdefs"),
  plugin =
    Array("pretty", "html:target/cucumber", "json:target/cucumber.json", "junit:target/test-reports/ZapRunner.xml"),
  tags = "@ZAP"
)
class ZapRunner {}
