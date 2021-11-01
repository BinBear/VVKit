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

#pragma mark - RoundNumber
+ (NSString *)vv_stringFromFloat:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded {
    return [NSString vv_stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)vv_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString vv_stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)vv_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString vv_stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)vv_stringFromDouble:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded {
    return [NSString vv_stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)vv_stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString vv_stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)vv_stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber vv_decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    return [NSString vv_stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)vv_stringRoundUpFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {

    NSNumberFormatter *numberFormatter = [NSString _numberFormatterWithFractionDigits:fractionDigits
                                                                         roundingMode:NSNumberFormatterRoundUp];
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)vv_stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
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

+ (NSString *)vv_deleteSuffixAllZero:(NSString *) string {
    NSArray * arrStr=[string componentsSeparatedByString:@"."];
    NSString *str=arrStr.firstObject;
    NSString *str1=arrStr.lastObject;
    while ([str1 hasSuffix:@"0"]) {
        str1=[str1 substringToIndex:(str1.length-1)];
    }
    return (str1.length>0)?[NSString stringWithFormat:@"%@.%@",str,str1]:str;
}

+ (NSString *)vv_addZeroForString:(NSString *) string andLength:(NSInteger)length{
    NSMutableString *mutableStr = [NSMutableString stringWithString:string];
    while (mutableStr.length < length) {
        [mutableStr insertString:@"0" atIndex:0];
    }
    return mutableStr;
}

#pragma mark - Calculation
+ (NSString *)vv_stringAbs:(NSString *)num {
    num = [num _safeString];
    NSDecimalNumber *absNum = [NSDecimalNumber vv_abs:[NSDecimalNumber decimalNumberWithString:num]];
    return [absNum stringValue];
}

- (NSString *)vv_safeAdding:(NSString *)num {
    NSString *safeSelf = [self _safeString];
    num = [num _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *addingNum = [num1 vv_safeDecimalNumberByAdding:num2];
    return [addingNum stringValue];
}

- (NSString *)vv_safeSubtracting:(NSString *)num {
    NSString *safeSelf = [self _safeString];
    num = [num _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *subtractingNum = [num1 vv_safeDecimalNumberBySubtracting:num2];
    return [subtractingNum stringValue];
}

- (NSString *)vv_safeMultiplying:(NSString *)num {
    NSString *safeSelf = [self _safeString];
    num = [num _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyingNum = [num1 vv_safeDecimalNumberByMultiplying:num2];
    return [multiplyingNum stringValue];
}

- (NSString *)vv_safeDividing:(NSString *)num {
    NSString *safeSelf = [self _safeString];
    num = [num _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *dividingNum = [num1 vv_safeDecimalNumberByDividing:num2];
    return [dividingNum stringValue];
}

- (BOOL)vv_compareIsEqual:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [self _safeString];
    stringNumer = [stringNumer _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedSame;
}

- (BOOL)vv_compareIsGreater:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [self _safeString];
    stringNumer = [stringNumer _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedDescending;
}

- (BOOL)vv_compareIsLess:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [self _safeString];
    stringNumer = [stringNumer _safeString];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedAscending;
}

- (NSString *)_safeString {
    if ([self isKindOfClass:NSString.class] && self.length > 0) {
        return self;
    }
    return @"0";
}
@end
