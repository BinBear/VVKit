//
//  NSArray+VinKit.h
//  HotCoin
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (VinKit)

/// 转换数组元素，将每个 item 都经过 block 转换成一遍 返回转换后的新数组
- (NSArray *)vv_mapWithBlock:(id (NS_NOESCAPE^)(NSInteger index, id item))block;

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
