//
//  JSMNativeDispatcher.h
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JSMNativeDispatcherReturnBlock) (NSString *returnValue);

@interface JSMNativeDispatcher : NSObject

/**
 *  Send message to native code
 *
 *  @param message message object
 *  @param block   ^(id returnValue)
 */
+ (void)msgSend:(NSDictionary *)message returnBlock:(JSMNativeDispatcherReturnBlock)block;

@end
