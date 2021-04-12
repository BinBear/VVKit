//
//  NSObject+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BinAdd)

- (void)vv_setAssociateRetainValue:(id)value withKey:(void *)key;
- (void)vv_setAssociateCopyValue:(id)value withKey:(void *)key;
- (void)vv_setAssociateAssignValue:(id)value withKey:(void *)key;
- (id)vv_getAssociatedValueForKey:(void *)key;
- (void)vv_removeAssociatedValues;

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

NS_ASSUME_NONNULL_END
