# swift-webview-isolated

Mini web browser. (Attempt to create an) Example of use of a isolated WebView for Mac OS X.

A problem with Cocoa's WebView in Mac OS X[1] is that there is a common cookies jar for all the process.
This means that, for example, Safari shares its sessions with every WebView instance you have in your apps[2]

This is a problem if you want your app to bahaive independiently from Safari and from other programas.

For this implementation I'm following this articles:

* http://cutecoder.org/programming/implementing-cookie-storage/ (how to handle HTTP cookies)
* http://cutecoder.org/programming/handling-cookies-javascript-custom-jar/ (how to handle JavaScript document.cookie cookies)

The current implementation works for some websites but others fail to load correctly after login, for example gmail and newrelic.

[1] In Cocoa Touch (for Iphones and I-Pads) it works exactly oposite: each app has its own cookie jar.

[2] This is not true for sandboxed apps but I don't want to rely on this to solve the problem.
