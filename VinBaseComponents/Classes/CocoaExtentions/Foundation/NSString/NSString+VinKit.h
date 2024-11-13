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

/// 格式化字符串，并过滤格式化后的字符串中的(null)
/// @param format 格式
+ (instancetype)vv_stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/// 拼接字符串，并过滤字符串中的(null)
/// @param format 格式
- (instancetype)vv_stringByAppendingString:(NSString *)format;

/// 随机生成相应长度的数字+字母的字符串
/// @param length 长度
+ (NSString *)vv_randomString:(NSInteger)length;

/// 将多个字符串拼接
/// @param first 首个字符串
+ (instancetype)vv_strJoin:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface NSString (RoundNumber)

/// 浮点值按精度进行转换，默认采用四舍五入的方式，舍入的值可以用零填充，以使小数位数符合比例。
/// @param value    转换的值
/// @param scale    精度
/// @param isPadded 是否需要补0生成相应精度的值
+ (NSString *)vv_stringFromFloat:(float)value
                   roundingScale:(short)scale
            fractionDigitsPadded:(BOOL)isPadded;

/// 浮点值按精度进行转换，按相应的方式舍入，舍入的值可以用零填充，以使小数位数符合比例。
/// @param value    转换的值
/// @param scale    精度
/// @param mode     转换的方式
/// @param isPadded 是否需要补0生成相应精度的值
+ (NSString *)vv_stringFromFloat:(float)value
                   roundingScale:(short)scale
                    roundingMode:(NSRoundingMode)mode
            fractionDigitsPadded:(BOOL)isPadded;

/// 浮点值按精度进行转换，按相应的方式舍入，舍入的值可以用零填充，以使小数位数符合比例。
/// @param value          转换的值
/// @param scale          精度
/// @param mode           转换的方式
/// @param fractionDigit  舍入完成后，转换为字符串所需的精度
+ (NSString *)vv_stringFromFloat:(float)value
                   roundingScale:(short)scale
                    roundingMode:(NSRoundingMode)mode
                  fractionDigits:(NSUInteger)fractionDigit;

/// 浮点值按精度进行转换，默认采用四舍五入的方式，舍入的值可以用零填充，以使小数位数符合比例。
/// @param value    转换的值
/// @param scale    精度
/// @param isPadded 是否需要补0生成相应精度的值
+ (NSString *)vv_stringFromDouble:(double)value
                    roundingScale:(short)scale
             fractionDigitsPadded:(BOOL)isPadded;

/// 浮点值按精度进行转换，按相应的方式舍入，舍入的值可以用零填充，以使小数位数符合比例。
/// @param value    转换的值
/// @param scale    精度
/// @param mode     转换的方式
/// @param isPadded 是否需要补0生成相应精度的值
+ (NSString *)vv_stringFromDouble:(double)value
                    roundingScale:(short)scale
                     roundingMode:(NSRoundingMode)mode
             fractionDigitsPadded:(BOOL)isPadded;

/// 浮点值按精度进行转换，按相应的方式舍入，舍入的值可以用零填充，以使小数位数符合比例。
/// @param value          转换的值
/// @param scale          精度
/// @param mode           转换的方式
/// @param fractionDigit  舍入完成后，转换为字符串所需的精度
+ (NSString *)vv_stringFromDouble:(double)value
                    roundingScale:(short)scale
                     roundingMode:(NSRoundingMode)mode
                   fractionDigits:(NSUInteger)fractionDigit;

/// 对数值按精度进行只入不舍位数
/// @param number        数值
/// @param fractionDigit 精度
+ (NSString *)vv_stringRoundUpFromNumber:(NSNumber *)number
                          fractionDigits:(NSUInteger)fractionDigit;

/// 对数值按精度进行舍去位数
/// @param number        数值
/// @param fractionDigit 精度
+ (NSString *)vv_stringRoundDownFromNumber:(NSNumber *)number
                            fractionDigits:(NSUInteger)fractionDigit;

/// 对数值按精度进行四舍五入
/// @param number        数值
/// @param fractionDigit 精度
+ (NSString *)vv_stringRoundPlainFromNumber:(NSNumber *)number
                             fractionDigits:(NSUInteger)fractionDigit;

/// 数值按精度进行转换，按相应的方式舍入，舍入的值可以用零填充，以使小数位数符合比例。
/// @param number           转换的值
/// @param fractionDigits   精度
/// @param mode             转换的方式
/// @param separator        千分位的分隔符
+ (NSString *)vv_stringFromNumber:(NSNumber *)number
                   fractionDigits:(NSUInteger)fractionDigits
                     roundingMode:(NSNumberFormatterRoundingMode)mode
                groupingSeparator:(NSString *)separator;

/// 去除数字末尾的零
/// @param string 需要去除尾部的0的字符串
+ (NSString *)vv_deleteSuffixAllZero:(NSString *)string;


/// 位数不足头部补充零
/// @param string 需要补充0的字符串
/// @param length 需要补充0的位数.
+ (NSString *)vv_addZeroForString:(NSString *)string
                        andLength:(NSInteger)length;

/// 给数字字符串添加逗号分隔符
/// @param string 需要添加逗号分隔符的字符串，可以是NSNumber
+ (NSString *)vv_addCommaSeparator:(id)string;

/// 返回十进制字符串，去除科学计数法
/// @param number 需要格式化的数字
+ (NSString *)vv_decimalStyleNumber:(id)number;

@end


@interface NSString (Calculation)

/// 取绝对值
/// @param num 数值
+ (NSString *)vv_stringAbs:(NSString *)num;

/// 取绝相加
/// @param num 加的数
- (NSString *)vv_safeAdding:(NSString *)num;

/// 取绝相减
/// @param num 减的数
- (NSString *)vv_safeSubtracting:(NSString *)num;

/// 两数相乘
/// @param num 乘的数
- (NSString *)vv_safeMultiplying:(NSString *)num;

/// 两数相除
/// @param num 除的数
- (NSString *)vv_safeDividing:(NSString *)num;

/// 是否相等
/// @param stringNumer 比较的数
- (BOOL)vv_compareIsEqual:(NSString *)stringNumer;

/// 是否大于
/// @param stringNumer 比较的数
- (BOOL)vv_compareIsGreater:(NSString *)stringNumer;

/// 是否小于
/// @param stringNumer 比较的数
- (BOOL)vv_compareIsLess:(NSString *)stringNumer;

/// 幂
/// @param num 次
- (NSString *)vv_safePow:(NSUInteger)num;

@end

NS_ASSUME_NONNULL_END
