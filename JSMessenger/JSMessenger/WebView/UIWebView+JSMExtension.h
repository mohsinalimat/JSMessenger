//
//  UIWebView+JSMExtension.h
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessengerDefine.h"

@interface UIWebView (JSMExtension)

/**
 *  Send message to UIWebView
 *
 *  @param method method name
 *  @param args   args list
 *  @param block  ^(id returnValue)
 */
- (void)msgSend:(NSString *)method args:(NSArray *)args returnBlock:(JSMJavaScriptEvaluateBlock)block;

@end
