//
//  NSString+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (VinKit)

#pragma mark - Utilities
/**
 格式化字符串，并过滤格式化后的字符串中的(null)
 
 @param format 格式
 @return 格式化后，过滤掉@"(null)"的字符串
 */
+ (instancetype)vv_stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/**
 拼接字符串，并过滤字符串中的(null)
 
 @param format 格式
 @return 拼接后，过滤掉@"(null)"的字符串
 */
- (instancetype)vv_stringByAppendingString:(NSString *)format;

#pragma mark - RoundNumber
/**
 *  Return a string from the provided float value. The float value is plain rounded in the way specified by scale. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Float value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)vv_stringFromFloat:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string from the provided float value. The float value is rounded in the way specified by scale and roundingMode. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Float value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param mode     The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)vv_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string containing the fraction digits of the provided float value. The float value is rounded in the way specified by scale and roundingMode.
 *
 *  @param value          Float value.
 *  @param scale          The number of digits a rounded value should have after its decimal point.
 *  @param mode           The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)vv_stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits;

/**
 *  Return a string from the provided double value. The double value is plain rounded in the way specified by scale. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Double value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)vv_stringFromDouble:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string from the provided double value. The double value is rounded in the way specified by scale and roundingMode. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Double value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param mode     The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)vv_stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string containing the fraction digits of the provided double value. The double value is rounded in the way specified by scale and roundingMode.
 *
 *  @param value          Double value.
 *  @param scale          The number of digits a rounded value should have after its decimal point.
 *  @param mode           The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)vv_stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits;

/**
 * 返回只入不舍位数的值
 *
 * @param number         An NSNumber object that is parsed to create the returned string object.
 * @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)vv_stringRoundUpFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;

/**
 *  返回舍去位数的值
 *
 *  @param number         An NSNumber object that is parsed to create the returned string object.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)vv_stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;
/**
 *  返回四舍五入位数的值
 *
 *  @param number         An NSNumber object that is parsed to create the returned string object.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)vv_stringRoundPlainFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;

/**
 *  去除数字末尾的零
 *  @param string      传入需要去除尾部的0的字符串.
 */
+ (NSString *)vv_deleteSuffixAllZero:(NSString *) string ;

/**
 *  位数不足头部补充零
 *  @param string      传入需要补充0的字符串、位数.
 */
+ (NSString *)vv_addZeroForString:(NSString *) string andLength:(NSInteger)length;


#pragma mark - Calculation
/**
 * 取绝对值
 *
 * @param num 数值
 * @return 取绝对值后的值
 */
+ (NSString *)vv_stringAbs:(NSString *)num;

/**
 * 两数相加
 *
 * @param num 加的数
 * @return 相加后的数
 */
- (NSString *)vv_safeAdding:(NSString *)num;
/**
 * 两数相减
 *
 * @param num 减的数
 * @return 相减后的数
 */
- (NSString *)vv_safeSubtracting:(NSString *)num;
/**
 * 两数相乘
 *
 * @param num 乘的数
 * @return 相乘后的数
 */
- (NSString *)vv_safeMultiplying:(NSString *)num;
/**
 * 两数相除
 *
 * @param num 除的数
 * @return 相除后的数
 */
- (NSString *)vv_safeDividing:(NSString *)num;
/**
 * 是否相等
 *
 * @param stringNumer 比较的数
 * @return 比较结果
 */
- (BOOL)vv_compareIsEqual:(NSString *)stringNumer;
/**
 * 是否大于
 *
 * @param stringNumer 比较的数
 * @return 比较结果
 */
- (BOOL)vv_compareIsGreater:(NSString *)stringNumer;
/**
 * 是否小于
 *
 * @param stringNumer 比较的数
 * @return 比较结果
 */
- (BOOL)vv_compareIsLess:(NSString *)stringNumer;
@end

NS_ASSUME_NONNULL_END
