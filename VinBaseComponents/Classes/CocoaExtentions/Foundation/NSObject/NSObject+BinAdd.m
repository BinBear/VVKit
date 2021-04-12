//
//  NSObject+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "NSObject+BinAdd.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation NSObject (BinAdd)

- (void)vv_setAssociateRetainValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)vv_setAssociateCopyValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)vv_setAssociateAssignValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)vv_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)vv_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}


+ (NSURL *)vv_documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)vv_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)vv_cachesURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)vv_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)vv_libraryURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)vv_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (BOOL)vv_fileExistInMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)vv_appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)vv_appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)vv_appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)vv_appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}
@end
