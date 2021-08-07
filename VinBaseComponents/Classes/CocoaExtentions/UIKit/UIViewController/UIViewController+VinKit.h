//
//  UIViewController+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (VinKit)

@property (nonatomic,copy,nullable) void(^vv_viewDidLoadBlock)(UIViewController *_self);
@property (nonatomic,copy,nullable) void(^vv_viewWillAppearBlock)(UIViewController *_self, BOOL animated);
@property (nonatomic,copy,nullable) void(^vv_viewDidAppearBlock)(UIViewController *_self, BOOL animated);
@property (nonatomic,copy,nullable) void(^vv_viewWillLayoutSubviewsBlock)(UIViewController *_self);
@property (nonatomic,copy,nullable) void(^vv_viewDidLayoutSubviewsBlock)(UIViewController *_self);

@property (nonatomic,copy,nullable) void(^vv_viewWillDisappearBlock)(UIViewController *_self, BOOL animated);
@property (nonatomic,copy,nullable) void(^vv_viewDidDisappearBlock)(UIViewController *_self, BOOL animated);


+ (nullable UIViewController *)vv_currentViewController;
- (nullable UIViewController *)vv_childViewControllerWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
