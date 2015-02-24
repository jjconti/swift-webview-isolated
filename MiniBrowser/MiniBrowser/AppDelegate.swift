//
//  AppDelegate.swift
//  MiniBrowser
//
//  Created by Juanjo Conti on 05/02/15.


import Cocoa
import WebKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var urlField: NSTextField!

    @IBOutlet weak var webView: WebView!

    var cookieStorage = BSHTTPCookieStorage()
    var settings = Settings()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        cookieStorage = settings.retrieveCookieStorage()
        webView.resourceLoadDelegate = self
        webView.policyDelegate = self
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func go(sender: NSButton) {
        if let nsurl = NSURL(string: urlField.stringValue) {
            var req = NSURLRequest(URL:nsurl)
            webView.mainFrame.loadRequest(req)
        } else {
            // Wrong url format
            NSLog("Wrong url format in: \(urlField.stringValue)")
        }
    }

    @IBAction func save(sender: NSButton) {
        settings.saveCookieStorage(cookieStorage)
    }

    @IBAction func delete(sender: NSButton) {
        settings.deleteCookieStorage()
        cookieStorage = settings.retrieveCookieStorage()
    }

    @IBAction func show(sender: AnyObject) {
        var cookies = cookieStorage.cookiesForURL(NSURL(string: urlField.stringValue));
        var i = 1
        for c in cookies {
            NSLog("\(i): \(c.name)")
            i++
        }
    }

    // ResourceLoadDelegate methods

    override func webView(sender: WebView!, resource: AnyObject!, willSendRequest request: NSURLRequest!, redirectResponse: NSURLResponse!, fromDataSource: WebDataSource!) -> NSURLRequest! {
        if redirectResponse != nil && redirectResponse.isKindOfClass(NSHTTPURLResponse) {
            cookieStorage.handleCookiesInResponse(redirectResponse as NSHTTPURLResponse)
        }

        var modifiedRequest: NSMutableURLRequest = request.mutableCopy() as NSMutableURLRequest
        modifiedRequest.HTTPShouldHandleCookies = false
        cookieStorage.handleCookiesInRequest(modifiedRequest)
        return modifiedRequest

    }

    override func webView(sender: WebView!, resource: AnyObject!, didReceiveResponse response: NSURLResponse!, fromDataSource: WebDataSource!) {
        if response != nil && response.isKindOfClass(NSHTTPURLResponse) {
            cookieStorage.handleCookiesInResponse(response as? NSHTTPURLResponse)
        }
    }

    override func webView(sender: WebView!, resource: AnyObject!, didFinishLoadingFromDataSource: WebDataSource!) {
        urlField.stringValue = sender.mainFrameURL
    }

    override func webView(sender: WebView, resource: AnyObject!, didFailLoadingWithError error: NSError!, fromDataSource: WebDataSource!) {
        NSLog("Error: \(error)")
    }

    // PolicyDelegate methods

    override func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        var jsCookies = webView.stringByEvaluatingJavaScriptFromString("document.cookie")
        var jsURL = webView.stringByEvaluatingJavaScriptFromString("document.URL")
        cookieStorage.handleWebScriptCookies(jsCookies, forURLString: jsURL)

        listener.use()
    }
}

