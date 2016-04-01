//
//  NSMethodSignature+JSMExtension.h
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Objective-C Type Encoding: http://nshipster.com/type-encodings/

typedef NS_ENUM(NSInteger, JSMethodArgumentType) {
    JSMethodArgumentTypeUnknown             = 0,
    JSMethodArgumentTypeChar,
    JSMethodArgumentTypeInt,
    JSMethodArgumentTypeShort,
    JSMethodArgumentTypeLong,
    JSMethodArgumentTypeLongLong,
    JSMethodArgumentTypeUnsignedChar,
    JSMethodArgumentTypeUnsignedInt,
    JSMethodArgumentTypeUnsignedShort,
    JSMethodArgumentTypeUnsignedLong,
    JSMethodArgumentTypeUnsignedLongLong,
    JSMethodArgumentTypeFloat,
    JSMethodArgumentTypeDouble,
    JSMethodArgumentTypeBool,
    JSMethodArgumentTypeVoid,
    JSMethodArgumentTypeCharacterString,
    JSMethodArgumentTypeCGPoint,
    JSMethodArgumentTypeCGSize,
    JSMethodArgumentTypeCGRect,
    JSMethodArgumentTypeUIEdgeInsets,
    JSMethodArgumentTypeObject,
    JSMethodArgumentTypeClass
};

@interface NSMethodSignature (JSMExtension)

/**
 *  NSMethodSignature return type
 *
 *  @return type
 */
- (JSMethodArgumentType)returnType;

/**
 *  Argument type at index
 *
 *  @param index index
 *
 *  @return argument type
 */
- (JSMethodArgumentType)argumentTypeAtIndex:(NSInteger)index;

/**
 *  Argument type with encode
 *
 *  @param encode encode
 *
 *  @return argument type
 */
+ (JSMethodArgumentType)argumentTypeWithEncode:(const char *)encode;

/**
 *  Get invocation with args list
 *
 *  @param arguments arguments
 *
 *  @return NSInvocation
 */
- (NSInvocation *)invocationWithArguments:(NSArray *)arguments;

@end
