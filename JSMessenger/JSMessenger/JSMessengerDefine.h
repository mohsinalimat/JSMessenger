//
//  JSMessengerDefine.h
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#ifndef JSMessengerDefine_h
#define JSMessengerDefine_h

typedef void (^JSMJavaScriptEvaluateBlock) (id result);

#define JSM_CONTACT2(a, b)              a ## b
#define JSM_CONTACT(a, b)               JSM_CONTACT2(a, b)

#define JSMessengerExportClass(clazz) \
+ (NSString *)JSM_CONTACT(__jsm_export__, clazz) { \
    return @""#clazz;\
}

#define JSMessengerExportMethod(method) _JSMessengerExportMethod(, method)
#define _JSMessengerExportMethod(name, method) \
+ (NSString *)JSM_CONTACT(__jsm_export__, JSM_CONTACT(name, JSM_CONTACT(__LINE__, __COUNTER__))) { \
    return NSStringFromSelector(method);\
}

#endif /* JSMessengerDefine_h */
