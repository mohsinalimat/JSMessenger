# JSMessenger
JavaScript 调用 Native 方法的轻量库

# 概览
使用 JSMessenger 你可以在 JavaScript 里面调用 Native 方法并且获得返回值，不需要设置任何的回调方法。

出于安全考虑，你需要用简单的一行代码将整个类或者一个方法暴露给 WebView。

# 特性

> * 轻量并且易于使用
> * 支持调用含有基本数据类型的方法（int, BOOL 等等）
> * 不需要设置回调方法
> * 导出整个类或者单独的一个方法给 JavaScript
> * 支持 WKWebView & UIWebView
> * 不会污染你 WebView 的 Delegates

# 用法

# WebView

在你有 WebView 的类里面导入 "JSMessenger.h" 并且实现代理方法
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

在你需要导出的类或者方法里面，添加如下代码
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
在 JavaScript 里面添加初始化方法
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

已经设置完成了，现在你在 JavaScript 里面可以使用上面导出的 JSMessageHandler 里面的 foo:bar: 方法了
```JavaScript
JSMessenger.msgSend("JSMessageHandler", "foo:bar:", [1024, 1024], function(resp) {
  alert(resp.data);
});
```
msgSend 函数的原型是 JSMessenger.msgSend("类名", "方法名", [参数列表], 回调函数)

对于无参数的方法，也可以使用下面的形式
```JavaScript
JSMessenger.msgSend("JSMessageHandler", "foobar", function(resp) {
  alert(resp.data);
});
```

# WebView Extensions

你可以使用 WKWebView/UIWebView 的 Category 方法从 native 发消息给 JavaScript
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



