//
//  JSMessenger.m
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "JSMessenger.h"
#import "JSMJSONHelper.h"
#import "JSMNativeDispatcher.h"

static NSString *const kJSMJavaScriptFile           = @"JSMessenger";       // JavaScript file name
static NSString *const kJSMInterceptScheme          = @"jsmessenger";       // JSMessenger URL Scheme
static NSString *const kJSMInterceptCommandInit     = @"init";              // init command
static NSString *const kJSMInterceptCommandMsgSend  = @"msgsend";           // msg send command

typedef void (^JSMWebViewInterceptBlock) (BOOL intercepted);

@implementation JSMessenger

+ (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = [[navigationAction request] URL];
    [JSMessenger interceptURL:URL webView:webView returnBlock:^(BOOL intercepted) {
        if (intercepted) { // cancel request
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }];
}

+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    __block BOOL shouldStart = YES;
    NSURL *URL = request.URL;
    [JSMessenger interceptURL:URL webView:webView returnBlock:^(BOOL intercepted) {
        shouldStart = !intercepted;
    }];
    return shouldStart;
}

/**
 *  intercept a URL
 *
 *  @param URL     URL
 *  @param webView WKWebView/UIWebView
 *  @param block   ^(BOOL intercepted)
 */
+ (void)interceptURL:(NSURL *)URL webView:(id)webView returnBlock:(JSMWebViewInterceptBlock)block {
    
    BOOL intercepted = NO;
    
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:kJSMInterceptScheme]) { // URL Scheme matched
        if ([URL.host isEqualToString:kJSMInterceptCommandInit]) {
            [JSMessenger injectJavaScript:webView];
        } else if ([URL.host isEqualToString:kJSMInterceptCommandMsgSend]) {
            [JSMessenger msgSend:webView URL:URL];
        }
        intercepted = YES;
    }
    
    if (block) {
        block(intercepted);
    }
}

/**
 *  JavaScript injection
 *
 *  @param webView WKWebView/UIWebView
 */
+ (void)injectJavaScript:(id)webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:kJSMJavaScriptFile ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [JSMessenger evaluateJavaScript:script webView:webView returnBlock:nil];
}

/**
 *  Send message to WebView
 *
 *  @param webView WKWebView/UIWebView
 *  @param URL     URL
 */
+ (void)msgSend:(id)webView URL:(NSURL *)URL {
    [JSMessenger evaluateJavaScript:self.fetchJavaScriptMessage webView:webView returnBlock:^(id result) {
        NSArray *messages = JSONObjectWithString(result);
        for (NSDictionary *message in messages) {
            [JSMessenger handleJavaScript:webView message:message];
        }
    }];
}

/**
 *  Handle message from JavaScript
 *
 *  @param webView WKWebView/UIWebView
 *  @param message message object
 */
+ (void)handleJavaScript:(id)webView message:(NSDictionary *)message {
    [JSMNativeDispatcher msgSend:message returnBlock:^(NSString *returnValue) {
        NSDictionary *json = @{
            @"callback": message[@"callback"],
            @"data": returnValue
        };
        [JSMessenger evaluateJavaScript:[JSMessenger fetchNativeMessage:json] webView:webView returnBlock:nil];
    }];
}

/**
 *  Fetch JavaScript message
 *
 *  @return JavaScript message
 */
+ (NSString *)fetchJavaScriptMessage {
    return @"JSMessenger.fetchJavaScriptMessage();";
}

/**
 *  Generate Native Message
 *
 *  @param json JSON
 *
 *  @return JavaScript
 */
+ (NSString *)fetchNativeMessage:(NSDictionary *)json {
    NSString *string = JSONStringWithObject(json);
    NSString *script = [NSString stringWithFormat:@"JSMessenger.fetchNativeMessage(%@);", string];
    return script;
}

+ (void)evaluateJavaScript:(NSString *)script webView:(id)webView returnBlock:(JSMJavaScriptEvaluateBlock)block {
    if ([webView isKindOfClass:[WKWebView class]]) {
        [webView evaluateJavaScript:script completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (block) {
                block(result);
            }
        }];
    } else if ([webView isKindOfClass:[UIWebView class]]) {
        NSString *result = [webView stringByEvaluatingJavaScriptFromString:script];
        if (block) {
            block(result);
        }
    }
}

+ (NSString *)buildJavaScriptMethod:(NSString *)method args:(NSArray *)args {
    NSString *json = JSONStringWithObject(args);
    NSString *param = [json substringWithRange:NSMakeRange(1, json.length - 2)];
    NSString *script = [NSString stringWithFormat:@"%@(%@);", method, param];
    return script;
}

@end
