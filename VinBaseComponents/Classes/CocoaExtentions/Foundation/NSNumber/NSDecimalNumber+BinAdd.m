//
//  NSDecimalNumber+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "NSDecimalNumber+BinAdd.h"

@implementation NSDecimalNumber (BinAdd)

#pragma mark - RoundPlain
+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale
{
    return [[[NSDecimalNumber alloc] initWithFloat:value] roundToScale:scale];
}

+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [[[NSDecimalNumber alloc] initWithFloat:value] roundToScale:scale mode:mode];
}

+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale
{
    return [[[NSDecimalNumber alloc] initWithDouble:value] roundToScale:scale];
}

+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [[[NSDecimalNumber alloc] initWithDouble:value] roundToScale:scale mode:mode];
}
- (NSDecimalNumber *)roundToScale:(short)scale
{
    return [self roundToScale:scale mode:NSRoundPlain];
}

- (NSDecimalNumber *)roundToScale:(short)scale mode:(NSRoundingMode)roundingMode
{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

#pragma mark - Calculation
+ (NSDecimalNumber *)vv_abs:(NSDecimalNumber *)num {
    if ([num compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
        
        NSDecimalNumber * negativeOne = [NSDecimalNumber decimalNumberWithMantissa:1
                                                                          exponent:0
                                                                        isNegative:YES];
        return [num decimalNumberByMultiplyingBy:negativeOne];
    } else {
        return num;
    }
}
- (NSDecimalNumber *)vv_safeDecimalNumberByAdding:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberByAdding:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_safeDecimalNumberBySubtracting:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberBySubtracting:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_safeDecimalNumberByMultiplying:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberByMultiplyingBy:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_safeDecimalNumberByDividing:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![num isEqualToNumber:NSDecimalNumber.zero] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberByDividingBy:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
@end
