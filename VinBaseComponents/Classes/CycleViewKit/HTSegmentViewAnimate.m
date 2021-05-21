//
//  HTSegmentViewAnimate.m
//  HeartTrip
//
//  Created by vin on 2020/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTSegmentViewAnimate.h"

@interface HTSegmentViewAnimate ()
@property (nonatomic,assign) NSTimeInterval animateBeginTime;
@property (nonatomic,assign) NSTimeInterval animateDuration;
@property (nonatomic,copy) void(^animations)(CGFloat progress);
@end

@implementation HTSegmentViewAnimate
- (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void (^)(CGFloat progress))animations {
    self.animateDuration = duration;
    self.animateBeginTime = CACurrentMediaTime();
    self.animations = animations;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    NSTimeInterval currentTime = CACurrentMediaTime() - self.animateBeginTime;
    CGFloat progress = currentTime / self.animateDuration;
    if (progress > 1) {
        progress = 1;
        [displayLink invalidate];
        displayLink = nil;
    }
    !self.animations ?: self.animations(progress);
}
@end
