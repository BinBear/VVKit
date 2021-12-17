//
//  UIViewController+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/26.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , VVShadowPathType) {
    VVShadowPathType_Top    = 1,
    VVShadowPathType_Bottom = 2,
    VVShadowPathType_Left   = 3,
    VVShadowPathType_Right  = 4,
    VVShadowPathType_Around = 5,
};

@interface UIView (VinKit)

@property (nonatomic,strong,readonly) NSData *vv_snapshotPDF;
@property (nonatomic,strong,readonly) UIImage *vv_snapshotImage;

- (UIImage *)vv_snapshotImageWithRect:(CGRect)frame;
- (UIImage *)vv_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

- (void)vv_viewShadowPathWithColor:(UIColor *)shadowColor
                     shadowOpacity:(CGFloat)shadowOpacity
                      shadowRadius:(CGFloat)shadowRadius
                    shadowPathType:(VVShadowPathType)shadowPathType
                   shadowPathWidth:(CGFloat)shadowPathWidth;
@end

@interface UIView (VinFrame)

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic, readonly) CGPoint middlePoint;

- (UIView *(^)(CGFloat left, CGFloat top, CGFloat width, CGFloat heigth))rectValue;

- (UIView *(^)(CGFloat value))widthValue;
- (UIView *(^)(CGFloat value))heightValue;
- (UIView *(^)(CGFloat width, CGFloat height))sizeValue;

- (UIView *(^)(CGFloat value))leftValue;
- (UIView *(^)(CGFloat value))topValue;
- (UIView *(^)(CGFloat value))rightValue;
- (UIView *(^)(CGFloat value))bottomValue;

- (UIView *(^)(CGFloat value))centerXValue;
- (UIView *(^)(CGFloat value))centerYValue;
- (UIView *(^)(CGFloat left, CGFloat top))originValue;


- (UIView *(^)(UIView *value))widthIsEqualTo;
- (UIView *(^)(UIView *value))heightIsEqualTo;
- (UIView *(^)(UIView *value))sizeIsEqualTo;

- (UIView *(^)(UIView *value))leftIsEqualTo;
- (UIView *(^)(UIView *value))topIsEqualTo;
- (UIView *(^)(UIView *value))rightIsEqualTo;
- (UIView *(^)(UIView *value))bottomIsEqualTo;

- (UIView *(^)(UIView *value))centerXIsEqualTo;
- (UIView *(^)(UIView *value))centerYIsEqualTo;
- (UIView *(^)(UIView *value))originIsEqualTo;


@end



