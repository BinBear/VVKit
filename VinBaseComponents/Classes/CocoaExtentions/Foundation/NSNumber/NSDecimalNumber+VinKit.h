//
//  NSDecimalNumber+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (VinKit)

/// 根据相应精度将float类型的数据转换为NSDecimalNumber，默认截取模式为NSRoundPlain，四舍五入
/// @param value 转换的值
/// @param scale 转换的精度
+ (NSDecimalNumber *)vv_decimalNumberWithFloat:(float)value roundingScale:(short)scale;

/// 根据相应精度将float类型的数据转换为NSDecimalNumber
/// @param value 转换的值
/// @param scale 转换的精度
/// @param mode  转换的模式
+ (NSDecimalNumber *)vv_decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

/// 根据相应精度将double类型的数据转换为NSDecimalNumber，默认截取模式为NSRoundPlain，四舍五入
/// @param value 转换的值
/// @param scale 转换的精度
+ (NSDecimalNumber *)vv_decimalNumberWithDouble:(double)value roundingScale:(short)scale;

/// 根据相应精度将float类型的数据转换为NSDecimalNumber
/// @param value 转换的值
/// @param scale 转换的精度
/// @param mode  转换的模式
+ (NSDecimalNumber *)vv_decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

/// 将NSDecimalNumber处理相应的精度
/// @param scale 转换的精度
- (NSDecimalNumber *)vv_roundToScale:(short)scale;

/// 将NSDecimalNumber处理相应的精度
/// @param scale  转换的精度
/// @param mode   转换的模式
- (NSDecimalNumber *)vv_roundToScale:(short)scale mode:(NSRoundingMode)mode;

@end

@interface NSDecimalNumber (Calculation)

/// 取绝对值
/// @param num 数值
+ (NSDecimalNumber *)vv_abs:(NSDecimalNumber *)num;

/// 两数相加
/// @param num 数值
- (NSDecimalNumber *)vv_adding:(NSDecimalNumber *)num;

/// 两数相减
/// @param num 数值
- (NSDecimalNumber *)vv_subtracting:(NSDecimalNumber *)num;

/// 两数相乘
/// @param num 数值
- (NSDecimalNumber *)vv_multiplying:(NSDecimalNumber *)num;

/// 两数相除
/// @param num 数值
- (NSDecimalNumber *)vv_dividing:(NSDecimalNumber *)num;

/// 幂
/// @param num 次
- (NSDecimalNumber *)vv_pow:(NSUInteger)num;

@end

NS_ASSUME_NONNULL_END
