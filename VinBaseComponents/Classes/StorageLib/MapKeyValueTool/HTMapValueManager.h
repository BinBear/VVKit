//
//  HTMapValueManager.h
//  HeartTrip
//
//  Created by vin on 2020/11/2.
//  Copyright © 2020 BinBear All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMapValueManager : NSObject

#pragma mark - BooL 类型
/// 保存BooL值
+ (void)saveBool:(BOOL)object forKey:(NSString *)key;
/// 获取BooL值数据
+ (BOOL)getBoolWithKey:(NSString *)key;

#pragma mark - int 类型
/// 保存int值
+ (void)saveInteger:(NSInteger)object forKey:(NSString *)key;
/// 获取int值数据
+ (NSInteger)getIntegerWithKey:(NSString *)key;

#pragma mark - float 类型
/// 保存float值
+ (void)saveFloat:(CGFloat)object forKey:(NSString *)key;
/// 获取float值数据
+ (CGFloat)getFloatWithKey:(NSString *)key;

#pragma mark - double 类型
/// 保存double值
+ (void)saveDouble:(double)object forKey:(NSString *)key;
/// 获取double值数据
+ (double)getDoubleWithKey:(NSString *)key;

#pragma mark - Date 类型
/// 保存Date值
+ (void)saveDate:(NSDate *)object forKey:(NSString *)key;
/// 获取Date值数据
+ (NSDate *)getDateWithKey:(NSString *)key;

#pragma mark - NSString 类型
/// 保存NSString值
+ (void)saveString:(NSString *)object forKey:(NSString *)key;
/// 获取NSString值数据
+ (NSString *)getStringWithKey:(NSString *)key;

#pragma mark - 对象类型
/// 保存对象数据(eg：NSArray、NSMutableArray、NSDictionary、NSMutableDictionary、自定义对象...)，默认使用了加密保存
+ (void)saveObject:(id)object forKey:(NSString *)key;
/// 获取对象数据
// cls的传值类型:
// 1、获取 NSString 类型数据，cls传 NSString.class
// 2、获取 NSDate 类型数据，cls传 NSDate.class
// 3、其他所有类型，cls传相应的类型：eg： NSData.class、 NSDictionary.class、NSArray.class
+ (id)getObjectWithClass:(Class)cls forKey:(NSString *)key;

#pragma mark - 移除数据
/// 根据key移除保存的数据
+ (void)removeObjectWithKey:(NSString *)key;
/// 根据key数组移除保存的数据
+ (void)removeObjectWithKeys:(NSArray *)keys;

#pragma mark - MMKV Log
/// 是否关闭MMKV日志
+ (void)mmkvLogLevel:(BOOL)isClose;

#pragma mark - KeyChain
/// 保存数据到KeyChain
+ (BOOL)saveKeyChain:(id)object forKey:(NSString *)key;
/// 获取保存到KeyChain中的数据
+ (id)getKeyChainObjectWithClass:(Class)cls forKey:(NSString *)key;
/// 根据key移除保存到KeyChain中的数据
+ (BOOL)removeKeyChainObjectWithKey:(NSString *)key;
/// 移除保存到KeyChain中的所有数据
+ (BOOL)removeAllKeyChainObject;
@end

NS_ASSUME_NONNULL_END
