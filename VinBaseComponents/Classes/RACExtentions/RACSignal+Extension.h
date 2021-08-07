//
//  RACSignal+Extension.h
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (Extension)

@property (nonatomic,copy,readonly) RACSignal *(^flattenMap)(RACSignal *(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^map)(id(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^mapReplace)(id value);
@property (nonatomic,copy,readonly) RACSignal *(^filter)(BOOL(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^ignore)(id value);
@property (nonatomic,copy,readonly) RACSignal *(^reduceEach)(RACReduceBlock);
@property (nonatomic,copy,readonly) RACSignal *(^startWith)(id value);
@property (nonatomic,copy,readonly) RACSignal *(^skip)(NSUInteger skipCount);
@property (nonatomic,copy,readonly) RACSignal *(^take)(NSUInteger takeCount);
@property (nonatomic,copy,readonly) RACSignal *(^delay)(NSTimeInterval interval);
@property (nonatomic,copy,readonly) RACSignal *(^throttle)(NSTimeInterval interval);
@property (nonatomic,copy,readonly) RACSignal *(^doNext)(void(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^doError)(void(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^doCompleted)(void(^)(void));

@property (nonatomic,copy,readonly) RACDisposable *(^subscribe)(id<RACSubscriber>);
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeNext)(void(^)(id value));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeError)(void(^)(NSError *error));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeCompleted)(void(^)(void));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeAll)(void(^_Nullable)(id value), void(^_Nullable)(NSError *error), void(^_Nullable)(void));

@end

#pragma mark - Method
/// 创建一个空信号
CG_INLINE RACSignal *
ht_createSignal(RACDisposable * _Nullable (^block)(id<RACSubscriber> subscriber)) {
    return [RACSignal createSignal:block];
}

/// 创建一个有返回的信号
CG_INLINE RACSignal *
ht_signalWithValue(id _Nullable value) {
    return [RACSignal return:value];
}

/// 创建一个空信号，并执行block
CG_INLINE RACSignal *
ht_signalWithAction(void(^block)(void)) {
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        !block ?: block();
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

/// 创建一个reduceEach信号
CG_INLINE RACSignal *
ht_combineLatestAndReduceEach(NSArray<RACSignal *> *signals, RACReduceBlock block){
    return
    [[[RACSignal combineLatest:signals] reduceEach:block] distinctUntilChanged];
}

/// 创建一个RACCommand的executingSignals集合信号
CG_INLINE RACSignal *
ht_signalsCompletedWithcommands(NSArray<RACCommand *> *commands) {
     NSMutableArray<RACSignal *> *executingSignals = @[].mutableCopy;
     [commands enumerateObjectsUsingBlock:^(RACCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [executingSignals addObject:[obj.executing skip:1]];
     }];
     return  executingSignals ?
    [RACSignal combineLatest:executingSignals].or.distinctUntilChanged :
    [RACSignal empty];
}

/// 创建一个UIButton的点击信号
CG_INLINE RACDisposable *
ht_rac_btn(UIButton *btn, void(^subscribeNext)(UIButton *x)) {
    return
    [btn rac_signalForControlEvents:UIControlEventTouchUpInside].deliverOnMainThread.subscribeNext(subscribeNext);
}

/// 创建一个定时器信号
CG_INLINE RACSignal *
ht_signalInterval(NSTimeInterval interval) {
    return [RACSignal interval:interval onScheduler:[RACScheduler mainThreadScheduler]];
}

NS_ASSUME_NONNULL_END
