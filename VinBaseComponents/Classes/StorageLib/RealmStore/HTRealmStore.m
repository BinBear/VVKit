//
//  HTRealmStore.m
//  HeartTrip
//
//  Created by vin on 2021/3/8.
//  Copyright © 2021 BinBear All rights reserved.
//

#import "HTRealmStore.h"

static HTRealmStore *instance = nil;

@implementation HTRealmStore

#pragma mark - 初始化
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
- (id)copy{
    return self;
}
- (id)mutableCopy{
    return self;
}

#pragma mark - Transaction

/// 事务写入
/// @param writeBlock 写入block
- (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock {
    [HTRealmWriteTransaction writeTransactionWithWriteBlock:writeBlock];
}

/// 多线程事务写入
/// @param writeBlock 写入block
/// @param completion 完成block
- (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock
                            completion:(HTRealmStoreWriteTransactionCompletion)completion {
    return [HTRealmWriteTransaction writeTransactionWithQueue:[[self class] queue]
                                                   writeBlock:writeBlock
                                                   completion:^(HTRealmWriteTransaction *transaction)
            {
        if (completion) completion(self, transaction);
    }];
}

#pragma mark - Operation
#pragma mark Write

/// 写入操作
/// @param objectsBlock 操作block
- (void)writeObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    [HTRealmOperation writeOperationWithObjectsBlock:objectsBlock];
}

/// 多线程写入操作
/// @param objectsBlock 操作block
/// @param completion 完成block
- (void)writeObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                          completion:(HTRealmStoreOperationCompletion)completion {
    [HTRealmOperation writeOperationWithQueue:[[self class] queue]
                                        objectsBlock:objectsBlock
                                          completion:^(HTRealmOperation *operation)
            {
        if (completion) completion(self, operation);
    }];
}

#pragma mark Delete

/// 删除操作
/// @param objectsBlock 操作block
- (void)deleteObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    [HTRealmOperation deleteOperationWithObjectsBlock:objectsBlock];
}

/// 多线程删除操作
/// @param objectsBlock 操作block
/// @param completion 完成block
- (void)deleteObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                           completion:(HTRealmStoreOperationCompletion)completion {
    [HTRealmOperation deleteOperationWithQueue:[[self class] queue]
                                         objectsBlock:objectsBlock
                                           completion:^(HTRealmOperation *operation)
            {
        if (completion) completion(self, operation);
    }];
}

/// 删除整个数据库表
- (void)deleteAllObjects {
    [HTRealmWriteTransaction writeTransactionWithWriteBlock:^(HTRealmWriteTransaction *transaction, RLMRealm *realm) {
        [realm deleteAllObjects];
    }];
}

/// 多线程删除整个数据库表
/// @param completion 完成block
- (void)deleteAllObjectsWithCompletion:(HTRealmStoreWriteTransactionCompletion)completion {
    [HTRealmWriteTransaction writeTransactionWithQueue:[[self class] queue]
                                            writeBlock:^(HTRealmWriteTransaction *transaction, RLMRealm *realm)
     {
        [realm deleteAllObjects];
    } completion:^(HTRealmWriteTransaction *transaction) {
        if (completion) completion(self, transaction);
    }];
}

#pragma mark Fetch

/// 查找操作
/// @param objectsBlock 操作block
- (id)fetchObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    return [HTRealmOperation fetchOperationWithObjectsBlock:objectsBlock];
}

/// 多线程查找操作
/// @param objectsBlock 操作block
/// @param completion 完成block
- (void)fetchObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                          completion:(HTRealmStoreFetchOperationCompletion)completion {
    [HTRealmOperation fetchOperationWithQueue:[[self class] queue]
                                 objectsBlock:objectsBlock
                                   completion:^(HTRealmOperation *operation, RLMResults *results)
     {
        if (completion) completion(self, operation, results);
    }];
}

#pragma mark - 文件
/// 数据库文件路劲
/// @param realmName 数据库名称
+ (NSURL *)realmFileURLWithRealmName:(NSString*)realmName {
    NSParameterAssert(realmName);
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES)[0];
    path = [path stringByAppendingPathComponent:realmName];
    
    if ([path pathExtension].length == 0) {
        path = [path stringByAppendingPathExtension:@"HTRealm"];
    }
    return [NSURL fileURLWithPath:path];
}

+ (dispatch_queue_t)queue {
    static dispatch_queue_t __queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __queue = dispatch_queue_create("com.hotcoinex.HTRealmStore.queue", NULL);
    });
    return __queue;
}

@end
