//
//  NSURL+VinKit.h
//  VinBaseComponents_Example
//
//  Created by vin on 2022/8/13.
//  Copyright © 2022 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (VinKit)

/// 解析URL,将URL中的参数解析为字典
- (nullable NSMutableDictionary *)vv_urlToParameter;

/// 删除URL参数中某个参数
- (NSString *)vv_removeParaKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
