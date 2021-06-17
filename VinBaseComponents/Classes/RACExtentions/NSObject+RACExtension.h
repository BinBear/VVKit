//
//  NSObject+RACExtension.h
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RACExtension)

#pragma mark - SEL
@property (nonatomic,copy,readonly) RACSignal<RACTuple *> *(^signalForSelector)(SEL);
@property (nonatomic,copy,readonly) RACSignal<RACTuple *> *(^signalForSelectorFromProtocol)(SEL, Protocol *);
@property (nonatomic,copy,readonly) RACSignal *(^liftSelectorWithSignals)(SEL, NSArray<RACSignal *> *);

@end

/// GCD延迟执行
CG_INLINE void
ht_dispatch_after(CGFloat delayInSeconds, void(^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

/// 主线程执行
CG_INLINE void
ht_dispatch_main_async_safe(void(^block)(void)) {
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        if (block) { block();}
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

NS_ASSUME_NONNULL_END
