//
//  UIScrollView+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTScrollViewDelegateConfigure : NSObject
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^addDelegateMethod)(NSString *method, id (^)(void));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidScroll)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidZoom)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewWillBeginDragging)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewWillBeginDecelerating)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidEndDecelerating)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidEndScrollingAnimation)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidScrollToTop)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidChangeAdjustedContentInset)(void (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewShouldScrollToTop)(BOOL (^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewForZoomingInScrollView)(UIView *(^)(UIScrollView *scrollView));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewWillBeginZooming)(void (^)(UIScrollView *scrollView, UIView *view));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidEndZooming)(void (^)(UIScrollView *scrollView, UIView *view, CGFloat scale));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewWillEndDragging)(void (^)(UIScrollView *scrollView, CGPoint velocity, CGPoint targetContentOffset));
@property (nonatomic,copy,readonly) HTScrollViewDelegateConfigure *(^configScrollViewDidEndDragging)(void (^)(UIScrollView *scrollView, BOOL willDecelerate));
@end


@interface UIScrollView (BlockExtention)


@property (nonatomic,assign,readonly) BOOL ht_canScroll;
@property (nonatomic,assign,readonly) BOOL ht_isAtTop;
@property (nonatomic,assign,readonly) BOOL ht_isAtBottom;
@property (nonatomic,assign,readonly) BOOL ht_isAtLeft;
@property (nonatomic,assign,readonly) BOOL ht_isAtRight;
@property (nonatomic,assign,readonly) UIEdgeInsets ht_contentInset;
@property (nonatomic,strong,readonly) HTScrollViewDelegateConfigure *ht_delegateConfigure;


+ (instancetype)ht_scrollViewWithFrame:(CGRect)frame
                              delegate:(id<UIScrollViewDelegate>)delegate;

+ (instancetype)ht_scrollViewWithFrame:(CGRect)frame
                     delegateConfigure:(void(^)(HTScrollViewDelegateConfigure *configure))delegateConfigure;


- (void)ht_scrollToTopAnimated:(BOOL)animated;
- (void)ht_scrollToBottomAnimated:(BOOL)animated;
- (void)ht_scrollToLeftAnimated:(BOOL)animated;
- (void)ht_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

