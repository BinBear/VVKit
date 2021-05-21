//
//  HTSegmentViewAnimate.h
//  HeartTrip
//
//  Created by vin on 2020/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSegmentViewAnimate : NSObject
- (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(CGFloat progress))animations;
@end

NS_ASSUME_NONNULL_END
