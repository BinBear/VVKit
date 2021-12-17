//
//  NSObject+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VinKit)

- (void)vv_setAssociateRetainValue:(id)value withKey:(void *)key;
- (void)vv_setAssociateCopyValue:(id)value withKey:(void *)key;
- (void)vv_setAssociateAssignValue:(id)value withKey:(void *)key;
- (id)vv_getAssociatedValueForKey:(void *)key;
- (void)vv_removeAssociatedValues;

@end


@interface NSObject (VinDevice)

+ (NSURL *)vv_documentsURL;
+ (NSString *)vv_documentsPath;

+ (NSURL *)vv_cachesURL;
+ (NSString *)vv_cachesPath;

+ (NSURL *)vv_libraryURL;
+ (NSString *)vv_libraryPath;

+ (NSString *)vv_appBuildVersion;
+ (NSString *)vv_appBundleName;
+ (NSString *)vv_appBundleID;
+ (NSString *)vv_appVersion;

+ (BOOL)vv_fileExistInMainBundle:(NSString *)name;

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
- (void)vv_switch:(NSDictionary<id<NSCopying>, VinCaseBlock> *)cases;
- (void)vv_switch:(NSDictionary<id<NSCopying>, VinCaseBlock> *)cases withDefault:(nullable VinCaseBlock)defaultBlock;

@end

NS_ASSUME_NONNULL_END
