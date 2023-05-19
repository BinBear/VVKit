//
//  NSString+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSString+VinKit.h"
#import "NSDecimalNumber+VinKit.h"
#import <CommonCrypto/CommonRandom.h>
#import "NSObject+VinKit.h"

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
    return [NSString vv_stringFromNumber:number
                          fractionDigits:fractionDigits
                            roundingMode:NSNumberFormatterRoundUp
                       groupingSeparator:@""];
}

+ (NSString *)vv_stringRoundDownFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    return [NSString vv_stringFromNumber:number
                          fractionDigits:fractionDigits
                            roundingMode:NSNumberFormatterRoundDown
                       groupingSeparator:@""];
}

+ (NSString *)vv_stringRoundPlainFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    return [NSString vv_stringFromNumber:number
                          fractionDigits:fractionDigits
                            roundingMode:NSNumberFormatterRoundHalfDown
                       groupingSeparator:@""];
}

+ (NSString *)vv_stringFromNumber:(NSNumber *)number
                   fractionDigits:(NSUInteger)fractionDigits
                     roundingMode:(NSNumberFormatterRoundingMode)mode
                groupingSeparator:(NSString *)separator {
    
    // NumberFormatter 使用的是 IEEE 754 格式，该格式支持的最大有效数字位数为 17 位，因此超出这个范围的数字将被舍入或填充
    
    NSString *numberString = [number stringValue];
    NSArray *numberArr = [numberString componentsSeparatedByString:@"."];
    
    NSString *prffixStr = [numberArr objectAtIndex:0];
    NSString *suffixStr = @"0";
    if (numberArr.count == 2) {
        suffixStr = [suffixStr stringByAppendingFormat:@".%@",[numberArr objectAtIndex:1]];
    }
    BOOL isMinus = [prffixStr hasPrefix:@"-"];
    NSDecimalNumber *suffixDecimal = [NSDecimalNumber decimalNumberWithString:suffixStr];
    NSRoundingMode roundMode = NSRoundDown;
    switch (mode) {
        case NSNumberFormatterRoundDown:
        case NSNumberFormatterRoundFloor:
            roundMode = isMinus ? NSRoundUp : NSRoundDown;
            break;
            
        case NSNumberFormatterRoundUp:
        case NSNumberFormatterRoundCeiling:
            roundMode = isMinus ? NSRoundDown : NSRoundUp;
            break;
            
        case NSNumberFormatterRoundHalfEven:
            roundMode = NSRoundBankers;
            break;
            
        case NSNumberFormatterRoundHalfDown:
            roundMode = NSRoundPlain;
            break;
            
        default:
            break;
    }
    
    suffixDecimal = [suffixDecimal vv_roundToScale:fractionDigits mode:roundMode];
    suffixStr = [suffixDecimal stringValue];
    // 处理小数位向整数位进1
    if (![suffixStr vv_compareIsLess:@"1"]) {
        prffixStr = isMinus ? [prffixStr vv_safeSubtracting:@"1"] : [prffixStr vv_safeAdding:@"1"];
        suffixStr = [suffixStr vv_safeSubtracting:@"1"];
        suffixDecimal = [NSDecimalNumber decimalNumberWithString:suffixStr];
        suffixDecimal = [suffixDecimal vv_roundToScale:fractionDigits mode:roundMode];
        suffixStr = [suffixDecimal stringValue];
    }
    
    NSInteger len;
    if ([suffixStr containsString:@"."]) {
        len = suffixStr.length - 2;
    } else { // suffixStr = @"0"
        len = 0;
        suffixStr = @"0.";
    }
    
    if (fractionDigits > len) {
        NSInteger count = fractionDigits - len;
        for (NSInteger i = 0; i < count; i++) {
            suffixStr = [suffixStr stringByAppendingString:@"0"];
        }
    }
    
    NSNumberFormatter *numberFormatter = [NSString vv_numberFormatterWithFractionDigits:0
                                                                           roundingMode:NSNumberFormatterRoundDown
                                                                      groupingSeparator:separator];
    NSDecimalNumber *prffixDecimal = [NSDecimalNumber decimalNumberWithString:prffixStr];
    NSString *result = [numberFormatter stringFromNumber:prffixDecimal];
    if (suffixStr.length > 0 && fractionDigits > 0) {
        if ([prffixStr hasPrefix:@"-"] && ![result hasPrefix:@"-"]) { // 特殊处理 -0.xx 这种情况的数字
            result = [@"-" stringByAppendingString:result];
        }
        suffixStr = [suffixStr stringByReplacingOccurrencesOfString:@"0." withString:@""];
        result = [result stringByAppendingFormat:@".%@",suffixStr];
    }
    return result;
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

+ (NSString *)vv_addZeroForString:(NSString *)string andLength:(NSInteger)length{
    if (![string isKindOfClass:NSString.class]) return string;
    NSMutableString *mutableStr = [NSMutableString stringWithString:string];
    while (mutableStr.length < length) {
        [mutableStr insertString:@"0" atIndex:0];
    }
    return mutableStr;
}

+ (NSString *)vv_addCommaSeparator:(id)string {
    NSDecimalNumber *formatterNum;
    NSInteger suffixLen = 0;
    if ([string isKindOfClass:NSNumber.class] ||
        [string isKindOfClass:NSDecimalNumber.class]) {
        suffixLen = vv_getDecimalDigits([string doubleValue]);
        formatterNum = [NSDecimalNumber decimalNumberWithString:vv_handleLossPrecision([string doubleValue])];
    }else if ([string isKindOfClass:NSString.class]){
        NSString *replacedStr = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
        suffixLen = [NSString vv_suffixLength:replacedStr];
        formatterNum = [NSDecimalNumber decimalNumberWithString:replacedStr];
    }
    if (!formatterNum) return @"";
    NSNumberFormatter *numberFormatter = [NSString vv_numberFormatterWithFractionDigits:suffixLen
                                                                           roundingMode:NSNumberFormatterRoundDown
                                                                      groupingSeparator:@","];
    return [numberFormatter stringFromNumber:formatterNum];
}

+ (NSString *)vv_decimalStyleNumber:(id)number {
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSNumberFormatter new];
        formatter.usesSignificantDigits = true;
        formatter.maximumSignificantDigits = 100;
        formatter.groupingSeparator = @"";
        formatter.decimalSeparator = @".";
        formatter.numberStyle = NSNumberFormatterNoStyle;
    });
    if ([number isKindOfClass:NSString.class]) {
        NSNumber *stringValue = [formatter numberFromString:number];
        return stringValue.stringValue;
    }else if ([number isKindOfClass:NSNumber.class]){
        return [formatter stringFromNumber:number];
    }
    return @"";
}

+ (NSNumberFormatter *)vv_numberFormatterWithFractionDigits:(NSInteger)fractionDigits
                                               roundingMode:(NSNumberFormatterRoundingMode)mode
                                          groupingSeparator:(NSString *)separator {
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        numberFormatter.minimumIntegerDigits = 1;
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.decimalSeparator = @".";
    });
    numberFormatter.groupingSeparator = separator;
    numberFormatter.minimumFractionDigits = fractionDigits;
    numberFormatter.maximumFractionDigits = fractionDigits;
    numberFormatter.roundingMode = mode;
    return numberFormatter;
}

+ (NSInteger)vv_suffixLength:(NSString *)string {
    NSInteger result = 0;
    if ([string containsString:@"."]) {
        result = [string componentsSeparatedByString:@"."].lastObject.length;
    }
    return result;
}

@end


@implementation NSString (Calculation)

+ (NSString *)vv_stringAbs:(NSString *)num {
    num = [NSString vv_safeString:num];
    NSDecimalNumber *absNum = [NSDecimalNumber vv_abs:[NSDecimalNumber decimalNumberWithString:num]];
    return [absNum stringValue];
}

- (NSString *)vv_safeAdding:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    num = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *addingNum = [num1 vv_adding:num2];
    return [addingNum stringValue];
}

- (NSString *)vv_safeSubtracting:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    num = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *subtractingNum = [num1 vv_subtracting:num2];
    return [subtractingNum stringValue];
}

- (NSString *)vv_safeMultiplying:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    num = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyingNum = [num1 vv_multiplying:num2];
    return [multiplyingNum stringValue];
}

- (NSString *)vv_safeDividing:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    num = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *dividingNum = [num1 vv_dividing:num2];
    return [dividingNum stringValue];
}

- (BOOL)vv_compareIsEqual:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [NSString vv_safeString:self];
    stringNumer = [NSString vv_safeString:stringNumer];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedSame;
}

- (BOOL)vv_compareIsGreater:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [NSString vv_safeString:self];
    stringNumer = [NSString vv_safeString:stringNumer];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedDescending;
}

- (BOOL)vv_compareIsLess:(NSString *)stringNumer {
    if (![self isKindOfClass:NSString.class] || ![stringNumer isKindOfClass:NSString.class]) {
        return false;
    }
    NSString *safeSelf = [NSString vv_safeString:self];
    stringNumer = [NSString vv_safeString:stringNumer];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedAscending;
}

- (NSString *)vv_safePow:(NSUInteger)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *result = [num1 vv_pow:num];
    return result.stringValue;
}

+ (NSString *)vv_safeString:(NSString *)str {
    if ([str isKindOfClass:NSString.class] && str.length > 0) {
        return str;
    }
    return @"0";
}

@end
