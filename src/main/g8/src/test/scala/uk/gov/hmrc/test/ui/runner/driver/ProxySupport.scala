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
package uk.gov.hmrc.test.ui.runner.driver

import java.net.InetSocketAddress

import net.lightbody.bmp.client.ClientUtil
import net.lightbody.bmp.proxy.auth.AuthType
import net.lightbody.bmp.{BrowserMobProxy, BrowserMobProxyServer}
import org.openqa.selenium.Proxy

trait ProxySupport {

  protected lazy val proxy: BrowserMobProxy = new BrowserMobProxyServer

  protected def initialiseProxy(): Proxy = {
    val proxySettingPattern = """(.+):(.+)@(.+):(\d+)""".r
    System.getProperty("qa.proxy") match {
      case proxySettingPattern(user, password, host, port) =>
        proxy.chainedProxyAuthorization(user, password, AuthType.BASIC)
        proxy.setChainedProxy(new InetSocketAddress(host, port.toInt))
      case _ => sys.error("QA Proxy settings must be provided as username:password@proxyHost:proxyPortNumber")
    }
    proxy.setTrustAllServers(true)
    proxy.start()
    ClientUtil.createSeleniumProxy(proxy)
  }

}
