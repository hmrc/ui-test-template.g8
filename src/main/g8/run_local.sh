#!/bin/bash
ENV="local"
BROWSER="firefox"
DRIVER_PATH=/usr/local/bin/geckodriver

$if(cucumber.truthy)$
sbt -Dlogback.configurationFile=logback.xml -Dbrowser=\$BROWSER -Denvironment=\$ENV -Dwebdriver.gecko.driver=\${DRIVER_PATH} 'test-only uk.gov.hmrc.test.ui.cucumber.runner.Runner'
$else$
sbt -Dlogback.configurationFile=logback.xml -Dbrowser=\$BROWSER -Denvironment=\$ENV -Dwebdriver.gecko.driver=\${DRIVER_PATH} test
$endif$
