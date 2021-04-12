//
//  UIGestureRecognizer+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/6.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIGestureRecognizer (BinAdd)

- (instancetype)initWithActionBlock:(void (^)(id sender))block;

- (void)addActionBlock:(void (^)(id sender))block;

- (void)removeAllActionBlocks;
@end
NS_ASSUME_NONNULL_END
