//
//  NSDecimalNumber+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSDecimalNumber+VinKit.h"

@implementation NSDecimalNumber (VinKit)

+ (NSDecimalNumber *)vv_decimalNumberWithFloat:(float)value roundingScale:(short)scale{
    return [[[NSDecimalNumber alloc] initWithFloat:value] vv_roundToScale:scale];
}

+ (NSDecimalNumber *)vv_decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode{
    return [[[NSDecimalNumber alloc] initWithFloat:value] vv_roundToScale:scale mode:mode];
}

+ (NSDecimalNumber *)vv_decimalNumberWithDouble:(double)value roundingScale:(short)scale{
    return [[[NSDecimalNumber alloc] initWithDouble:value] vv_roundToScale:scale];
}

+ (NSDecimalNumber *)vv_decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode{
    return [[[NSDecimalNumber alloc] initWithDouble:value] vv_roundToScale:scale mode:mode];
}

- (NSDecimalNumber *)vv_roundToScale:(short)scale{
    return [self vv_roundToScale:scale mode:NSRoundPlain];
}

- (NSDecimalNumber *)vv_roundToScale:(short)scale mode:(NSRoundingMode)roundingMode{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode
                                                                                             scale:scale
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:YES
                                                                                  raiseOnUnderflow:YES
                                                                               raiseOnDivideByZero:YES];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

@end


@implementation NSDecimalNumber (Calculation)

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
- (NSDecimalNumber *)vv_adding:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberByAdding:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_subtracting:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberBySubtracting:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_multiplying:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberByMultiplyingBy:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_dividing:(NSDecimalNumber *)num{
    if (![num isEqualToNumber:NSDecimalNumber.notANumber] && ![num isEqualToNumber:NSDecimalNumber.zero] && ![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return  [self decimalNumberByDividingBy:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}
- (NSDecimalNumber *)vv_pow:(NSUInteger)num {
    if (![self isEqualToNumber:NSDecimalNumber.notANumber]) {
        return [self decimalNumberByRaisingToPower:num];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}

@end
