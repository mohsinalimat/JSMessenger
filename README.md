[🇨🇳中文介绍](https://github.com/cyanzhong/JSMessenger/blob/master/README_CN.md)

# JSMessenger v0.1
A lightweight library let you call native methods from WebView directly

# Overview
With JSMessenger, you can call native methods and get response from WebView directly, without set any callback functions.

For security reason, you need use a single line code to export Objective-C Class or Method to WebView.

# Features

> * Lightweight and easy to use
> * Support method with basic type arguments (int, BOOL and so on)
> * Without callback block
> * Class export and method export
> * WKWebView & UIWebView supported
> * Easy to handle with your WKWebView/UIWebView Delegates

# Usage

# WebView

import "JSMessenger.h" in your WebView container class, and implement delegate

```Objective-C
// WKWebView
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [JSMessenger webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [JSMessenger webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}
```

If you need a Class or Method can be access from JavaScript, just export like that
```Objective-C
#import "JSMessageHandler.h"
#import "JSMessenger.h"

@implementation JSMessageHandler

JSMessengerExportClass(JSMessageHandler)      // export whole class
JSMessengerExportMethod(@selector(foo:bar:))  // export a selector

- (int)foo:(int)foo bar:(int)bar {
    NSLog(@"Receive Message from JavaScript: %d, %d", foo, bar);
    return (foo + bar);
}

@end
```

# JavaScript
In your JavaScript code, add a initializer like that
```JavaScript
(function() {
  var iframe = document.createElement('iframe');
  iframe.style.display = 'none';
  iframe.src = 'jsmessenger://init';
  document.documentElement.appendChild(iframe);
  setTimeout(function() {
    document.documentElement.removeChild(iframe)
  }, 0)
})()
```

It's done, now you can JavaScript call a method from JSMessageHandler (or whatever you set)
```JavaScript
JSMessenger.msgSend("JSMessageHandler", "foo:bar:", [1024, 1024], function(resp) {
  alert(resp.data);
});
```
Just use JSMessenger.msgSend("Class Name", "Method Name", [argument list], callback function) to access native method.

You can call a method without arguments like that
```JavaScript
JSMessenger.msgSend("JSMessageHandler", "foobar", function(resp) {
  alert(resp.data);
});
```

# WebView Extensions

You can use a Category Method in WKWebView/UIWebView to send message from native to JavaScript like that

```Objective-C

/**
 *  Send message to WebView
 *
 *  @param method method name
 *  @param args   args list
 *  @param block  ^(id returnValue)
 */
- (void)msgSend:(NSString *)method args:(NSArray *)args returnBlock:(JSMJavaScriptEvaluateBlock)block;

[self.webView msgSend:@"foobar" args:@[ @"Hello", @"WKWebView" ] returnBlock:^(id returnValue) {
    NSLog(@"Receive Response from JavaScript: %@", returnValue);
}];
```



