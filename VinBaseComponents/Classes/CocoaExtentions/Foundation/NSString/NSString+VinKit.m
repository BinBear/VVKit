//
//  NSString+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSString+VinKit.h"
#import "NSDecimalNumber+VinKit.h"
#import <CommonCrypto/CommonRandom.h>

@implementation NSString (VinKit)

+ (instancetype)vv_stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    outStr = [outStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    outStr = [outStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    return outStr;
}
- (instancetype)vv_stringByAppendingString:(NSString *)format {
    
    NSString *outStr = @"";
    NSString *formatStr = @"";
    
    formatStr = [format stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    outStr = [self stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    outStr = [self stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    outStr = [outStr stringByAppendingString:formatStr];
    
    return outStr;
}
+ (NSString *)vv_randomString:(NSInteger)length {
    NSInteger len = length * 0.5;
    if (len <= 0) { return @""; }
    unsigned char digest[len];
    CCRNGStatus status = CCRandomGenerateBytes(digest, len);
    NSString *str = @"";
    if (status == kCCSuccess) {
        NSMutableString *mutaStr = [NSMutableString string];
        for (NSInteger i = 0; i < len; i++) {
            [mutaStr appendFormat:@"%02x",digest[i]];
        }
        str = [mutaStr copy];
    }
    return str;
}

@end


@implementation NSString (RoundNumber)

+ (NSString *)vv_stringFromFloat:(float)value
                   roundingScale:(short)scale
            fractionDigitsPadded:(BOOL)isPadded {
    return [NSString vv_stringFromFloat:value
                          roundingScale:scale
                           roundingMode:NSRoundPlain
                   fractionDigitsPadded:isPadded];
}

+ (NSString *)vv_stringFromFloat:(float)value
                   roundingScale:(short)scale
                    roundingMode:(NSRoundingMode)mode
            fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithFloat:value
                                                                  roundingScale:scale
                                                                   roundingMode:mode];
    
    if (!isPadded) return [NSString vv_stringWithFormat:@"%@", decimalNumber];
    
    return [NSString vv_stringRoundDownFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)vv_stringFromFloat:(float)value
                   roundingScale:(short)scale
                    roundingMode:(NSRoundingMode)mode
                  fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithFloat:value
                                                                  roundingScale:scale
                                                                   roundingMode:mode];
    return [NSString vv_stringRoundDownFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)vv_stringFromDouble:(double)value
                    roundingScale:(short)scale
             fractionDigitsPadded:(BOOL)isPadded {
    return [NSString vv_stringFromDouble:value
                           roundingScale:scale
                            roundingMode:NSRoundPlain
                    fractionDigitsPadded:isPadded];
}

+ (NSString *)vv_stringFromDouble:(double)value
                    roundingScale:(short)scale
                     roundingMode:(NSRoundingMode)mode
             fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithDouble:value
                                                                   roundingScale:scale
                                                                    roundingMode:mode];
    
    if (!isPadded) return [NSString vv_stringWithFormat:@"%@", decimalNumber];
    
    return [NSString vv_stringRoundDownFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)vv_stringFromDouble:(double)value
                    roundingScale:(short)scale
                     roundingMode:(NSRoundingMode)mode
                   fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithDouble:value
                                                                   roundingScale:scale
                                                                    roundingMode:mode];
    return [NSString vv_stringRoundDownFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)vv_stringRoundUpFromNumber:(NSNumber *)number
                          fractionDigits:(NSUInteger)fractionDigits {

    NSNumberFormatter *numberFormatter = [NSString _numberFormatterWithFractionDigits:fractionDigits
                                                                         roundingMode:NSNumberFormatterRoundUp];
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)vv_stringRoundDownFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [NSString _numberFormatterWithFractionDigits:fractionDigits
                                                                         roundingMode:NSNumberFormatterRoundDown];
    return [numberFormatter stringFromNumber:number];
}
+ (NSString *)vv_stringRoundPlainFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [NSString _numberFormatterWithFractionDigits:fractionDigits
                                                                         roundingMode:NSNumberFormatterRoundCeiling];
    return [numberFormatter stringFromNumber:number];
}

+ (NSNumberFormatter *)_numberFormatterWithFractionDigits:(NSInteger)fractionDigits
                                             roundingMode:(NSNumberFormatterRoundingMode)mode{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        numberFormatter.minimumIntegerDigits = 1;
        numberFormatter.groupingSeparator = @"";
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.decimalSeparator = @".";
    });
    numberFormatter.minimumFractionDigits = fractionDigits;
    numberFormatter.maximumFractionDigits = fractionDigits;
    numberFormatter.roundingMode = mode;
    return numberFormatter;
}

+ (NSString *)vv_deleteSuffixAllZero:(NSString *)string {
    if (![string isKindOfClass:NSString.class] || ![string containsString:@"."]) return string;
    NSArray *arrStr = [string componentsSeparatedByString:@"."];
    if (arrStr.count != 2) return string;
    NSString *prefixStr = arrStr.firstObject;
    NSString *suffixStr = arrStr.lastObject;
    while ([suffixStr hasSuffix:@"0"]) {
        suffixStr = [suffixStr substringToIndex:(suffixStr.length-1)];
    }
    return (suffixStr.length>0)?[NSString stringWithFormat:@"%@.%@",prefixStr,suffixStr]:prefixStr;
}

+ (NSString *)vv_addZeroForString:(NSString *) string andLength:(NSInteger)length{
    if (![string isKindOfClass:NSString.class]) return string;
    NSMutableString *mutableStr = [NSMutableString stringWithString:string];
    while (mutableStr.length < length) {
        [mutableStr insertString:@"0" atIndex:0];
    }
    return mutableStr;
}


@end


@implementation NSString (Calculation)

+ (NSString *)vv_stringAbs:(NSString *)num {
    num = [NSString _safeString:num];
    NSDecimalNumber *absNum = [NSDecimalNumber vv_abs:[NSDecimalNumber decimalNumberWithString:num]];
    return [absNum stringValue];
}

- (NSString *)vv_safeAdding:(NSString *)num {
    NSString *safeSelf = [NSString _safeString:self];
    num = [NSString _safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *addingNum = [num1 vv_adding:num2];
    return [addingNum stringValue];
}

- (NSString *)vv_safeSubtracting:(NSString *)num {
    NSString *safeSelf = [NSString _safeString:self];
    num = [NSString _safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *subtractingNum = [num1 vv_subtracting:num2];
    return [subtractingNum stringValue];
}

- (NSString *)vv_safeMultiplying:(NSString *)num {
    NSString *safeSelf = [NSString _safeString:self];
    num = [NSString _safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyingNum = [num1 vv_multiplying:num2];
    return [multiplyingNum stringValue];
}

- (NSString *)vv_safeDividing:(NSString *)num {
    NSString *safeSelf = [NSString _safeString:self];
    num = [NSString _safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *dividingNum = [num1 vv_dividing:num2];
    return [dividingNum stringValue];
}

- (BOOL)vv_compareIsEqual:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [NSString _safeString:self];
    stringNumer = [NSString _safeString:stringNumer];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedSame;
}

- (BOOL)vv_compareIsGreater:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [NSString _safeString:self];
    stringNumer = [NSString _safeString:stringNumer];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedDescending;
}

- (BOOL)vv_compareIsLess:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [NSString _safeString:self];
    stringNumer = [NSString _safeString:stringNumer];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedAscending;
}

- (NSString *)vv_safePow:(NSUInteger)num {
    NSString *safeSelf = [NSString _safeString:self];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *result = [num1 vv_pow:num];
    return result.stringValue;
}

+ (NSString *)_safeString:(NSString *)str {
    if ([str isKindOfClass:NSString.class] && str.length > 0) {
        return str;
    }
    return @"0";
}

@end
