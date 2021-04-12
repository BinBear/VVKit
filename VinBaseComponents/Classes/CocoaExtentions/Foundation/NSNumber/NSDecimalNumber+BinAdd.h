//
//  NSDecimalNumber+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (BinAdd)

#pragma mark - RoundPlain
+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale;
+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale;
+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;
- (NSDecimalNumber *)roundToScale:(short)scale;
- (NSDecimalNumber *)roundToScale:(short)scale mode:(NSRoundingMode)roundingMode;

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
@end

NS_ASSUME_NONNULL_END
