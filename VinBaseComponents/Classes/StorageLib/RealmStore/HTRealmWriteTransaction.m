//
//  HTRealmWriteTransaction.m
//  HeartTrip
//
//  Created by vin on 2021/3/8.
//  Copyright © 2021 BinBear All rights reserved.
//

#import "HTRealmWriteTransaction.h"

@implementation HTRealmWriteTransaction

/// 事务写入
/// @param writeBlock 写入block
+ (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock {
    
    HTRealmWriteTransaction *trans = [[self alloc] init];
    [trans writeTransactionWithWriteBlock:writeBlock];
}


/// 多线程事务写入
/// @param queue 线程
/// @param writeBlock 写入block
/// @param completion 完成block
+ (void)writeTransactionWithQueue:(dispatch_queue_t)queue
                       writeBlock:(HTRealmWriteTransactionWriteBlock)writeBlock
                       completion:(HTRealmWriteTransactionCompletion)completion {
    
    HTRealmWriteTransaction *trans = [[self alloc] init];
    [trans writeTransactionWithQueue:queue writeBlock:writeBlock completion:completion];
}


#pragma mark - Transaction Private
- (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    if (writeBlock) writeBlock(self, realm);
    [realm commitWriteTransaction];
}

- (void)writeTransactionWithQueue:(dispatch_queue_t)queue
                       writeBlock:(HTRealmWriteTransactionWriteBlock)writeBlock
                       completion:(HTRealmWriteTransactionCompletion)completion {
    dispatch_async(queue, ^{
        [self writeTransactionWithWriteBlock:writeBlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(self);
        });
    });
}

@end
