import sbt._

object Dependencies {

  val test = Seq(
    "uk.gov.hmrc"         %% "webdriver-factory" % "0.15.0"  % Test,
    "org.scalatest"       %% "scalatest"         % "3.2.0"   % Test,
    "org.scalatestplus"   %% "selenium-3-141"    % "3.2.0.0" % Test,
    "com.vladsch.flexmark" % "flexmark-all"      % "0.35.10" % Test,
    $if(!cucumber.truthy)$
    "org.pegdown"          % "pegdown"           % "1.2.1"   % Test,
    $else$
    "io.cucumber"         %% "cucumber-scala"    % "6.9.1"   % Test,
    "io.cucumber"          % "cucumber-junit"    % "6.9.1"   % Test,
    "junit"                % "junit"             % "4.12"    % Test,
    "com.novocode"         % "junit-interface"   % "0.11"    % Test,
    $endif$
    "uk.gov.hmrc"         %% "zap-automation"    % "2.8.0"   % Test,
    "com.typesafe"         % "config"            % "1.3.2"   % Test
  )

}
