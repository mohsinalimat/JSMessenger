//
//  WKWebView+JSMExtension.h
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "JSMessengerDefine.h"

@interface WKWebView (JSMExtension)

/**
 *  Send message to WKWebView
 *
 *  @param method method name
 *  @param args   args list
 *  @param block  ^(id returnValue)
 */
- (void)msgSend:(NSString *)method args:(NSArray *)args returnBlock:(JSMJavaScriptEvaluateBlock)block;

@end
