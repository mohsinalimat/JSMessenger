//
//  NSInvocation+JSMExtension.m
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "NSInvocation+JSMExtension.h"
#import "NSMethodSignature+JSMExtension.h"
#import <UIKit/UIKit.h>

@implementation NSInvocation (JSMExtension)

/**
 *  Boxing returnType of NSMethodSignature
 *
 *  @param signature signature
 *
 *  @return boxed value
 */
- (id)returnValueOfSignature:(NSMethodSignature *)signature {
    
    id returnValue;
    
    JSMethodArgumentType returnType = [signature returnType];
    switch (returnType) {
        case JSMethodArgumentTypeChar: {
            char value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeInt:  {
            int value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeShort:  {
            short value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeLong:  {
            long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeLongLong:  {
            long long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeUnsignedChar:  {
            unsigned char value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeUnsignedInt:  {
            unsigned int value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeUnsignedShort:  {
            unsigned short value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeUnsignedLong:  {
            unsigned long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeUnsignedLongLong:  {
            unsigned long long value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeFloat:  {
            float value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeDouble:  {
            double value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeBool: {
            BOOL value;
            [self getReturnValue:&value];
            returnValue = @(value);
        } break;
        case JSMethodArgumentTypeCharacterString: {
            const char *value;
            [self getReturnValue:&value];
            returnValue = [NSString stringWithUTF8String:value];
        } break;
        case JSMethodArgumentTypeCGPoint: {
            CGPoint value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithCGPoint:value];
        } break;
        case JSMethodArgumentTypeCGSize: {
            CGSize value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithCGSize:value];
        } break;
        case JSMethodArgumentTypeCGRect: {
            CGRect value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithCGRect:value];
        } break;
        case JSMethodArgumentTypeUIEdgeInsets: {
            UIEdgeInsets value;
            [self getReturnValue:&value];
            returnValue = [NSValue valueWithUIEdgeInsets:value];
        } break;
        case JSMethodArgumentTypeObject:
        case JSMethodArgumentTypeClass:
            [self getReturnValue:&returnValue];
            break;
        default: break;
    }
    return returnValue;
}

- (id)invoke:(id)target selector:(SEL)selector {
    self.target = target;
    self.selector = selector;
    [self invoke];
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    return [self returnValueOfSignature:signature];
}

@end
