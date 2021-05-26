//
//  UINavigationController+HookExtention.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (HookExtention)

@property (nonatomic,weak,readonly,nullable) UIViewController *vv_rootViewController;

- (nullable UIViewController *)vv_viewControllerFromIndex:(NSInteger)index;
- (nullable UIViewController *)vv_viewControllerToIndex:(NSInteger)index;
- (nullable UIViewController *)vv_viewControllerWithName:(NSString *)name;

- (void)vv_popToViewControllerWithName:(NSString *)name animated:(BOOL)animated;
- (void)vv_popToViewControllerWithToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)vv_popToViewControllerWithFromIndex:(NSInteger)index animated:(BOOL)animated;

- (void)vv_removeViewControllerWithName:(NSString *)name;
- (void)vv_removeViewControllerFromIndex:(NSInteger)index;
- (void)vv_removeViewControllerToIndex:(NSInteger)index;

- (BOOL)vv_containViewControllerWithName:(NSString *)name;

- (void)vv_repleaseViewControllerAtIndex:(NSInteger )index
                         withController:(UIViewController *)controller;


- (void)vv_pushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^_Nullable)(void))completion;

- (nullable UIViewController *)vv_popViewControllerAnimated:(BOOL)animated
                                                 completion:(void (^_Nullable)(void))completion;

- (nullable NSArray<__kindof UIViewController *> *)vv_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated
                                                               completion:(void (^_Nullable)(void))completion;

- (nullable NSArray<__kindof UIViewController *> *)vv_popToRootViewControllerAnimated:(BOOL)animated
                                                                           completion:(void (^_Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
