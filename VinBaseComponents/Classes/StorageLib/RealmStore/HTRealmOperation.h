//
//  HTRealmOperation.h
//  HeartTrip
//
//  Created by vin on 2021/3/8.
//  Copyright © 2021 BinBear All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@class HTRealmOperation;

typedef id _Nullable (^HTRealmOperationObjectsBlock)(HTRealmOperation *operation, RLMRealm *realm);
typedef void(^HTRealmOperationCompletion)(HTRealmOperation *operation);
typedef void(^HTRealmOperationFetchCompletion)(HTRealmOperation *operation, RLMResults *results);

@interface HTRealmOperation : NSObject


#pragma mark - 写入操作

/// 写入操作
/// @param objectsBlock 操作block
+ (void)writeOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock;

/// 多线程写入操作
/// @param queue 线程
/// @param objectsBlock 操作block
/// @param completion 完成block
+ (instancetype)writeOperationWithQueue:(dispatch_queue_t)queue
                           objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                             completion:(HTRealmOperationCompletion)completion;

#pragma mark - 删除操作

/// 删除操作
/// @param objectsBlock 操作block
+ (void)deleteOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock;

/// 多线程删除操作
/// @param queue 线程
/// @param objectsBlock 操作block
/// @param completion 完成block
+ (instancetype)deleteOperationWithQueue:(dispatch_queue_t)queue
                            objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                              completion:(HTRealmOperationCompletion)completion;

#pragma mark - 查找操作

/// 查找操作
/// @param objectsBlock 操作block
+ (id)fetchOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock;

/// 多线程查找操作
/// @param queue 线程
/// @param objectsBlock 操作block
/// @param completion 完成block
+ (instancetype)fetchOperationWithQueue:(dispatch_queue_t)queue
                           objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                             completion:(HTRealmOperationFetchCompletion)completion;

@end

NS_ASSUME_NONNULL_END
