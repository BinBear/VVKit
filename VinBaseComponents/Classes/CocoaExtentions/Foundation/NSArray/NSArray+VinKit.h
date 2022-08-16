//
//  NSArray+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (VinKit)

/// 遍历数组元素
- (void)vv_each:(void (NS_NOESCAPE ^)(id object))block;

/// 遍历数组元素
- (void)vv_eachWithIndex:(void (NS_NOESCAPE ^)(id object, NSUInteger index))block;

/// 转换数组元素，将每个 item 都经过 block 转换成一遍 返回转换后的新数组
- (nullable NSArray *)vv_map:(id (NS_NOESCAPE ^)(id object))block;

/// 转换数组元素，将每个 item 都经过 block 转换成一遍 返回转换后的新数组
- (nullable NSArray *)vv_mapWithIndex:(id (NS_NOESCAPE ^)(NSInteger index, id item))block;

/// 过滤数组元素，将每个 item 都经过 block 过滤一遍 返回过滤后的新数组
- (nullable NSArray *)vv_filter:(BOOL (NS_NOESCAPE ^)(id object))block;

/// 不需要过滤的数组元素，将每个 item 都经过 block 过滤一遍 返回过滤后的新数组
- (nullable NSArray *)vv_reject:(BOOL (NS_NOESCAPE ^)(id object))block;

/// 过滤单个元素，将每个 item 都经过 block 过滤 返回过滤后的单元素
- (nullable id)vv_detect:(BOOL (NS_NOESCAPE ^)(id object))block;

/// 累加数组元素，将每个 item 都经过 block 累加 返回累加后的单元素
- (nullable id)vv_reduce:(id (NS_NOESCAPE ^)(id accumulator, id object))block;

/// 累加数组元素，将每个 item 都经过 block 累加 返回累加后的单元素
- (nullable id)vv_reduce:(id _Nullable)initial block:(id (NS_NOESCAPE ^)(id _Nullable accumulator, id object))block;

/// 将数组转换成json字符串,key进行升序排序
- (nullable NSString *)vv_jsonStringEncoded;

/// 将数组转换成json字符串，格式化输出，即输出后的字符串有换行符\n
- (nullable NSString *)vv_jsonPrettyStringEncoded;

@end


@interface NSArray (VinSort)

/// 二分查找（循环）
- (NSInteger)vv_bsearchWithLoop:(NSString *)propertyName value:(double)value;

/// 二分查找（递归）
- (NSInteger)vv_bsearchWithRecursion:(NSString *)propertyName value:(double)value;

/// 二分查找第一个给定值（循环）
- (NSInteger)vv_bsearchFirstItemWithLoop:(NSString *)propertyName value:(double)value;

/// 二分查找最后一个给定值（循环）
- (NSInteger)vv_bsearchLastItemWithLoop:(NSString *)propertyName value:(double)value;

/// 二分查找第一个大于等于给定值（循环）
- (NSInteger)vv_bsearchMoreWithLoop:(NSString *)propertyName value:(double)value;

/// 二分查找最后一个小于等于给定值的元素（循环）
- (NSInteger)vv_bsearchLessWithLoop:(NSString *)propertyName value:(double)value;

@end

NS_ASSUME_NONNULL_END
