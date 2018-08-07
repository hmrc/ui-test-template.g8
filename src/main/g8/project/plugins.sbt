credentials += Credentials(Path.userHome / ".sbt" / ".credentials")

addSbtPlugin("com.dadrox" % "sbt-test-reports" % "0.1")
addSbtPlugin("uk.gov.hmrc" % "hmrc-resolvers" % "0.4.0")
addSbtPlugin("org.foundweekends.giter8" % "sbt-giter8-scaffold" % "0.11.0")