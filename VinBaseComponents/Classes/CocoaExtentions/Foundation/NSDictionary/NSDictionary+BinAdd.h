//
//  NSDictionary+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (BinAdd)

#pragma mark - Dictionary Convertor
/**
 * 将属性列表数据转换为 NSDictionary 返回。
 */
+ (nullable NSDictionary *)dictionaryWithPlistData:(NSData *)plist;

/**
 * 将xml格式的属性列表字符串转换为 NSDictionary 返回。
 */
+ (nullable NSDictionary *)dictionaryWithPlistString:(NSString *)plist;

/**
 * 将字典转换为二进制的属性列表数据。
 */
- (nullable NSData *)plistData;

/**
 * 将字典转换为xml格式的属性列表字符串。
 */
- (nullable NSString *)plistString;

/**
 * 返回一个包含字典所有 key 的升序数组，key 必须为 NSString。
 */
- (NSArray *)allKeysSorted;

/**
 * 返回一个包含字典所有的 value 数组，数组 value 的顺序对应字典所有 key 的升序数组，key 必须为 NSString。
 */
- (NSArray *)allValuesSortedByKeys;

/**
 * 判断 key 对应的 value 是否不为 nil 。
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 * 返回一个新的字典，该字典包含原字典所有 keys 及它们对应的值。
 */
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

/**
 * 字典转为 json 字符串，错误返回 nil 。
 */
- (nullable NSString *)jsonStringEncoded;

/**
 * 字典转为格式化后的 json 字符串，错误返回 nil，这样可读性高，不格式化则输出的 json 字符串就是一整行。
 */
- (nullable NSString *)jsonPrettyStringEncoded;

/**
 * 将 NSData 或 NSString 类型的 XML 数据转成字典。
 */
+ (nullable NSDictionary *)dictionaryWithXML:(id)xmlDataOrString;


#pragma mark - Merge
/**
 *  @brief  合并两个NSDictionary
 *
 *  @param dict1 NSDictionary
 *  @param dict2 NSDictionary
 *
 *  @return 合并后的NSDictionary
 */
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;
/**
 *  @brief  并入一个NSDictionary
 *
 *  @param dict NSDictionary
 *
 *  @return 增加后的NSDictionary
 */
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
