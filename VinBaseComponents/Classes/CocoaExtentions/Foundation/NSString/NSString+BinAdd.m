//
//  NSString+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "NSString+BinAdd.h"
#import "NSDecimalNumber+BinAdd.h"

@implementation NSString (BinAdd)

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
#pragma mark - RoundNumber
+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded {
    return [NSString stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded {
    return [NSString stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    return [NSString stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [NSString _numberFormatterWithFractionDigits:fractionDigits
                                                                         roundingMode:NSNumberFormatterRoundDown];
    return [numberFormatter stringFromNumber:number];
}
+ (NSString *)stringRoundPlainFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
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

+ (NSString *)deleteSuffixAllZero:(NSString *) string {
    NSArray * arrStr=[string componentsSeparatedByString:@"."];
    NSString *str=arrStr.firstObject;
    NSString *str1=arrStr.lastObject;
    while ([str1 hasSuffix:@"0"]) {
        str1=[str1 substringToIndex:(str1.length-1)];
    }
    return (str1.length>0)?[NSString stringWithFormat:@"%@.%@",str,str1]:str;
}

+ (NSString *)addZeroForString:(NSString *) string andLength:(NSInteger)length{
    NSMutableString *mutableStr = [NSMutableString stringWithString:string];
    while (mutableStr.length < length) {
        [mutableStr insertString:@"0" atIndex:0];
    }
    return mutableStr;
}
@end
