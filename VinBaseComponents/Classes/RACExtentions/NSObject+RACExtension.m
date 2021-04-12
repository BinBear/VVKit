//
//  NSObject+RACExtension.m
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "NSObject+RACExtension.h"

@implementation NSObject (RACExtension)

- (RACSignal<RACTuple *> * _Nonnull (^)(SEL _Nonnull))signalForSelector {
    return ^(SEL sel) {
        return [self rac_signalForSelector:sel];
    };
}

- (RACSignal<RACTuple *> * _Nonnull (^)(SEL _Nonnull, Protocol * _Nonnull))signalForSelectorFromProtocol {
    return ^(SEL sel, Protocol *protocol) {
        return [self rac_signalForSelector:sel fromProtocol:protocol];
    };
}

- (RACSignal * _Nonnull (^)(SEL _Nonnull, NSArray<RACSignal *> * _Nonnull))liftSelectorWithSignals {
    return ^(SEL sel, NSArray<RACSignal *> *signals) {
        return [self rac_liftSelector:sel withSignalsFromArray:signals];
    };
}

@end
