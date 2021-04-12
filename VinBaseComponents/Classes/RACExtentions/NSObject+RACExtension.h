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

NS_ASSUME_NONNULL_END
