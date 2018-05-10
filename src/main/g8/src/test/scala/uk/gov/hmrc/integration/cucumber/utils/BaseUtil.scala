package uk.gov.hmrc.integration.cucumber.utils

import java.io.FileInputStream
import java.util.Properties

object BaseUtil {
  val fis = new FileInputStream("src/test/scala/uk/gov/hmrc/integration/cucumber/environments.properties")
  val props: Properties = new Properties()
  loadProperties(fis, props)

  def loadProperties(aFis: FileInputStream, aProps: Properties) = {
    try {aProps.load(aFis)}
    catch {case e: Exception => println("Exception loading file")}
    finally {
      if (aFis != null) {
        try {aFis.close()}
        catch {case e: Exception => println("Exception on closing file")}
      }
    }
  }

  def getProperty(key: String, aProps: Properties = props): String = {
    try {
      val utf8Property = new String(aProps.getProperty(key).getBytes("ISO-8859-1"), "UTF-8")
      utf8Property.replaceAll("''","'")
    }
    catch {case e: Exception => "Exception getting property"}
  }
}
