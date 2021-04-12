//
//  HTRealmWriteTransaction.h
//  HeartTrip
//
//  Created by vin on 2021/3/8.
//  Copyright © 2021 BinBear All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@class HTRealmWriteTransaction;

typedef void(^HTRealmWriteTransactionWriteBlock)(HTRealmWriteTransaction *transaction, RLMRealm *realm);
typedef void(^HTRealmWriteTransactionCompletion)(HTRealmWriteTransaction *transaction);

@interface HTRealmWriteTransaction : NSObject

/// 事务写入
/// @param writeBlock 写入block
+ (void)writeTransactionWithWriteBlock:(HTRealmWriteTransactionWriteBlock)writeBlock;


/// 多线程事务写入
/// @param queue 线程
/// @param writeBlock 写入block
/// @param completion 完成block
+ (void)writeTransactionWithQueue:(dispatch_queue_t)queue
                       writeBlock:(HTRealmWriteTransactionWriteBlock)writeBlock
                       completion:(HTRealmWriteTransactionCompletion)completion;

@end

NS_ASSUME_NONNULL_END
