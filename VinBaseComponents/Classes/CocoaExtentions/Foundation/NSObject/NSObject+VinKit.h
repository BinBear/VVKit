//
//  NSObject+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VinKit)

/// 给Category设置一个Retain属性
- (void)vv_setAssociateRetainValue:(id)value withKey:(void *)key;
/// 给Category设置一个Copy属性
- (void)vv_setAssociateCopyValue:(id)value withKey:(void *)key;
/// 给Category设置一个Assign属性
- (void)vv_setAssociateAssignValue:(id)value withKey:(void *)key;
/// 根据key获取Category对应属性的值
- (id)vv_getAssociatedValueForKey:(void *)key;
/// 移除Category绑定的属性
- (void)vv_removeAssociatedValues;

@end


@interface NSObject (VinDevice)

/// 获取Documents路径
+ (NSURL *)vv_documentsURL;
+ (NSString *)vv_documentsPath;

/// 获取Caches路径
+ (NSURL *)vv_cachesURL;
+ (NSString *)vv_cachesPath;

/// 获取Library路径
+ (NSURL *)vv_libraryURL;
+ (NSString *)vv_libraryPath;

/// 判断MainBundle是否存在该路径
+ (BOOL)vv_fileExistInMainBundle:(NSString *)name;

/// App Build 版本
+ (NSString *)vv_appBuildVersion;
/// App 项目名称
+ (NSString *)vv_appBundleName;
/// App 名称
+ (NSString *)vv_appDisplayName;
/// App Bundle ID
+ (NSString *)vv_appBundleID;
/// App 版本
+ (NSString *)vv_appVersion;
/// 设备类型，e.g. @"iPhone", @"iPod touch"
+ (NSString *)vv_userDeviceModel;
/// 设备名称，用户定义的名称 e.g. "My iPhone"
+ (NSString *)vv_userDeviceName;
/// 设备系统名称，e.g. @"iOS"
+ (NSString *)vv_systemName;
/// 设备系统版本，e.g. @"4.0"
+ (NSString *)vv_systemVersion;
/// 设备IDFV
+ (NSString *)vv_uuidForVendor;
/// 生成的随机唯一标识符，每次生成都不同
+ (NSString *)vv_cfUUID;
/// 设备具体类型，e.g. @"iPhone13,3", @"iPod9,1"
+ (NSString *)vv_deviceModel;
/// 设备具体名称，e.g. @"iPhone 12 Pro", @"iPod touch 7"
+ (NSString *)vv_deviceName;
/// 设备地方型号（国际化区域名称）
+ (NSString *)vv_localizedModel;
/// 设备运营商名称
+ (NSString *)vv_carrierName;

/// 状态栏高度，包括安全区域
+ (CGFloat)vv_statusBarHeight;

@end

typedef void(^VinCaseBlock)(void);

@interface NSObject (VinSwitchCase)
/**
 * SwitchCase示例:
 *
 * NSNumber *flagNum = @(1.1);
 * [flagNum vv_switch:@{
 *    @(1.1): ^{
 *    // todo
 * },
 *    @(2.2): ^{
 *    // todo
 * }
 * }];
 *
 * NSString *str = @"a";
 * [str vv_switch:@{
 *    @"a": ^{
 *    // todo
 * },
 *    @"b": ^{
 *    // todo
 * },
 * } withDefault:^{
 *    // todo
 * }];
 *
 */

/// Switch Case
/// @param cases 条件
- (void)vv_switch:(NSDictionary<id<NSCopying>, VinCaseBlock> *)cases;

/// Switch Case
/// @param cases 条件
/// @param defaultBlock 不满足条件时，默认实现
- (void)vv_switch:(NSDictionary<id<NSCopying>, VinCaseBlock> *)cases withDefault:(nullable VinCaseBlock)defaultBlock;

/// 处理精度丢失
NSString *vv_handleLossPrecision(double value);

/// 获取小数位数精度
NSInteger vv_getDecimalDigits(double number);

@end

@interface NSObject (UIKit)

/// 获取keywindow
+ (UIWindow *)vv_keyWindow;

@end

NS_ASSUME_NONNULL_END
