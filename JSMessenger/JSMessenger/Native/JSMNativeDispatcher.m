//
//  JSMNativeDispatcher.m
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "JSMNativeDispatcher.h"
#import "NSInvocation+JSMExtension.h"
#import "NSMethodSignature+JSMExtension.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation JSMNativeDispatcher

+ (void)msgSend:(NSDictionary *)message returnBlock:(JSMNativeDispatcherReturnBlock)block {
    
    NSString *className = message[@"class"];
    NSString *methodName = message[@"method"];
    NSArray *arguments = message[@"args"];
    
    id clazz = NSClassFromString(className);
    SEL selector = NSSelectorFromString(methodName);
    
    if ([self _isValidClass:clazz method:selector]) { // validate
        if (clazz && [clazz respondsToSelector:selector]) { // class method
            [self _sendMessage:clazz selector:selector arguments:arguments returnBlock:block];
        } else {
            id instance = [[(Class)clazz alloc] init];
            if (instance && [instance respondsToSelector:selector]) { // instance method
                [self _sendMessage:instance selector:selector arguments:arguments returnBlock:block];
            }
        }
    }
}

/**
 *  Check a class or method is valid
 *
 *  @param clazz  class
 *  @param method selector
 *
 *  @return is valid
 */
+ (BOOL)_isValidClass:(Class)clazz method:(SEL)method {
    
    if (!clazz) {
        return NO;
    }
    
    // find __jsm_export__ methods
    unsigned int count;
    const char *meta = [NSStringFromClass(clazz) UTF8String];
    Method *methods = class_copyMethodList(objc_getMetaClass(meta), &count);
    for (int i=0; i<count; ++i) {
        SEL selector = method_getName(methods[i]);
        NSString *name = NSStringFromSelector(selector);
        if ([name hasPrefix:@"__jsm_export__"]) {
            IMP imp = [clazz methodForSelector:selector];
            NSString *result = ((NSString * (*)(id, SEL))imp)(clazz, selector);
            if ([result isEqualToString:NSStringFromClass(clazz)]) { // class exported
                free(methods);
                return YES;
            } else if ([result isEqualToString:NSStringFromSelector(method)]) { // method exported
                free(methods);
                return YES;
            }
        }
    }
    
    free(methods);
    
    return NO;
}

/**
 *  Call native method
 *
 *  @param target    target
 *  @param selector  selector
 *  @param arguments arguments
 *  @param block     ^(id returnValue)
 */
+ (void)_sendMessage:(id)target selector:(SEL)selector arguments:(NSArray *)arguments returnBlock:(JSMNativeDispatcherReturnBlock)block {
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [signature invocationWithArguments:arguments];
    id returnValue = [invocation invoke:target selector:selector];
    if (block) {
        block([returnValue description]);
    }
}


@end
