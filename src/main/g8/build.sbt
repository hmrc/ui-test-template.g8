import sbt.Resolver

name := "$name$"

version := "0.1.0"

scalaVersion := "2.12.11"

scalacOptions ++= Seq("-unchecked", "-deprecation", "-feature")

resolvers += "hmrc-releases" at "https://artefacts.tax.service.gov.uk/artifactory/hmrc-releases/"
resolvers += Resolver.bintrayRepo("hmrc", "releases")

lazy val testSuite = (project in file("."))
  .disablePlugins(JUnitXmlReportPlugin) //Required to prevent https://github.com/scalatest/scalatest/issues/1427

$if(!cucumber.truthy)$
  testOptions in Test += Tests.Argument(TestFrameworks.ScalaTest, "-h", "target/test-reports/html-report")
  testOptions in Test += Tests.Argument("-o")
$endif$

libraryDependencies ++= Seq(
  "uk.gov.hmrc"                %% "webdriver-factory"       % "0.11.0"   % "test",
  "org.scalatest"              %% "scalatest"               % "3.0.7" % "test",
  $if(!cucumber.truthy)$
  "org.pegdown"                %  "pegdown"                 % "1.2.1" % "test",
  $else$
  "io.cucumber"                %% "cucumber-scala"          % "6.1.1" % "test",
  "io.cucumber"                %  "cucumber-junit"          % "6.1.1" % "test",
  "junit"                      %  "junit"                   % "4.12"  % "test",
  "com.novocode"               %  "junit-interface"         % "0.11"  % "test",
  $endif$
  "uk.gov.hmrc"                %% "zap-automation"          % "2.7.0"  % "test",
  "com.typesafe"               %  "config"                  % "1.3.2"
  )

