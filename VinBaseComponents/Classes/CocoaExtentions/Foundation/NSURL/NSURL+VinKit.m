//
//  NSURL+VinKit.m
//  VinBaseComponents_Example
//
//  Created by vin on 2022/8/13.
//  Copyright © 2022 BinBear. All rights reserved.
//

#import "NSURL+VinKit.h"

@implementation NSURL (VinKit)

/// 解析URL,将URL中的参数解析为字典
- (nullable NSMutableDictionary *)vv_urlToParameter {
    if (!self || ![self isKindOfClass:NSURL.class]) return nil;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    // 传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    // 回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value && obj.name) {
            [parm setValue:obj.value forKey:obj.name];
        }
    }];
    return parm;
}

/// 删除URL参数中某个参数
- (NSString *)vv_removeParaKey:(NSString *)key {
    if (!self || ![self isKindOfClass:NSURL.class]) return nil;
    NSString *finalStr = [NSString string];
    NSArray *strArray = [self.absoluteString componentsSeparatedByString:key];
    NSMutableString *firstStr = strArray.firstObject;
    NSMutableString *lastStr = strArray.lastObject;
    NSRange characterRange = [lastStr rangeOfString:@"&"];
    if (characterRange.location != NSNotFound) {
        NSArray *lastArray = [lastStr componentsSeparatedByString:@"&"];
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:lastArray];
        if (mutArray.count > 1) {
            [mutArray removeObjectAtIndex:0];
        }
        NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"];
        finalStr = [firstStr stringByAppendingString:modifiedStr];
    } else {
        // 以'?'、'&'结尾
        if (firstStr.length > 1) {
            finalStr = [firstStr substringToIndex:firstStr.length - 1];
        } else {
            finalStr = firstStr;
        }
    }
    return finalStr;
}

@end
