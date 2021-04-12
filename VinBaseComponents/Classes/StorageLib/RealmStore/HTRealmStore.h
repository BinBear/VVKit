//
//  HTRealmStore.h
//  HeartTrip
//
//  Created by vin on 2021/3/8.
//  Copyright © 2021 BinBear All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTRealmWriteTransaction.h"
#import "HTRealmOperation.h"

NS_ASSUME_NONNULL_BEGIN

@class HTRealmStore;

typedef void(^HTRealmStoreOperationCompletion)(HTRealmStore *store, HTRealmOperation *operation);
typedef void(^HTRealmStoreFetchOperationCompletion)(HTRealmStore *store, HTRealmOperation *operation, RLMResults *results);
typedef void(^HTRealmStoreWriteTransactionCompletion)(HTRealmStore *store, HTRealmWriteTransaction *transaction);

@interface HTRealmStore : NSObject

#pragma mark - 初始化
/// 初始化
+ (instancetype)shared;

#pragma mark - 事务

/// 事务写入
/// @param writeBlock 写入block
- (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock;

/// 多线程事务写入
/// @param writeBlock 写入block
/// @param completion 完成block
- (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock
                            completion:(HTRealmStoreWriteTransactionCompletion)completion;

#pragma mark - 写入操作

/// 写入操作
/// @param objectsBlock 操作block
- (void)writeObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock;

/// 多线程写入操作
/// @param objectsBlock 操作block
/// @param completion 完成block
- (void)writeObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                          completion:(HTRealmStoreOperationCompletion)completion;

#pragma mark - 删除操作

/// 删除操作
/// @param objectsBlock 操作block
- (void)deleteObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock;

/// 多线程删除操作
/// @param objectsBlock 操作block
/// @param completion 完成block
- (void)deleteObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                           completion:(HTRealmStoreOperationCompletion)completion;

/// 删除整个数据库表
- (void)deleteAllObjects;

/// 多线程删除整个数据库表
/// @param completion 完成block
- (void)deleteAllObjectsWithCompletion:(HTRealmStoreWriteTransactionCompletion)completion;


#pragma mark - 查找操作

/// 查找操作
/// @param objectsBlock 操作block
- (id)fetchObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock;

/// 多线程查找操作
/// @param objectsBlock 操作block
/// @param completion 完成block
- (void)fetchObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                          completion:(HTRealmStoreFetchOperationCompletion)completion;

#pragma mark - 文件

/// 数据库文件路劲
/// @param realmName 数据库名称
+ (NSURL *)realmFileURLWithRealmName:(NSString*)realmName;

@end

NS_ASSUME_NONNULL_END
