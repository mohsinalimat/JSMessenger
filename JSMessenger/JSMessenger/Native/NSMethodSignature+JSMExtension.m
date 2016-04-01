//
//  NSMethodSignature+JSMExtension.m
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "NSMethodSignature+JSMExtension.h"
#import <UIKit/UIKit.h>

@interface NSString (TypeChecking)

- (BOOL)isEqualToType:(char [])type;

@end

@implementation NSString (TypeChecking)

- (BOOL)isEqualToType:(char [])type {
    return [self isEqualToString:[NSString stringWithUTF8String:type]];
}

@end

@implementation NSMethodSignature (JSMExtension)

- (JSMethodArgumentType)returnType {
    return [NSMethodSignature argumentTypeWithEncode:[self methodReturnType]];
}

+ (JSMethodArgumentType)argumentTypeWithEncode:(const char *)encode {
    NSString *type = [NSString stringWithUTF8String:encode];
    
    if ([type isEqualToType:@encode(char)]) {
        return JSMethodArgumentTypeChar;
    } else if ([type isEqualToType:@encode(int)]) {
        return JSMethodArgumentTypeInt;
    } else if ([type isEqualToType:@encode(short)]) {
        return JSMethodArgumentTypeShort;
    } else if ([type isEqualToType:@encode(long)]) {
        return JSMethodArgumentTypeLong;
    } else if ([type isEqualToType:@encode(long long)]) {
        return JSMethodArgumentTypeLongLong;
    } else if ([type isEqualToType:@encode(unsigned char)]) {
        return JSMethodArgumentTypeUnsignedChar;
    } else if ([type isEqualToType:@encode(unsigned int)]) {
        return JSMethodArgumentTypeUnsignedInt;
    } else if ([type isEqualToType:@encode(unsigned short)]) {
        return JSMethodArgumentTypeUnsignedShort;
    } else if ([type isEqualToType:@encode(unsigned long)]) {
        return JSMethodArgumentTypeUnsignedLong;
    } else if ([type isEqualToType:@encode(unsigned long long)]) {
        return JSMethodArgumentTypeUnsignedLongLong;
    } else if ([type isEqualToType:@encode(float)]) {
        return JSMethodArgumentTypeFloat;
    } else if ([type isEqualToType:@encode(double)]) {
        return JSMethodArgumentTypeDouble;
    } else if ([type isEqualToType:@encode(BOOL)]) {
        return JSMethodArgumentTypeBool;
    } else if ([type isEqualToType:@encode(void)]) {
        return JSMethodArgumentTypeVoid;
    } else if ([type isEqualToType:@encode(char *)]) {
        return JSMethodArgumentTypeCharacterString;
    } else if ([type isEqualToType:@encode(id)]) {
        return JSMethodArgumentTypeObject;
    } else if ([type isEqualToType:@encode(Class)]) {
        return JSMethodArgumentTypeClass;
    } else if ([type isEqualToType:@encode(CGPoint)]) {
        return JSMethodArgumentTypeCGPoint;
    } else if ([type isEqualToType:@encode(CGSize)]) {
        return JSMethodArgumentTypeCGSize;
    } else if ([type isEqualToType:@encode(CGRect)]) {
        return JSMethodArgumentTypeCGRect;
    } else if ([type isEqualToType:@encode(UIEdgeInsets)]) {
        return JSMethodArgumentTypeUIEdgeInsets;
    }
    
    return JSMethodArgumentTypeUnknown;
}

- (JSMethodArgumentType)argumentTypeAtIndex:(NSInteger)index {
    const char *encode = [self getArgumentTypeAtIndex:index];
    return [NSMethodSignature argumentTypeWithEncode:encode];
}

- (NSInvocation *)invocationWithArguments:(NSArray *)arguments {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:self];
    
    if ([arguments isKindOfClass:[NSArray class]]) {
        [arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = idx + 2; // start with 2
            JSMethodArgumentType type = [self argumentTypeAtIndex:index];
            switch (type) {
                case JSMethodArgumentTypeChar: {
                    char value = [obj charValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeInt: {
                    int value = [obj intValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeShort: {
                    short value = [obj shortValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeLong: {
                    long value = [obj longValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeLongLong: {
                    long long value = [obj longLongValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeUnsignedChar: {
                    unsigned char value = [obj unsignedCharValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeUnsignedInt: {
                    unsigned int value = [obj unsignedIntValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeUnsignedShort: {
                    unsigned short value = [obj unsignedShortValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeUnsignedLong: {
                    unsigned long value = [obj unsignedLongValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeUnsignedLongLong: {
                    unsigned long long value = [obj unsignedLongLongValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeFloat: {
                    float value = [obj floatValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeDouble: {
                    double value = [obj doubleValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeBool: {
                    BOOL value = [obj boolValue];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeVoid: {
                    
                } break;
                case JSMethodArgumentTypeCharacterString: {
                    const char *value = [obj UTF8String];
                    [invocation setArgument:&value atIndex:index];
                } break;
                case JSMethodArgumentTypeObject: {
                    [invocation setArgument:&obj atIndex:index];
                } break;
                case JSMethodArgumentTypeClass: {
                    Class value = [obj class];
                    [invocation setArgument:&value atIndex:index];
                } break;
                    
                default: break;
            }
        }];
    }

    return invocation;
}

@end
