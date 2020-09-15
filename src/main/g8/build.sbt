lazy val testSuite = (project in file("."))
  .enablePlugins(SbtAutoBuildPlugin)
  .disablePlugins(JUnitXmlReportPlugin) //Required to prevent https://github.com/scalatest/scalatest/issues/1427
  .settings(
    name := "$name$",
    version := "0.1.0",
    scalaVersion := "2.12.12",
    scalacOptions ++= Seq("-feature"),
    libraryDependencies ++= Dependencies.test,
    $if(cucumber.truthy)$
      //The testOptions from SbtAutoBuildPlugin supports only ScalaTest. Resetting testOptions for Cucumber Tests.
      testOptions in Test := Seq.empty,
    $endif$
    resolvers ++= Seq(
      Resolver.bintrayRepo("hmrc", "releases"),
      Resolver.typesafeRepo("releases"),
      "hmrc-releases" at "https://artefacts.tax.service.gov.uk/artifactory/hmrc-releases/"
    )
  )