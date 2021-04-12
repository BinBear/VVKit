//
//  HTMapValueManager.m
//  HeartTrip
//
//  Created by vin on 2020/11/2.
//  Copyright © 2020 BinBear All rights reserved.
//

#import "HTMapValueManager.h"
#import <MMKV/MMKV.h>


@implementation HTMapValueManager
#pragma mark - BooL 类型
+ (void)saveBool:(BOOL)object forKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setBool:object forKey:key];
}
+ (BOOL)getBoolWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    return [mmkv getBoolForKey:key];
}

#pragma mark - int 类型
+ (void)saveInteger:(NSInteger)object forKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setInt64:object forKey:key];
}
+ (NSInteger)getIntegerWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");

    MMKV *mmkv = [MMKV defaultMMKV];
    
    return [mmkv getInt64ForKey:key];
}

#pragma mark - float 类型
+ (void)saveFloat:(CGFloat)object forKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setFloat:object forKey:key];
}
+ (CGFloat)getFloatWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    return [mmkv getFloatForKey:key];
}

#pragma mark - double 类型
+ (void)saveDouble:(double)object forKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setDouble:object forKey:key];
}
+ (double)getDoubleWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    return [mmkv getDoubleForKey:key];
}

#pragma mark - Date 类型
+ (void)saveDate:(NSDate *)object forKey:(NSString *)key{
    
    NSParameterAssert(object);
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![object isKindOfClass:[NSDate class]] || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    MMKV *mmkv = [MMKV defaultMMKV];
    
    [mmkv setDate:object forKey:key];
}
+ (NSDate *)getDateWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    MMKV *mmkv = [MMKV defaultMMKV];
    
    return [mmkv getDateForKey:key];
}

#pragma mark - NSString 类型
+ (void)saveString:(NSString *)object forKey:(NSString *)key{
    NSParameterAssert(object);
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![object isKindOfClass:[NSString class]] || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    MMKV *mmkv = [MMKV mmkvWithID:[self MMapIDKey] cryptKey:[self MMKVAESLockKey]];
    
    [mmkv setString:object forKey:key];
}
+ (NSString *)getStringWithKey:(NSString *)key{
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    MMKV *mmkv = [MMKV mmkvWithID:[self MMapIDKey] cryptKey:[self MMKVAESLockKey]];
    
    return [mmkv getStringForKey:key];
}

#pragma mark - 对象类型
+ (void)saveObject:(id)object forKey:(NSString *)key{
    
    NSParameterAssert(object);
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (!object || ![key isKindOfClass:[NSString class]] || ![object conformsToProtocol:@protocol(NSCoding)]) {
        return;
    }
    
    MMKV *mmkv = [MMKV mmkvWithID:[self MMapIDKey] cryptKey:[self MMKVAESLockKey]];
    
    [mmkv setObject:object forKey:key];
    
}
+ (id)getObjectWithClass:(Class)cls forKey:(NSString *)key{
    
    NSParameterAssert(cls);
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    MMKV *mmkv = [MMKV mmkvWithID:[self MMapIDKey] cryptKey:[self MMKVAESLockKey]];
    
    return [mmkv getObjectOfClass:cls forKey:key];

}

#pragma mark - 移除数据
+ (void)removeObjectWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    MMKV *mmkvCustom = [MMKV mmkvWithID:[self MMapIDKey] cryptKey:[self MMKVAESLockKey]];
    
    if ([mmkv containsKey:key]) {
        [mmkv removeValueForKey:key];
    }
    if ([mmkvCustom containsKey:key]) {
        [mmkvCustom removeValueForKey:key];
    }
}
+ (void)removeObjectWithKeys:(NSArray *)keys{
    
    NSParameterAssert(keys);
    NSAssert([keys isKindOfClass:[NSArray class]], @"keys 必须为数组字符串");
    
    if (![keys isKindOfClass:[NSArray class]]) {
        return;
    }
    
    MMKV *mmkv = [MMKV defaultMMKV];
    MMKV *mmkvCustom = [MMKV mmkvWithID:[self MMapIDKey] cryptKey:[self MMKVAESLockKey]];
    
    NSMutableArray *defaultArr = @[].mutableCopy;
    NSMutableArray *customArr = @[].mutableCopy;
    
    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([mmkv containsKey:obj]) {
            [defaultArr addObject:obj];
        }
        if ([mmkvCustom containsKey:obj]) {
            [customArr addObject:obj];
        }
    }];
    
    if (defaultArr.count > 0) {
        [mmkv removeValuesForKeys:defaultArr];
    }
    
    if (customArr.count > 0) {
        [mmkvCustom removeValuesForKeys:customArr];
    }
}

#pragma mark - MMKV Log
/// 是否关闭MMKV日志
+ (void)mmkvLogLevel:(BOOL)isClose {
    // 关闭MMKV的Log
    MMKVLogLevel level = isClose ? MMKVLogNone : MMKVLogDebug;
    [MMKV initializeMMKV:nil logLevel:level];
}


#pragma mark - KeyChain
+ (BOOL)saveKeyChain:(id)object forKey:(NSString *)key{
    
    NSParameterAssert(object);
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (!object || ![key isKindOfClass:[NSString class]] || ![object conformsToProtocol:@protocol(NSCoding)]) {
        return NO;
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[self getBundleIdentifier]];
    if ([object isKindOfClass:NSString.class]) {
        return [keychain setString:object forKey:key];
    }else{
        NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:object];
        return [keychain setData:objectData forKey:key];
    }
}
+ (id)getKeyChainObjectWithClass:(Class)cls forKey:(NSString *)key{
    
    NSParameterAssert(cls);
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[self getBundleIdentifier]];
    if (cls == [NSString class]) {
        return [keychain stringForKey:key];
    }else{
        NSData *data = [keychain dataForKey:key];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}
+ (BOOL)removeKeyChainObjectWithKey:(NSString *)key{
    
    NSParameterAssert(key);
    NSAssert([key isKindOfClass:[NSString class]], @"key 必须为字符串");
    
    if (![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[self getBundleIdentifier]];
    return [keychain removeItemForKey:key];
}
+ (BOOL)removeAllKeyChainObject{
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[self getBundleIdentifier]];
    return [keychain removeAllItems];
}

#pragma mark - MMKV Private
+ (NSString *)getBundleIdentifier{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}
+ (NSString *)MMapIDKey{
    return @"MMapIDAES_reKey";
}
+ (NSData *)MMKVAESLockKey{
    return [@"MMKV-AESLock-key" dataUsingEncoding:NSUTF8StringEncoding];
}
@end
