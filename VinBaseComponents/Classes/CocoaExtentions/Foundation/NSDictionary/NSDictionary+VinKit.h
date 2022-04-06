//
//  NSDictionary+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (VinKit)

/// 遍历字典
- (void)vv_each:(void (NS_NOESCAPE ^)(id key, id value))block;

/// 遍历字典的keys
- (void)vv_eachKey:(void (NS_NOESCAPE ^)(id key))block;

/// 遍历字典的values
- (void)vv_eachValue:(void (NS_NOESCAPE ^)(id value))block;

/// 转换字典，返回转换后的数组
- (NSArray *)vv_map:(id (NS_NOESCAPE ^)(id key, id value))block;

/// 根据key数组，返回包含这些key的新的字典
- (NSDictionary *)vv_pick:(NSArray *)keys;

/// 根据key数组，返回不包含这些key的新的字典
- (NSDictionary *)vv_omit:(NSArray *)keys;

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
