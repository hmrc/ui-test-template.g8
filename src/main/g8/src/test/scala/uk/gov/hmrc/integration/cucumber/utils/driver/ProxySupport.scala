package uk.gov.hmrc.integration.cucumber.utils.driver

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
