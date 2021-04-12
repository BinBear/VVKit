//
//  HTRealmOperation.m
//  HeartTrip
//
//  Created by vin on 2021/3/8.
//  Copyright © 2021 BinBear All rights reserved.
//

#import "HTRealmOperation.h"

typedef NS_ENUM(NSUInteger, HTRealmOperationType) {
    HTRealmOperationTypeAddOrUpdate,
    HTRealmOperationTypeDelete,
};

@implementation HTRealmOperation

#pragma mark - Operation
#pragma mark Write

/// 写入操作
/// @param objectsBlock 操作block
+ (void)writeOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    NSParameterAssert(objectsBlock);
    
    HTRealmOperation *ope = [[self alloc] init];
    [ope writeObjectsWithObjectsBlock:objectsBlock];
}

/// 多线程写入操作
/// @param queue 线程
/// @param objectsBlock 操作block
/// @param completion 完成block
+ (instancetype)writeOperationWithQueue:(dispatch_queue_t)queue
                           objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                             completion:(HTRealmOperationCompletion)completion {
    NSParameterAssert(objectsBlock);
    
    HTRealmOperation *ope = [[self alloc] init];
    [ope writeObjectsWithQueue:queue objectsBlock:objectsBlock completion:completion];
    return ope;
}

#pragma mark Delete

/// 删除操作
/// @param objectsBlock 操作block
+ (void)deleteOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    NSParameterAssert(objectsBlock);
    
    HTRealmOperation *ope = [[self alloc] init];
    [ope deleteObjectsWithObjectsBlock:objectsBlock];
}

/// 多线程删除操作
/// @param queue 线程
/// @param objectsBlock 操作block
/// @param completion 完成block
+ (instancetype)deleteOperationWithQueue:(dispatch_queue_t)queue
                            objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                              completion:(HTRealmOperationCompletion)completion {
    NSParameterAssert(objectsBlock);
    
    HTRealmOperation *ope = [[self alloc] init];
    [ope deleteObjectsWithQueue:queue objectsBlock:objectsBlock completion:completion];
    return ope;
}

#pragma mark Fetch

/// 查找操作
/// @param objectsBlock 操作block
+ (id)fetchOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    NSParameterAssert(objectsBlock);
    
    HTRealmOperation *ope = [[self alloc] init];
    return [ope fetchOperationWithObjectsBlock:objectsBlock];
}

/// 多线程查找操作
/// @param queue 线程
/// @param objectsBlock 操作block
/// @param completion 完成block
+ (instancetype)fetchOperationWithQueue:(dispatch_queue_t)queue
                           objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                             completion:(HTRealmOperationFetchCompletion)completion {
    NSParameterAssert(objectsBlock);
    HTRealmOperation *ope = [[self alloc] init];
    [ope fetchOperationWithQueue:queue objectsBlock:objectsBlock completion:completion];
    return ope;
}

#pragma mark - Operation Private
#pragma mark Write

- (void)writeObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    [self writeObjectsWithObjectsBlock:objectsBlock
                                  type:HTRealmOperationTypeAddOrUpdate];
}

- (void)writeObjectsWithQueue:(dispatch_queue_t)queue
                 objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                   completion:(HTRealmOperationCompletion)completion {
    dispatch_async(queue, ^{
        [self writeObjectsWithObjectsBlock:objectsBlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(self);
        });
    });
}

#pragma mark Delete

- (void)deleteObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    [self writeObjectsWithObjectsBlock:objectsBlock
                                  type:HTRealmOperationTypeDelete];
}

- (void)deleteObjectsWithQueue:(dispatch_queue_t)queue
                  objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                    completion:(HTRealmOperationCompletion)completion {
    dispatch_async(queue, ^{
        [self deleteObjectsWithObjectsBlock:objectsBlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(self);
        });
    });
}

#pragma mark Fetch

- (id)fetchOperationWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    return objectsBlock ? objectsBlock(self, realm) : nil;
}

- (void)fetchOperationWithQueue:(dispatch_queue_t)queue
                   objectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                     completion:(HTRealmOperationFetchCompletion)completion {
    dispatch_async(queue, ^{
        NSMutableArray *values;
        Class resultClass;
        NSString *primaryKey;
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        id results = objectsBlock ? objectsBlock(self, realm) : nil;
        
        if (results) {
            if (![results conformsToProtocol:@protocol(NSFastEnumeration)]) {
                results = @[results];
            }
            NSParameterAssert([results isKindOfClass:[NSArray class]]
                              || [results isKindOfClass:[RLMArray class]]
                              || [results isKindOfClass:[RLMResults class]]);
            
            values = [NSMutableArray arrayWithCapacity:[results count]];
            RLMObject *result = [results firstObject];
            resultClass = [result class];
            primaryKey = [resultClass primaryKey];
            
            if (result) {
                if (resultClass && primaryKey) {
                    for (RLMObject *obj in results) {
                        NSParameterAssert([obj isKindOfClass:[RLMObject class]]);
                        [values addObject:[obj valueForKey:primaryKey]];
                    }
                } else {
                    NSAssert3(false, @"%s; 必须要有主键; class = %@, 主键 = %@", __func__, NSStringFromClass(resultClass), primaryKey);
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RLMResults *results;
            if ([values count] > 0 && resultClass && primaryKey) {
                results = [resultClass objectsInRealm:realm
                                                where:@"%K IN %@", primaryKey, values];
            }
            
            if (completion) completion(self, results);
        });
    });
}

#pragma mark Private

- (void)writeObjectsWithObjectsBlock:(HTRealmOperationObjectsBlock)objectsBlock
                                type:(HTRealmOperationType)type {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    id object = objectsBlock ? objectsBlock(self, realm) : nil;
    
    if (object) {
        if (![object conformsToProtocol:@protocol(NSFastEnumeration)]) {
            object = @[object];
        }
        switch (type) {
            case HTRealmOperationTypeAddOrUpdate:
                [realm addOrUpdateObjects:object];
                break;
            case HTRealmOperationTypeDelete:
                [realm deleteObjects:object];
                break;
            default:
                NSAssert1(false, @"不支持的操作类型 = %zd;", type);
                break;
        }
    }
    
    [realm commitWriteTransaction];
}

@end
