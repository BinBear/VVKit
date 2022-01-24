//
//  NSDictionary+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (VinKit)

/// 合并两个NSDictionary
+ (NSDictionary *)vv_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

/// 并入一个NSDictionary
- (NSDictionary *)vv_dictionaryByMergingWith:(NSDictionary *)dict;

/// 将字典转换成json字符串
- (nullable NSString *)vv_jsonStringEncoded;

/// 将字典转换成json字符串,key进行升序排序
- (nullable NSString *)vv_jsonSortKeyStringEncoded;

/// 将字典转换成json字符串，格式化输出，即输出后的字符串有换行符\n
- (nullable NSString *)vv_jsonPrettyStringEncoded;

@end

NS_ASSUME_NONNULL_END
