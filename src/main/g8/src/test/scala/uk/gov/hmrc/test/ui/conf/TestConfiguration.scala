/*
 * Copyright 2018 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package uk.gov.hmrc.test.ui.conf

import java.io.FileInputStream
import java.util.Properties

object TestConfiguration {
  val fis = new FileInputStream("src/test/resources/environment.properties")
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
