//
//  UIImage+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/6.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIImage (BinAdd)

#pragma mark - Create image
+ (nullable UIImage *)imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;


+ (BOOL)isAnimatedGIFData:(NSData *)data;


+ (BOOL)isAnimatedGIFFile:(NSString *)path;


+ (nullable UIImage *)imageWithPDF:(id)dataOrPath;


+ (nullable UIImage *)imageWithPDF:(id)dataOrPath size:(CGSize)size;


+ (nullable UIImage *)imageWithEmoji:(NSString *)emoji size:(CGFloat)size;


+ (nullable UIImage *)imageWithColor:(UIColor *)color;


+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


+ (nullable UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;


@end
NS_ASSUME_NONNULL_END
