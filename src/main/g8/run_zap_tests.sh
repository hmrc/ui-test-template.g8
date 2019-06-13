#!/usr/bin/env bash

ENV=\${1:-local}
BROWSER=\${2:-chrome}

if [ "\$BROWSER" = "chrome" ]; then
    DRIVER="-Dwebdriver.chrome.driver=/usr/local/bin/chromedriver"
elif [ "\$BROWSER" = "firefox" ]; then
    DRIVER="-Dwebdriver.gecko.driver=/usr/local/bin/geckodriver"
fi

# NOTE: It is not required to proxy every journey test via ZAP. The intention of proxying a test through ZAP is to expose all the
# relevant pages of an application to ZAP. So tagging a subset of the journey tests or creating a
# single ZAP focused journey test is sufficient.

$if(cucumber.truthy)$
sbt -Dbrowser=\$BROWSER -Denvironment=\$ENV \$DRIVER -Dzap.proxy=true 'test-only uk.gov.hmrc.test.ui.cucumber.runner.ZapRunner'
$else$
# -n ZapTests Runs only the tests tagged as ZapTests.
sbt -Dbrowser=\$BROWSER -Denvironment=\$ENV \$DRIVER -Dzap.proxy=true "testOnly uk.gov.hmrc.test.ui.specs.* -- -n ZapTests"
$endif$

sbt "testOnly uk.gov.hmrc.test.ui.ZapSpec"
