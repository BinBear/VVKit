//
//  HTJSON.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * JSON格式示例:
 *
 * if ([JSONDictionary[@"data"] isKindOfClass:[NSDictionary class]]) {
 *     NSDictionary *data = JSONDictionary[@"data"];
 *     if ([data[@"user"] isKindOfClass:[NSStriNSDictionaryng class]]) {
 *         NSDictionary *data = data[@"user"];
 *         if ([data[@"userName"] isKindOfClass:[NSString class]]) {
 *
 *         }
 *     }
 * }
 * 使用方法:
 *
 * HTJSONMake(JSONDictionary)[@"data"][@"user"][@"userName"].string
 *
 *
 */


@interface HTJSON : NSObject

/**
 *  要初始化这个实例，JSONObject必须是有效的JSON类型或nil
 */
@property (nonatomic, copy, readonly, nullable) id JSONObject;

/**
 *  检索JSONObject的字典值。如果JSONObject不是字典，返回nil
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary *dictionary;

/**
 *  检索JSONObject的数组值。如果JSONObject不是数组，返回nil
 */
@property (nonatomic, copy, readonly, nullable) NSArray *array;

/**
 *  检索JSONObject的字符串值。如果JSONObject既不是字符串也不是数字，则返回nil
 */
@property (nonatomic, copy, readonly, nullable) NSString *string;

/**
 *  检索JSONObject的数值。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效数字，则返回nil
 */
@property (nonatomic, copy, readonly, nullable) NSNumber *number;

/**
 *  检索JSONObject的整数值。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效数字，则返回0
 */
@property (nonatomic, readonly) NSInteger integerValue;

/**
 *  检索JSONObject的double。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效数字，则返回0
 */
@property (nonatomic, readonly) double doubleValue;

/**
 *  检索JSONObject的浮点值。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效数字，则返回0
 */
@property (nonatomic, readonly) float floatValue;

/**
 *  检索JSONObject的int(32位)值。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效数字，则返回0
 */
@property (nonatomic, readonly) int intValue;

/**
 *  检索JSONObject的布尔值。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效的布尔值，则返回NO
 */
@property (nonatomic, readonly) BOOL boolValue;

/**
 *  检索JSONObject的int(64位)值。如果JSONObject既不是数字也不是字符串，或者JSONObject是字符串但不能转换为有效数字，则返回0
 */
@property (nonatomic, readonly) int64_t longLongValue;

/**
 *  从JSON对象创建一个IDCMJSON实例
 * @param JSONObject 有效的JSON对象
 * @return 新创建的IDCMJSON实例
 */
- (instancetype)initWithJSONObject:(nullable id)JSONObject;

/**
 * 此方法的存在是为了使方括号语法可用并可链接。它返回一个新创建的IDCMJSON实例，该实例具有JSONObject中指定键的值
 * 如果JSONObject不是字典，这个方法只返回nil
 * @param key 该键将用于从JSONObject字典检索值
 * @return 返回一个新创建的IDCMJSON实例，该实例具有JSONObject字典中指定键的值
 */
- (nullable instancetype)objectForKeyedSubscript:(NSString *)key;

@end

/**
 * 简短初始化
 * @param JSONObject 类似: -[IDCMJSON initWithJSONObject:]
 * @return 类似: -[IDCMJSON initWithJSONObject:]
 */
HTJSON *HTJSONMake(id _Nullable JSONObject);

NS_ASSUME_NONNULL_END
