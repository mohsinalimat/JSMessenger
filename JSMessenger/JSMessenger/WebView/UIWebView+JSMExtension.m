//
//  UIWebView+JSMExtension.m
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "UIWebView+JSMExtension.h"
#import "JSMessenger.h"

@implementation UIWebView (JSMExtension)

- (void)msgSend:(NSString *)method args:(NSArray *)args returnBlock:(JSMJavaScriptEvaluateBlock)block {
    [JSMessenger evaluateJavaScript:[JSMessenger buildJavaScriptMethod:method args:args]
                            webView:self
                        returnBlock:block];
}

@end
