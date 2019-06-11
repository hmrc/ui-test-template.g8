name := "$name$"

version := "0.1.0"

scalaVersion := "2.11.11"

scalacOptions ++= Seq("-unchecked", "-deprecation", "-feature")

resolvers += "hmrc-releases" at "https://artefacts.tax.service.gov.uk/artifactory/hmrc-releases/"

$if(!cucumber.truthy)$
  testOptions in Test += Tests.Argument(TestFrameworks.ScalaTest, "-h", "target/test-reports/html-report")
  testOptions in Test += Tests.Argument("-o")
$endif$

libraryDependencies ++= Seq(
  "uk.gov.hmrc"                %% "webdriver-factory"       % "0.6.0"   % "test",
  "org.scalatest"              %% "scalatest"               % "3.0.7" % "test",
  $if(!cucumber.truthy)$
  "org.pegdown"                %  "pegdown"                 % "1.2.1" % "test",
  $else$
  "info.cukes"                 %% "cucumber-scala"          % "1.2.5" % "test",
  "info.cukes"                 %  "cucumber-junit"          % "1.2.5" % "test",
  "info.cukes"                 %  "cucumber-picocontainer"  % "1.2.5" % "test",
  "junit"                      %  "junit"                   % "4.12"  % "test",
  "com.novocode"               %  "junit-interface"         % "0.11"  % "test",
  $endif$
  "com.typesafe"               %  "config"                  % "1.3.2"
  )

