//
//  NSDecimalNumber+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (VinKit)

#pragma mark - RoundPlain
+ (NSDecimalNumber *)vv_decimalNumberWithFloat:(float)value roundingScale:(short)scale;
+ (NSDecimalNumber *)vv_decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
+ (NSDecimalNumber *)vv_decimalNumberWithDouble:(double)value roundingScale:(short)scale;
+ (NSDecimalNumber *)vv_decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
- (NSDecimalNumber *)vv_roundToScale:(short)scale;
- (NSDecimalNumber *)vv_roundToScale:(short)scale mode:(NSRoundingMode)roundingMode;

#pragma mark - Calculation
/**
 取绝对值

 @param num 数值
 @return 取绝对值后的值
 */
+ (NSDecimalNumber *)vv_abs:(NSDecimalNumber *)num;

/**
 两数相加

 @param num 加的数
 @return 相加后的数
 */
- (NSDecimalNumber *)vv_safeDecimalNumberByAdding:(NSDecimalNumber *)num;
/**
 两数相减
 
 @param num 减的数
 @return 相减后的数
 */
- (NSDecimalNumber *)vv_safeDecimalNumberBySubtracting:(NSDecimalNumber *)num;
/**
 两数相乘
 
 @param num 乘的数
 @return 相乘后的数
 */
- (NSDecimalNumber *)vv_safeDecimalNumberByMultiplying:(NSDecimalNumber *)num;
/**
 两数相除
 
 @param num 除的数
 @return 相除后的数
 */
- (NSDecimalNumber *)vv_safeDecimalNumberByDividing:(NSDecimalNumber *)num;
/**
 幂
 
 @param num 次
 @return 结果
 */
- (NSDecimalNumber *)vv_pow:(NSUInteger)num;
@end

NS_ASSUME_NONNULL_END
