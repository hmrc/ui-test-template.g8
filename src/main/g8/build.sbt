name := "$name$"

version := "0.1.0"

scalaVersion := "2.11.11"

credentials += Credentials(Path.userHome / ".sbt" / ".credentials")

scalacOptions ++= Seq("-unchecked", "-deprecation", "-feature")

libraryDependencies ++= Seq(
  "org.seleniumhq.selenium"    %  "selenium-chrome-driver"  % "3.9.1",
  "org.seleniumhq.selenium"    %  "selenium-support"        % "3.9.1",
  "org.seleniumhq.selenium"    %  "selenium-firefox-driver" % "3.9.1",
  "org.scalatest"              %% "scalatest"               % "3.0.5" % "test",
  $if(cucumber.truthy)$
  "info.cukes"                 %% "cucumber-scala"          % "1.2.5" % "test",
  "info.cukes"                 %  "cucumber-junit"          % "1.2.5" % "test",
  "info.cukes"                 %  "cucumber-picocontainer"  % "1.2.5" % "test",
  "junit"                      %  "junit"                   % "4.12"  % "test",
  "com.novocode"               %  "junit-interface"         % "0.11"  % "test",
  $endif$
  "ch.qos.logback"             %  "logback-classic"         % "1.2.3",
  "com.typesafe.scala-logging" %% "scala-logging"           % "3.8.0",
  "com.typesafe"               %  "config"                  % "1.3.2"
  )

