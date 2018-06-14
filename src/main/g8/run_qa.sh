#!/bin/bash
ENV="qa"
BROWSER="chrome"
DRIVER_PATH=/usr/local/bin/chromedriver

sbt -Dlogback.configurationFile=logback.xml -Dbrowser=\$BROWSER -Denvironment=\$ENV -Dwebdriver.chrome.driver=\${DRIVER_PATH} 'test-only uk.gov.hmrc.test.ui.cucumber.runner.RunnerQA'