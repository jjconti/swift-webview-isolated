# swift-webview-isolated

Mini web browser. (Attempt to create an) Example of use of a isolated WebView for Mac OS X.

A problem with Cocoa's WebView in Mac OS X is that there is a common cookies jar for all the process.
This means that, for example, Safari shares its sessions with every WebView instance you have in your apps.

This is a problem if you want your app to bahaive independiently from Safari and from other programas.

For this implementation I'm following this articles:

* http://cutecoder.org/programming/implementing-cookie-storage/ (how to handle HTTP cookies)
* http://cutecoder.org/programming/handling-cookies-javascript-custom-jar/ (how to handle JavaScript document.cookie cookies)
