//
//  UIScrollView+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UIScrollView+BlockExtention.h"




@interface HTScrollViewDelegateConfigure () <UIScrollViewDelegate>
@property (nonatomic,copy) void (^scrollViewDidScroll)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidZoom)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewWillBeginDragging)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewWillBeginDecelerating)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidEndDecelerating)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidEndScrollingAnimation)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidScrollToTop)(UIScrollView *scrollView);
@property (nonatomic,copy) BOOL (^scrollViewShouldScrollToTop)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewDidChangeAdjustedContentInset)(UIScrollView *scrollView);
@property (nonatomic,copy) UIView *(^viewForZoomingInScrollView)(UIScrollView *scrollView);
@property (nonatomic,copy) void (^scrollViewWillBeginZooming)(UIScrollView *scrollView, UIView *view);
@property (nonatomic,copy) void (^scrollViewDidEndZooming)(UIScrollView *scrollView, UIView *view, CGFloat scale);
@property (nonatomic,copy) void (^scrollViewWillEndDragging)(UIScrollView *scrollView, CGPoint velocity, CGPoint targetContentOffset);
@property (nonatomic,copy) void (^scrollViewDidEndDragging)(UIScrollView *scrollView, BOOL willDecelerate);
@end


@implementation HTScrollViewDelegateConfigure

- (HTScrollViewDelegateConfigure *(^)(NSString *, id (^)(void)))addDelegateMethod {

    @weakify(self);
    return ^(NSString *selString, id (^impBlock)(void)) {
        @strongify(self);
        // 注册方法
        SEL sel = sel_registerName(selString.UTF8String);
        // 判断是否已经添加过该方法
        Method method = class_getInstanceMethod([self class], sel);
        if (!method) {
            if (impBlock) {
                // 获取方法的type
                const char *methodTypes = method_getTypeEncoding(method) ?: "v@:";
                class_addMethod(self.class, sel, imp_implementationWithBlock(impBlock()), methodTypes);
            }
        }
        return self;
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewDidScroll {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewDidScroll = [block copy];
        return self.addDelegateMethod(@"scrollViewDidScroll:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewDidScroll ?:_self.scrollViewDidScroll(_scrollview);
            };
        });
    };
    
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewDidZoom {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewDidZoom = [block copy];
        return self.addDelegateMethod(@"scrollViewDidZoom:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewDidZoom ?:_self.scrollViewDidZoom(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewWillBeginDragging {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewWillBeginDragging = [block copy];
        return self.addDelegateMethod(@"scrollViewWillBeginDragging:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewWillBeginDragging ?:_self.scrollViewWillBeginDragging(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewWillBeginDecelerating {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewWillBeginDecelerating = [block copy];
        return self.addDelegateMethod(@"scrollViewWillBeginDecelerating:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewWillBeginDecelerating ?:_self.scrollViewWillBeginDecelerating(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewDidEndDecelerating {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewDidEndDecelerating = [block copy];
        return self.addDelegateMethod(@"scrollViewDidEndDecelerating:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewDidEndDecelerating ?:_self.scrollViewDidEndDecelerating(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewDidEndScrollingAnimation {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewDidEndScrollingAnimation = [block copy];
        return self.addDelegateMethod(@"scrollViewDidEndScrollingAnimation:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewDidEndScrollingAnimation ?:_self.scrollViewDidEndScrollingAnimation(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewDidScrollToTop {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewDidScrollToTop = [block copy];
        return self.addDelegateMethod(@"scrollViewDidScrollToTop:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewDidScrollToTop ?:_self.scrollViewDidScrollToTop(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *)))configScrollViewDidChangeAdjustedContentInset {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewDidChangeAdjustedContentInset = [block copy];
        return self.addDelegateMethod(@"scrollViewDidChangeAdjustedContentInset:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                !_self.scrollViewDidChangeAdjustedContentInset ?:_self.scrollViewDidChangeAdjustedContentInset(_scrollview);
            };
        });
    };
}


- (HTScrollViewDelegateConfigure *(^)(BOOL (^)(UIScrollView *)))configScrollViewShouldScrollToTop {
    
    @weakify(self);
    return ^(BOOL (^block)(UIScrollView *)){
        @strongify(self);
        self.scrollViewShouldScrollToTop = [block copy];
        return self.addDelegateMethod(@"scrollViewShouldScrollToTop:", ^id {
            return ^BOOL(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                return !_self.scrollViewShouldScrollToTop ? YES :_self.scrollViewShouldScrollToTop(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(UIView *(^)(UIScrollView *)))configScrollViewForZoomingInScrollView {
    
    @weakify(self);
    return ^(UIView *(^block)(UIScrollView *scrollView)){
        @strongify(self);
        self.viewForZoomingInScrollView = [block copy];
        return self.addDelegateMethod(@"viewForZoomingInScrollView:", ^id {
            return ^UIView *(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview) {
                return !_self.viewForZoomingInScrollView ? nil :_self.viewForZoomingInScrollView(_scrollview);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *, UIView *)))configScrollViewWillBeginZooming {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *, UIView *)){
        @strongify(self);
        self.scrollViewWillBeginZooming = [block copy];
        return self.addDelegateMethod(@"scrollViewWillBeginZooming:withView:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview, UIView *_view) {
                !_self.scrollViewWillBeginZooming ?:_self.scrollViewWillBeginZooming(_scrollview,_view);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *, UIView *, CGFloat)))configScrollViewDidEndZooming {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *, UIView *, CGFloat)){
        @strongify(self);
        self.scrollViewDidEndZooming = [block copy];
        return self.addDelegateMethod(@"scrollViewDidEndZooming:withView:atScale:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview, UIView *_view, CGFloat _scale) {
               !_self.scrollViewDidEndZooming ?:_self.scrollViewDidEndZooming(_scrollview, _view, _scale);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *, CGPoint, CGPoint)))configScrollViewWillEndDragging {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *, CGPoint, CGPoint)){
        @strongify(self);
        self.scrollViewWillEndDragging = [block copy];
        return self.addDelegateMethod(@"scrollViewWillEndDragging:withVelocity:targetContentOffset:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview, CGPoint _velocity,  CGPoint _targetContentOffset) {
               !_self.scrollViewWillEndDragging ?:_self.scrollViewWillEndDragging(_scrollview, _velocity, _targetContentOffset);
            };
        });
    };
}

- (HTScrollViewDelegateConfigure *(^)(void (^)(UIScrollView *, BOOL)))configScrollViewDidEndDragging {
    
    @weakify(self);
    return ^(void (^block)(UIScrollView *, BOOL)){
        @strongify(self);
        self.scrollViewDidEndDragging = [block copy];
        return self.addDelegateMethod(@"scrollViewDidEndDragging:willDecelerate:", ^id {
            return ^(HTScrollViewDelegateConfigure *_self, UIScrollView *_scrollview, BOOL _decelerate) {
               !_self.scrollViewDidEndDragging ?:_self.scrollViewDidEndDragging(_scrollview, _decelerate);
            };
        });
    };
}

- (void)dealloc {
    if (![self isMemberOfClass:HTScrollViewDelegateConfigure.class] &&
        [NSStringFromClass(self.class) hasSuffix:@"HTScrollViewDelegateConfigure_"]) {
        Class cls = self.class;
        objc_disposeClassPair(cls);
    }
}
@end

@interface UIScrollView ()
@property (nonatomic,strong) HTScrollViewDelegateConfigure *ht_delegateConfigure;
@end
@implementation UIScrollView (BlockExtention)
+ (instancetype)ht_scrollViewWithFrame:(CGRect)frame
                              delegate:(id<UIScrollViewDelegate>)delegate {
    
    UIScrollView *scrollView = [[self alloc] initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.delegate = delegate;
    return scrollView;
}

+ (instancetype)ht_scrollViewWithFrame:(CGRect)frame
                     delegateConfigure:(void(^)(HTScrollViewDelegateConfigure *configure))delegateConfigure {
    
    UIScrollView *scrollView = [[self alloc] initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.ht_delegateConfigure = scrollView.delegateInstance;
    !delegateConfigure ?: delegateConfigure(scrollView.ht_delegateConfigure);
    scrollView.delegate = scrollView.ht_delegateConfigure;
    return scrollView;
}

- (HTScrollViewDelegateConfigure *)delegateInstance {
    const char *clasName = [[NSString stringWithFormat:@"HTScrollViewDelegateConfigure_%d_%d", arc4random() % 100, arc4random() % 100] cStringUsingEncoding:NSASCIIStringEncoding];
    if (!objc_getClass(clasName)){
        objc_registerClassPair(objc_allocateClassPair(HTScrollViewDelegateConfigure.class, clasName, 0));
        return [[objc_getClass(clasName) alloc] init];;
    }
    // 尾递归调用
    return [self delegateInstance];
}

- (void)setHt_delegateConfigure:(HTScrollViewDelegateConfigure *)ht_delegateConfigure {
    
    objc_setAssociatedObject(self,
                             @selector(ht_delegateConfigure),
                             ht_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTScrollViewDelegateConfigure *)ht_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)ht_isAtTop {
    if (((NSInteger)self.contentOffset.y) == -((NSInteger)self.ht_contentInset.top)) {
        return YES;
    }
    return NO;
}

- (BOOL)ht_isAtBottom {
    if (!self.ht_canScroll) {
        return YES;
    }
    if (((NSInteger)self.contentOffset.y) == ((NSInteger)self.contentSize.height + self.ht_contentInset.bottom - CGRectGetHeight(self.bounds))) {
        return YES;
    }
    return NO;
}

- (BOOL)ht_isAtLeft {
    if (((NSInteger)self.contentOffset.x) == -((NSInteger)self.ht_contentInset.left)) {
        return YES;
    }
    return NO;
}

- (BOOL)ht_isAtRight {
    if (!self.ht_canScroll) {
        return YES;
    }
    if (((NSInteger)self.contentOffset.x) == ((NSInteger)self.contentSize.width + self.ht_contentInset.left - CGRectGetWidth(self.bounds))) {
        return YES;
    }
    return NO;
}

- (BOOL)ht_canScroll {
    
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + self.ht_contentInset.top + self.ht_contentInset.bottom > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + self.ht_contentInset.left + self.ht_contentInset.right > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (UIEdgeInsets)ht_contentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.ht_contentInset;
    }
}

- (void)ht_scrollToTopAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.y = 0 - self.ht_contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)ht_scrollToBottomAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.ht_contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)ht_scrollToLeftAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.x = 0 - self.ht_contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)ht_scrollToRightAnimated:(BOOL)animated {
    
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.ht_contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
