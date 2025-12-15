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

    va_list args;
    va_start(args, format);
    NSMutableString *outStr = [[NSMutableString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    // 只在必要时做替换，使用 NSLiteralSearch 更快（逐字匹配）
    if (([outStr rangeOfString:@"(null)" options:NSLiteralSearch].location != NSNotFound)) {
        NSRange wholeRange = NSMakeRange(0, outStr.length);
        [outStr replaceOccurrencesOfString:@"(null)"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:wholeRange];
    }
    
    if (([outStr rangeOfString:@"<null>" options:NSLiteralSearch].location != NSNotFound)) {
        NSRange wholeRange = NSMakeRange(0, outStr.length);
        [outStr replaceOccurrencesOfString:@"<null>"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:wholeRange];
    }
    
    return [outStr copy];
    
//    if (format == nil) return @"";
//    
//    va_list args;
//    va_start(args, format);
//    // 使用 CFStringCreateWithFormatAndArguments 来格式化（比 ObjC 消息稍轻）
//    CFStringRef cfFormatted = CFStringCreateWithFormatAndArguments(NULL, NULL, (__bridge CFStringRef)format, args);
//    va_end(args);
//    
//    if (!cfFormatted) {
//        return @"";
//    }
//    
//    // 计算用于存放 UTF-8 字节的最大字节数并分配输入缓冲
//    CFIndex cfLen = CFStringGetLength(cfFormatted);
//    CFIndex maxBytes = CFStringGetMaximumSizeForEncoding(cfLen, kCFStringEncodingUTF8) + 1;
//    char *inBuf = (char *)malloc((size_t)maxBytes);
//    if (!inBuf) {
//        CFRelease(cfFormatted);
//        return (__bridge_transfer NSString *)cfFormatted; // 回退到直接返回格式化结果
//    }
//    
//    // 将 CFString 写为 UTF-8 bytes
//    CFIndex usedBytes = CFStringGetBytes(cfFormatted,
//                                         CFRangeMake(0, cfLen),
//                                         kCFStringEncodingUTF8,
//                                         0,
//                                         false,
//                                         (UInt8 *)inBuf,
//                                         maxBytes,
//                                         NULL);
//    size_t inLen = (size_t)usedBytes;
//    
//    // 为输出分配缓冲（长度不会超过输入长度）
//    char *outBuf = (char *)malloc(inLen + 1);
//    if (!outBuf) {
//        free(inBuf);
//        CFRelease(cfFormatted);
//        return (__bridge_transfer NSString *)cfFormatted;
//    }
//    
//    // 要移除的字面串（ASCII 安全）
//    const char *pat1 = "(null)";
//    const char *pat2 = "<null>";
//    size_t pat1len = strlen(pat1); // 6
//    size_t pat2len = strlen(pat2); // 6
//    
//    // 单遍扫描并拷贝（跳过匹配片段）
//    size_t i = 0, o = 0;
//    while (i < inLen) {
//        // 快速首字节判断减少 memcmp 次数
//        if (inBuf[i] == '(' && i + pat1len <= inLen && memcmp(inBuf + i, pat1, pat1len) == 0) {
//            i += pat1len;
//            continue;
//        }
//        if (inBuf[i] == '<' && i + pat2len <= inLen && memcmp(inBuf + i, pat2, pat2len) == 0) {
//            i += pat2len;
//            continue;
//        }
//        outBuf[o++] = inBuf[i++];
//    }
//    outBuf[o] = '\0';
//    
//    // 清理中间资源
//    free(inBuf);
//    CFRelease(cfFormatted);
//    
//    // 从输出字节创建不可变 CFString / NSString
//    CFStringRef outCF = CFStringCreateWithBytes(NULL, (const UInt8 *)outBuf, (CFIndex)o, kCFStringEncodingUTF8, false);
//    free(outBuf);
//    
//    if (!outCF) {
//        return @""; // 如果编码失败，返回空串（或选择其他回退）
//    }
//    
//    // __bridge_transfer 负责释放 outCF
//    NSString *result = (__bridge_transfer NSString *)outCF;
//    return result;
}
- (instancetype)vv_stringByAppendingString:(NSString *)format {
    
    // 只清理 self 中可能的 (null)/<null>
    if (self.length == 0) return self;
    NSMutableString *outStr = [self mutableCopy];
    if (([outStr rangeOfString:@"(null)" options:NSLiteralSearch].location != NSNotFound)) {
        NSRange wholeRange = NSMakeRange(0, outStr.length);
        [outStr replaceOccurrencesOfString:@"(null)"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:wholeRange];
    }
    
    if (([outStr rangeOfString:@"<null>" options:NSLiteralSearch].location != NSNotFound)) {
        NSRange wholeRange = NSMakeRange(0, outStr.length);
        [outStr replaceOccurrencesOfString:@"<null>"
                                withString:@""
                                   options:NSLiteralSearch
                                     range:wholeRange];
    }

    if (format == nil || format.length == 0) {
        return [outStr copy];
    }
    
    NSMutableString *formatStr = [format mutableCopy];
    if (([formatStr rangeOfString:@"(null)" options:NSLiteralSearch].location != NSNotFound)) {
        NSRange wholeRange = NSMakeRange(0, formatStr.length);
        [formatStr replaceOccurrencesOfString:@"(null)"
                                   withString:@""
                                      options:NSLiteralSearch
                                        range:wholeRange];
    }
    
    if (([formatStr rangeOfString:@"<null>" options:NSLiteralSearch].location != NSNotFound)) {
        NSRange wholeRange = NSMakeRange(0, formatStr.length);
        [formatStr replaceOccurrencesOfString:@"<null>"
                                   withString:@""
                                      options:NSLiteralSearch
                                        range:wholeRange];
    }
    
    [outStr appendString:formatStr];
    
    return [outStr copy];
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
+ (NSString *)vv_strJoin:(NSString *)first, ... {
    NSString *iter, *result = first;
    va_list strings;
    va_start(strings, first);
    while ((iter = va_arg(strings, NSString*))) {
        NSString *capitalized = iter.capitalizedString;
        result = [result stringByAppendingString:capitalized];
    }
    va_end(strings);
    return result;
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
                            roundingMode:NSNumberFormatterRoundHalfUp
                       groupingSeparator:@""];
}

+ (NSString *)vv_stringFromNumber:(NSNumber *)number
                   fractionDigits:(NSUInteger)fractionDigits
                     roundingMode:(NSNumberFormatterRoundingMode)mode
                groupingSeparator:(NSString *)separator {
    
    // NumberFormatter 使用的是 IEEE 754 格式，该格式支持的最大有效数字位数为 17 位，因此超出这个范围的数字将被舍入或填充
    
    NSString *numberString = [number stringValue];
    NSArray *numberArr = [numberString componentsSeparatedByString:@"."];
    
    NSString *prffixStr = numberArr.firstObject;
    NSString *suffixStr = @"0";
    if (numberArr.count == 2) {
        suffixStr = [suffixStr stringByAppendingFormat:@".%@",numberArr.lastObject];
    }
    BOOL isMinus = [prffixStr hasPrefix:@"-"];
    NSDecimalNumber *suffixDecimal = [NSDecimalNumber decimalNumberWithString:suffixStr];
    NSRoundingMode roundMode = NSRoundDown;
    switch (mode) {
        case NSNumberFormatterRoundDown:
            roundMode = NSRoundDown;
            break;
            
        case NSNumberFormatterRoundUp:
            roundMode = NSRoundUp;
            break;
            
        case NSNumberFormatterRoundFloor:
            roundMode = isMinus ? NSRoundUp : NSRoundDown;
            break;
            
        case NSNumberFormatterRoundCeiling:
            roundMode = isMinus ? NSRoundDown : NSRoundUp;
            break;
            
        case NSNumberFormatterRoundHalfEven:
            roundMode = NSRoundBankers;
            break;
            
        case NSNumberFormatterRoundHalfDown: {
            if (numberArr.count != 2) {
                roundMode = NSRoundDown;
                break;
            }
            
            // 被舍弃小数部分>0.5时入，否则舍
            NSString *originSuffixStr = numberArr.lastObject;
            NSInteger compareIndex = fractionDigits + 1;
            NSString *compareString;
            if (originSuffixStr.length < compareIndex) {
                compareString = @"0";
            } else {
                compareString = [originSuffixStr substringFromIndex:fractionDigits];
            }
            compareString = [@"0." stringByAppendingString:compareString];
            roundMode = [compareString vv_compareIsGreater:@"0.5"] ? NSRoundUp : NSRoundDown;
        }
            break;
            
        case NSNumberFormatterRoundHalfUp: // 被舍弃小数部分>=0.5时入，否则舍
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
    
    NSString *result = prffixStr;
    if (suffixStr.length > 0 && fractionDigits > 0) {
        if ([prffixStr hasPrefix:@"-"] && ![result hasPrefix:@"-"]) { // 特殊处理 -0.xx 这种情况的数字
            result = [@"-" stringByAppendingString:result];
        }
        suffixStr = [suffixStr stringByReplacingOccurrencesOfString:@"0." withString:@""];
        result = [result stringByAppendingFormat:@".%@",suffixStr];
    }
    if ([separator isKindOfClass:NSString.class] && separator.length > 0) {
        result = [self vv_addCommaSeparator:result groupingSeparator:separator];
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
    return [self vv_addCommaSeparator:string groupingSeparator:@","];
}

+ (NSString *)vv_addCommaSeparator:(id)string groupingSeparator:(NSString *)sep {

    // 处理原始数据
    NSString *numberString = @"";
    if ([string isKindOfClass:NSNumber.class] ||
        [string isKindOfClass:NSDecimalNumber.class]) {
        numberString = vv_handleLossPrecision([string doubleValue]);
    }else if ([string isKindOfClass:NSString.class]){
        numberString = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    }

    if (numberString.length == 0) return numberString;
    
    // 处理符号
    NSString *sign = @"";
    unichar firstChar = [numberString characterAtIndex:0];
    if (firstChar == '+' || firstChar == '-') {
        sign = [numberString substringToIndex:1];
        numberString = [numberString substringFromIndex:1];
        if (numberString.length == 0) return [sign stringByAppendingString:@"0"];
    }
    
    // 分离整数和小数部分
    NSArray *parts = [numberString componentsSeparatedByString:@"."];
    if (parts.count > 2) return @"";  // 多个小数点，非法数字
    
    NSString *integerPart = parts.firstObject;
    NSString *decimalPart = (parts.count > 1) ? parts[1] : nil;
    
    // 处理纯小数情况（如 ".45" -> "0.45"）
    if (integerPart.length == 0) integerPart = @"0";
    
    // 添加千位分隔符
    NSUInteger integerLength = integerPart.length;
    NSUInteger commaCount = (integerLength - 1) / 3; // 计算逗号数量
    NSUInteger newLength = integerLength + commaCount;
    
    // 缓冲区安全校验
    if (newLength == 0 || newLength > 1024 * 1024) {  // 限制最大1MB
        return @"";
    }
    
    unichar *origBuffer = malloc(integerLength * sizeof(unichar));
    if (!origBuffer) return @"";
    [integerPart getCharacters:origBuffer range:NSMakeRange(0, integerLength)];
    
    unichar *newBuffer = malloc(newLength * sizeof(unichar));
    if (!newBuffer) {
        free(origBuffer);
        return @"";
    }
    
    NSString *separator = @","; // 默认分隔符
    if ([sep isKindOfClass:NSString.class] && sep.length > 0) {
        separator = sep;
    }
    
    NSInteger newIndex = newLength - 1;
    NSUInteger counter = 0;
    NSUInteger sepLen = separator.length;
    BOOL formatSuccess = YES;
    
    // 逆向遍历填充字符
    for (NSInteger i = integerLength - 1; i >= 0; i--) {
        // 数字字符写入检查
        if (newIndex < 0) {
            formatSuccess = NO;
            break;
        }
        newBuffer[newIndex--] = origBuffer[i];
        counter++;
        
        // 插入分隔符
        if (counter % 3 == 0 && i > 0 && sepLen > 0) {
            // 逆序写入分隔符
            for (NSInteger j = sepLen - 1; j >= 0; j--) {
                if (newIndex < 0) { // 确保有足够空间写入分隔符
                    formatSuccess = NO;
                    break;
                }
                newBuffer[newIndex--] = [separator characterAtIndex:j];
            }
            if (!formatSuccess) break;
        }

    }
    
    // 最终状态验证
    if (!formatSuccess || newIndex != -1) {
        free(origBuffer);
        free(newBuffer);
        return @"";
    }
    
    // 构建格式化字符串
    NSString *formattedInteger = [NSString stringWithCharacters:newBuffer length:newLength];
    free(origBuffer);
    free(newBuffer);
    
    // 组合最终结果
    NSMutableString *result = [NSMutableString stringWithString:sign];
    [result appendString:formattedInteger];
    if (decimalPart) {
        [result appendFormat:@".%@", decimalPart];
    }
    
    // 二次验证结果有效性
    if (result.length == 0) {
        return @"";
    }
    
    return [result copy];
}

+ (NSString *)vv_decimalStyleNumber:(id)number {
    NSNumberFormatter *formatter = [self vv_threadLocalFormatter];
    NSString *result = @"";
    if ([number isKindOfClass:NSString.class]) {
        NSNumber *stringValue = [formatter numberFromString:number];
        result = stringValue.stringValue;
    }else if ([number isKindOfClass:NSNumber.class]){
        result = [formatter stringFromNumber:number];
    }
    return ([result isKindOfClass:NSString.class] && result.length > 0) ? result : @"";
}


+ (NSNumberFormatter *)vv_threadLocalFormatter {
    NSMutableDictionary *td = NSThread.currentThread.threadDictionary;
    static NSString * const kFormatterKey = @"com.NSSting.vv_decimal_formatter";
    NSNumberFormatter *fmt = td[kFormatterKey];
    if (!fmt) {
        fmt = [NSNumberFormatter new];
        fmt.usesSignificantDigits = YES;
        fmt.maximumSignificantDigits = 100;
        fmt.groupingSeparator = @"";
        fmt.decimalSeparator = @".";
        fmt.numberStyle = NSNumberFormatterNoStyle;
        td[kFormatterKey] = fmt;
    }
    return fmt;
}

+ (NSNumberFormatter *)vv_numberFormatterWithFractionDigits:(NSInteger)fractionDigits
                                               roundingMode:(NSNumberFormatterRoundingMode)mode
                                          groupingSeparator:(NSString *)separator {
    NSString *sep = separator ?: @"";
    NSString *key = [NSString stringWithFormat:@"com.NSSting.vv_%@_%ld_%ld", sep, fractionDigits, mode];
    NSMutableDictionary *td = NSThread.currentThread.threadDictionary;
    NSNumberFormatter *fmt = td[key];
    if (!fmt) {
        fmt = [NSNumberFormatter new];
        fmt.minimumIntegerDigits = 1;
        fmt.numberStyle = NSNumberFormatterDecimalStyle;
        fmt.decimalSeparator = @".";
        fmt.groupingSeparator = sep;
        fmt.minimumFractionDigits = fractionDigits;
        fmt.maximumFractionDigits = fractionDigits;
        fmt.roundingMode = mode;
        td[key] = fmt;
    }
    return fmt;
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
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSDecimalNumber *absNum = [NSDecimalNumber vv_abs:decimalNum];
    return [absNum stringValue];
}

- (NSString *)vv_safeAdding:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSDecimalNumber *addingNum = [num1 vv_adding:num2];
    return [addingNum stringValue];
}

- (NSString *)vv_safeSubtracting:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSDecimalNumber *subtractingNum = [num1 vv_subtracting:num2];
    return [subtractingNum stringValue];
}

- (NSString *)vv_safeMultiplying:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSDecimalNumber *multiplyingNum = [num1 vv_multiplying:num2];
    return [multiplyingNum stringValue];
}

- (NSString *)vv_safeDividing:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSDecimalNumber *dividingNum = [num1 vv_dividing:num2];
    return [dividingNum stringValue];
}

- (BOOL)vv_compareIsEqual:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedSame;
}

- (BOOL)vv_compareIsGreater:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
    NSComparisonResult result = [num1 compare:num2];
    return result == NSOrderedDescending;
}

- (BOOL)vv_compareIsLess:(NSString *)num {
    NSString *safeSelf = [NSString vv_safeString:self];
    NSString *safeNum = [NSString vv_safeString:num];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:safeSelf];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:safeNum];
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
        NSString *decimalNumber = [NSString vv_decimalStyleNumber:str];
        if (decimalNumber.length > 0) {
            return str;
        }
    }
    return @"0";
}

@end
