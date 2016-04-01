//
//  JSMessenger.h
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSMessengerDefine.h"
#import "WKWebView+JSMExtension.h"
#import "UIWebView+JSMExtension.h"

@interface JSMessenger : NSObject

/**
 *  intercept request from WKWebView
 *
 *  @param webView          WKWebView instance
 *  @param navigationAction navigationAction
 *  @param decisionHandler  decisionHandler
 */
+ (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

/**
 *  intercept request from UIWebView
 *
 *  @param webView        UIWebView instance
 *  @param request        request
 *  @param navigationType navigationType
 *
 *  @return is request intercepted
 */
+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

/**
 *  evaluate JavaScript for WKWebView or UIWebView
 *
 *  @param script  JavaScript
 *  @param webView WKWebView/UIWebView
 *  @param block   ^(id value)
 */
+ (void)evaluateJavaScript:(NSString *)script webView:(id)webView returnBlock:(JSMJavaScriptEvaluateBlock)block;

/**
 *  build JavaScript method with name and args
 *
 *  @param method method name
 *  @param args   args list
 *
 *  @return JavaScript
 */
+ (NSString *)buildJavaScriptMethod:(NSString *)method args:(NSArray *)args;

@end
