//
//  JSMessageHandler.m
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "JSMessageHandler.h"
#import "JSMessenger.h"

@implementation JSMessageHandler

JSMessengerExportMethod(@selector(foo:bar:))

- (int)foo:(int)foo bar:(int)bar {
    NSLog(@"Receive Message from JavaScript: %d, %d", foo, bar);
    return (foo + bar);
}

@end
