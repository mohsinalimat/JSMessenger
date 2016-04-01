//
//  JSMJSONHelper.m
//  JSMessenger
//
//  Created by cyan on 15/12/12.
//  Copyright © 2015年 cyan. All rights reserved.
//

#import "JSMJSONHelper.h"

@implementation JSMJSONHelper

id JSONObjectWithData(NSData *data) {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        return object;
    } else {
        NSLog(@"JSON Error #0: %@", error.localizedDescription);
        return nil;
    }
}

id JSONObjectWithString(NSString *string) {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return JSONObjectWithData(data);
}

NSData *JSONDataWithObject(id object) {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (!error) {
        return data;
    } else {
        NSLog(@"JSON Error #1: %@", error.localizedDescription);
        return nil;
    }
}

NSString *JSONStringWithObject(id object) {
    NSData *data = JSONDataWithObject(object);
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

NSString *JSONEscape(NSString *json) {
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    json = [json stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    json = [json stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    json = [json stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    json = [json stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    return json;
}

@end
