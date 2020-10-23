import sbt._

object Dependencies {

  val test = Seq(
    "uk.gov.hmrc"                %% "webdriver-factory"       % "0.13.0" % Test,
    "org.scalatest"              %% "scalatest"               % "3.0.7"  % Test,
    $if(!cucumber.truthy)$
      "org.pegdown"                %  "pegdown"                 % "1.2.1" % Test,
    $else$
    "io.cucumber"                %% "cucumber-scala"          % "6.1.1" % Test,
    "io.cucumber"                %  "cucumber-junit"          % "6.1.1" % Test,
    "junit"                      %  "junit"                   % "4.12"  % Test,
    "com.novocode"               %  "junit-interface"         % "0.11"  % Test,
    $endif$
    "uk.gov.hmrc"                %% "zap-automation"          % "2.7.0" % Test,
    "com.typesafe"               %  "config"                  % "1.3.2" % Test
  )

}