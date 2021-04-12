//
//  RACSubject+Extension.h
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "RACSignal+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACSubject (Extension)

@property (nonatomic,copy,readonly) void(^sendWithInputBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(id))(^sendWithInputHandlerBlock)(id(^_Nullable)(id value));
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^sendWithVoidBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^sendWithVoidHandlerBlock)(id(^_Nullable)(void));

@property (nonatomic,copy,readonly) void (^send)(id _Nullable input);
@property (nonatomic,copy,readonly) void (^sendFromSignal)(RACSignal *signal, id(^_Nullable)(id value));


@end

NS_ASSUME_NONNULL_END
