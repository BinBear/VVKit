//
//  UINavigationController+HookExtention.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/26.
//

#import "UINavigationController+HookExtention.h"
#import "UIViewController+HookExtention.h"

@implementation UINavigationController (HookExtention)


- (nullable UIViewController *)vv_rootViewController {
    return self.viewControllers.firstObject;
}


- (nullable UIViewController *)vv_viewControllerFromIndex:(NSInteger)index {
    if (index >= 0 && index < self.childViewControllers.count) {
        return [self.childViewControllers objectAtIndex:index];
    }
    return nil;
}

- (nullable UIViewController *)vv_viewControllerToIndex:(NSInteger)index {
    return [self vv_viewControllerFromIndex:self.viewControllers.count - 1 - index];
}

- (nullable UIViewController *)vv_viewControllerWithName:(NSString *)name {
    
    __block UIViewController *vc;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:name]) {
            vc = obj;
            *stop = YES;
        }
    }];
    return vc;
}

- (void)vv_popToViewControllerWithName:(NSString *)name animated:(BOOL)animated {
    
    UIViewController *vc = [self vv_viewControllerWithName:name];
    if (vc) {
        [self popToViewController:vc animated:animated];
    }
}

- (void)vv_popToViewControllerWithToIndex:(NSInteger)index animated:(BOOL)animated {
    
    UIViewController *vc = [self vv_viewControllerFromIndex:index];
    if (vc) {
        [self popToViewController:vc animated:animated];
    }
}

- (void)vv_popToViewControllerWithFromIndex:(NSInteger)index animated:(BOOL)animated {
    
    UIViewController *vc = [self vv_viewControllerFromIndex:self.childViewControllers.count - index - 1];
    if (vc) {
        [self popToViewController:vc animated:animated];
    }
}

- (void)vv_removeViewControllerWithName:(NSString *)name {
    
    UIViewController *vc = [self vv_viewControllerWithName:name];
    if (vc) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:vc];
        [self setViewControllers:arr.copy];
    }
}

- (void)vv_removeViewControllerFromIndex:(NSInteger)index {
    
    UIViewController *vc = [self vv_viewControllerFromIndex:index];
    if (vc) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:vc];
        [self setViewControllers:arr.copy];
    }
}
- (void)vv_removeViewControllerToIndex:(NSInteger)index {
 
    UIViewController *vc = [self vv_viewControllerFromIndex:self.childViewControllers.count - index - 1];
    if (vc) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:vc];
        [self setViewControllers:arr.copy];
    }
}

- (BOOL)vv_containViewControllerWithName:(NSString *)name {
    return [self vv_viewControllerWithName:name] ? YES : NO;
}

- (void)vv_repleaseViewControllerAtIndex:(NSInteger )index
                          withController:(UIViewController *)controller {
 
    if (index >= 0 && index < self.viewControllers.count) {
        controller.hidesBottomBarWhenPushed = index!= 0 ? YES : NO;
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr replaceObjectAtIndex:index withObject:controller];
        [self setViewControllers:arr.copy];
    }
}

- (void)vv_pushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^_Nullable)(void))completion {
    
    [self vv_hookDidAppearWithViewController:viewController completion:completion];
    [self pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)vv_popViewControllerAnimated:(BOOL)animated
                                                 completion:(void (^_Nullable)(void))completion {
    
    if (self.viewControllers.count > 1) {
        NSInteger index = self.viewControllers.count - 2;
        [self vv_hookDidAppearWithViewController:self.viewControllers[index] completion:completion];
    }
    return [self popViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)vv_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated
                                                               completion:(void (^_Nullable)(void))completion {
    
    if (self.viewControllers.count > 1 && [self.viewControllers containsObject:viewController]) {
        [self vv_hookDidAppearWithViewController:viewController completion:completion];
    }
    return [self popToViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)vv_popToRootViewControllerAnimated:(BOOL)animated
                                                                           completion:(void (^_Nullable)(void))completion {
    
    if (self.viewControllers.count > 1) {
        [self vv_hookDidAppearWithViewController:self.viewControllers.firstObject completion:completion];
    }
    return [self popToRootViewControllerAnimated:animated];
}

- (void)vv_hookDidAppearWithViewController:(UIViewController *)viewController
                                completion:(void (^)(void))completion {
 
    if (viewController && completion) {
        viewController.vv_viewDidAppearBlock = ^(UIViewController * _Nonnull _self, BOOL animated) {
            !completion ?: completion();
        };
    }
}


@end
