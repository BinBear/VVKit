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

@end
