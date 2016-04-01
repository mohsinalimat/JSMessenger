//
//  JSMJSONHelper.h
//  JSMessenger
//
//  Created by cyan on 15/12/12.
//  Copyright © 2015年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSMJSONHelper : NSObject

id JSONObjectWithData(NSData *data);
id JSONObjectWithString(NSString *string);

NSData *JSONDataWithObject(id object);
NSString *JSONStringWithObject(id object);

@end
