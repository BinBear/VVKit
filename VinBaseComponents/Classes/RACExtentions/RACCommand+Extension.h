//
//  RACCommand+Extension.h
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "RACSignal+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACCommand (Extension)

@property (nonatomic,copy,readonly) void(^executeWithInputBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(id))(^executeWithInputHandlerBlock)(id(^_Nullable)(id value));
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^executeWithVoidBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^executeWithVoidHandlerBlock)(id(^_Nullable)(void));

@property (nonatomic,copy,readonly) RACSignal *(^execute)(id _Nullable input);
@property (nonatomic,copy,readonly) RACSignal *(^executeFromSignal)(RACSignal *signal, id(^_Nullable)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^executeToSignal)(id input, RACSignal *(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^executeFromToSignal)(RACSignal *signal, id(^_Nullable)(id value), RACSignal *(^)(id value));

@property (nonatomic,strong,readonly) RACSignal *signal;
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeNext)(void (^)(id value));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeError)(void (^)(NSError *error));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeCompleted)(void (^)(id value));
@property (nonatomic,copy,readonly) NSArray<RACDisposable *> *(^subscribeAll)(void (^_Nullable)(id value), void (^_Nullable)(NSError *error), void (^_Nullable)(id value));

@end

/// 创建一个RACCommand
CG_INLINE RACCommand *
ht_command(RACSignal<NSNumber *> * _Nullable enabledSignal, void(^_Nullable inputHandler)(id _Nullable input), RACSignal *(^_Nullable signalBlock)(id _Nullable value)) {
    RACSignal *enabledS = enabledSignal ?: ht_signalWithValue(@YES);
    return [[RACCommand alloc] initWithEnabled:enabledS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        !inputHandler ?: inputHandler(input);
        return (signalBlock ? signalBlock(input) : nil) ?: ht_signalWithValue(input);
    }];
}

/// 创建一个RACCommand
CG_INLINE RACCommand *
ht_commandWithAction(void(^block)(id input)) {
    return ht_command(nil, block, nil);
}

/// 根据enable信号，创建一个RACCommand
CG_INLINE RACCommand *
ht_commandWithEnabledAction(RACSignal<NSNumber *> *signal, void(^block)(id input)) {
    return ht_command(signal, block, nil);
}

/// 创建一个RACCommand
CG_INLINE RACCommand *
ht_commandWithSignal(RACSignal *(^block)(id input)) {
    return ht_command(nil, nil, block);
}

/// 根据enable信号，创建一个RACCommand
CG_INLINE RACCommand *
ht_commandWithEnabledSignal(RACSignal<NSNumber *> *signal, RACSignal *(^block)(id input)) {
    return ht_command(signal, nil , block);
}

NS_ASSUME_NONNULL_END
