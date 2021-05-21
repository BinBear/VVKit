//
//  HTSegmentView.h
//  HeartTrip
//
//  Created by vin on 2020/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HTSegmentViewItemPosition) {
    HTSegmentViewItemPositionLeft,
    HTSegmentViewItemPositionCenter,
    HTSegmentViewItemPositionRight
};


@class HTSegmentView;
@interface HTSegmentViewConfigure : NSObject

- (NSInteger)getCurrentIndex;
- (UIEdgeInsets)getInset;
- (CGFloat)getItemMargin;

/// 内边距
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^inset)(UIEdgeInsets);
/// 左右边距和中间间隔的比例
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^insetAndMarginRatio)(CGFloat);
/// 标签间距 默认是平均分配, 不够分默认值30
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^itemMargin)(CGFloat);
/// 是否保持margin/inset不变(外部自定义itemView变化时)
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^keepingMarginAndInset)(BOOL);
/// 开始选中的标签数
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^startIndex)(NSInteger);
/// 标签总数
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^numberOfItems)(NSInteger);
/// 点击回调 返回YES内部实现点击动画逻辑, NO外部自己通过调用方法clickItemFromIndex:实现
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^clickItemAtIndex)(BOOL(^)(NSInteger index, BOOL isRepeat));
/// 每个标签 对应的视图
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^viewForItemAtIndex)(UIView *(^)(UIView *currentView, NSInteger index, CGFloat progress, HTSegmentViewItemPosition position, NSArray<UIView *> *animationViews));
/// 动画视图
@property (nonatomic, copy, readonly) HTSegmentViewConfigure *(^animationViews)(NSArray<UIView *> *(^)(NSArray<UIView *> *currentAnimationViews, UICollectionViewCell *fromCell, UICollectionViewCell *toCell, NSInteger fromIndex, NSInteger toIndex, CGFloat progress));
@end


@interface HTSegmentView : UIView

+ (instancetype)segmentViewWithFrame:(CGRect)frame
                      configureBlock:(void (^)(HTSegmentViewConfigure *configure))configureBlock;

@property (nonatomic,strong,readonly) HTSegmentViewConfigure *configure;

- (void)clickItemAtIndex:(NSInteger)index;
- (void)clickItemFromIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
                  progress:(CGFloat)progress;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
