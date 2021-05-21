//
//  HTSegmentView.m
//  HeartTrip
//
//  Created by vin on 2020/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTSegmentView.h"
#import "HTSegmentViewAnimate.h"
#import <VinBaseComponents/NSObject+RACExtension.h>

@interface HTSegmentViewConfigure ()
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) UIEdgeInsets ht_inset;
@property (nonatomic,assign) CGFloat ht_itemMargin;
@property (nonatomic,assign) CGFloat ht_insetAndMarginRatio;
@property (nonatomic,assign) BOOL ht_keepingMarginAndInset;
@property (nonatomic,assign) NSInteger ht_items;
@property (nonatomic,assign) NSInteger ht_startIndex;
@property (nonatomic,copy) BOOL(^ht_clickItemAtIndex)(NSInteger, BOOL);
@property (nonatomic,copy) UIView *(^ht_viewForItemAtIndex)(UIView *,
                                                            NSInteger,
                                                            CGFloat,
                                                            HTSegmentViewItemPosition,
                                                            NSArray<UIView *> *);
@property (nonatomic,copy) NSArray<UIView *> *(^ht_animationViews)(NSArray<UIView *> *views,
                                                                    UICollectionViewCell *,
                                                                    UICollectionViewCell *,
                                                                    NSInteger,
                                                                    NSInteger,
                                                                    CGFloat);
+ (instancetype)defaultConfigure;
- (void)clearConfigure;
- (void)deallocBlock;
@end


@interface HTSegmentView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) HTSegmentViewConfigure *configure;
@property (nonatomic,assign) NSInteger currentSelectedIndex;
@property (nonatomic,strong) NSMutableArray<UIView *> *itemViews;
@property (nonatomic,strong) NSMutableArray<UIView *> *animationViews;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@property (nonatomic,copy) void(^configureBlock)(HTSegmentViewConfigure *configure);
@property (nonatomic, assign) NSInteger currentProgress;
@property (nonatomic,assign) BOOL noNeedsLayout;
@property (nonatomic,strong) NSArray *observers;
@end

@implementation HTSegmentView

+ (instancetype)segmentViewWithFrame:(CGRect)frame
                      configureBlock:(void (^)(HTSegmentViewConfigure *configure))configureBlock {
    
    HTSegmentView *segmentView = [[self alloc] initWithFrame:frame];
    segmentView.currentProgress = 1;
    segmentView.backgroundColor = UIColor.whiteColor;
    segmentView.configureBlock = [configureBlock copy];
    !configureBlock ?: configureBlock(segmentView.configure);
    if (segmentView.configure.ht_startIndex < segmentView.configure.ht_items) {
        segmentView.currentSelectedIndex = segmentView.configure.ht_startIndex;
    }
    [segmentView addSubview:segmentView.collectionView];
    segmentView.collectionView.hidden = YES;
    return segmentView;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleAnimationViewWithFromIndex:self.currentSelectedIndex
                                           toIndex:self.currentSelectedIndex
                                          progress:1];
            ht_dispatch_after(0.05, ^{
                self.collectionView.hidden = NO;
            });
        });
        id (^observerBlock)(NSNotificationName, void(^usingBlock)(NSNotification *)) =
        ^(NSNotificationName name, void(^usingBlock)(NSNotification *)){
            return [[NSNotificationCenter defaultCenter]
                        addObserverForName:name
                                    object:nil
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:usingBlock];
        };
        
        @weakify(self);
        self.observers =
        @[observerBlock(UIApplicationDidEnterBackgroundNotification, ^(NSNotification *note){
            @strongify(self);
            self.noNeedsLayout = YES;
        }), observerBlock(UIApplicationDidBecomeActiveNotification, ^(NSNotification *note){
            @strongify(self);
            self.noNeedsLayout = NO;
        })];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.noNeedsLayout) {
        return;
    }
    self.collectionView.frame = self.bounds;
    [self handleLayout];
}

- (void)clickItemAtIndex:(NSInteger)index {
    
    if (index < self.configure.ht_items && index != self.currentSelectedIndex) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self handleAnimationViewWithFromIndex:self.currentSelectedIndex
                                       toIndex:index
                                      progress:1];
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)clickItemFromIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
                  progress:(CGFloat)progress {
    
    if (fromIndex < self.configure.ht_items && toIndex < self.configure.ht_items) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self handleAnimationViewWithFromIndex:fromIndex
                                       toIndex:toIndex
                                      progress:progress];
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)reloadData {
    
    if (self.configureBlock) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        [self.configure clearConfigure];
        self.configureBlock(self.configure);
        [self _reloadData];
        dispatch_semaphore_signal(self.semaphore);
    }
}

- (void)_reloadData {
    
    [self.itemViews removeAllObjects];
    [self.animationViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.animationViews removeAllObjects];
    if (self.configure.ht_startIndex < self.configure.ht_items) {
        self.currentSelectedIndex = self.configure.ht_startIndex;
    }
    [self handleLayout];
    [self.collectionView reloadData];
}

- (void)handleLayout {
    
    if (self.configure.ht_viewForItemAtIndex &&
        self.configure.ht_items) {
        
        [self.itemViews removeAllObjects];
        
        CGFloat totalWith = 0.0;
        for (NSInteger i = 0; i < self.configure.ht_items; i++) {
            
            CGFloat progress = 0;
            if (self.configure.ht_keepingMarginAndInset) {
                progress = self.currentSelectedIndex == i ? 1 : 0;
            }
            UIView *view = self.configure.ht_viewForItemAtIndex(nil, i, progress, HTSegmentViewItemPositionCenter, nil);
            if (i == 0) {
                CGRect tempRect = view.frame;
                tempRect.size.width += 0.0001;
                view.frame = tempRect;
            }
            if (view) {
                totalWith += CGRectGetWidth(view.frame);
                [self.itemViews addObject:view];
            }
        }
        
        if (self.configure.ht_itemMargin == MAXFLOAT) {
            
            if (UIEdgeInsetsEqualToEdgeInsets(self.configure.ht_inset, UIEdgeInsetsZero)) {
                
                CGFloat overWith = CGRectGetWidth(self.bounds) - totalWith;
                if (overWith >= 0) {
                    self.configure.ht_itemMargin = overWith / (self.configure.ht_items - 1 + self.configure.ht_insetAndMarginRatio * 2);
                } else {
                    self.configure.ht_itemMargin = 30;
                }
                
                self.configure.ht_inset = UIEdgeInsetsMake(0, self.configure.ht_itemMargin * self.configure.ht_insetAndMarginRatio, 0, self.configure.ht_itemMargin * self.configure.ht_insetAndMarginRatio);
                
            } else {
                
                CGFloat insetLR = self.configure.ht_inset.left + self.configure.ht_inset.right;
                CGFloat overWith = CGRectGetWidth(self.bounds) - totalWith - insetLR;
                if (overWith >= 0) {
                    self.configure.ht_itemMargin = overWith / (self.configure.ht_items - 1);
                } else {
                    self.configure.ht_itemMargin = 30;
                }
            }
            
        } else  {
            
            if (UIEdgeInsetsEqualToEdgeInsets(self.configure.ht_inset, UIEdgeInsetsZero)) {
                self.configure.ht_inset = UIEdgeInsetsMake(0, self.configure.ht_itemMargin * self.configure.ht_insetAndMarginRatio, 0, self.configure.ht_itemMargin * self.configure.ht_insetAndMarginRatio);
            }
        }
    }
}

- (void)handleAnimationViewWithFromIndex:(NSInteger)fromIndex
                                 toIndex:(NSInteger)toIndex
                                progress:(CGFloat)progress {
    
    if (!self.configure.ht_items) {return;}
    if (progress == 1) {
        self.currentSelectedIndex = toIndex;
    }
    
    if (self.configure.ht_animationViews) {
        NSArray<UIView *> *animationViews =
        self.configure.ht_animationViews(self.animationViews,
                                         [self getCellWithIndex:fromIndex],
                                         [self getCellWithIndex:toIndex],
                                         fromIndex,
                                         toIndex,
                                         progress);
        
        if (![self checkAnimationViews:animationViews]) {
            [self.collectionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj isKindOfClass:UICollectionViewCell.class]) {
                    [obj removeFromSuperview];
                }
            }];
            for (UIView *view in animationViews) {
                [self.collectionView insertSubview:view atIndex:0];
            }
            self.animationViews = animationViews.mutableCopy;
        }
    }
    
    NSTimeInterval delayTime = self.configure.ht_keepingMarginAndInset ? 0.05 : 0.0;
    if (self.configure.ht_viewForItemAtIndex && toIndex != fromIndex) {
        
        HTSegmentViewItemPosition position = HTSegmentViewItemPositionCenter;
        if (progress != 0 && progress != 1 && fromIndex != toIndex) {
            if (fromIndex == self.currentSelectedIndex) {
                if (fromIndex < toIndex) {
                    position = HTSegmentViewItemPositionRight;
                } else {
                    position = HTSegmentViewItemPositionLeft;
                }
            } else {
                if (fromIndex < toIndex) {
                    position = HTSegmentViewItemPositionLeft;
                } else {
                    position = HTSegmentViewItemPositionRight;
                }
            }
        }

        UIView *fromItemView =
        self.configure.ht_viewForItemAtIndex([self getItemViewWithIndex:fromIndex],
                                             fromIndex,
                                             1 - progress,
                                             position,
                                             self.animationViews);
        
        UIView *toItemView =
        self.configure.ht_viewForItemAtIndex([self getItemViewWithIndex:toIndex],
                                             toIndex,
                                             progress,
                                             position,
                                             self.animationViews);
        
        if (self.configure.ht_keepingMarginAndInset) {
            [self.layout invalidateLayout];
        }
        
        ht_dispatch_after(delayTime, ^{
            [self handleItemViewWithCell:nil
                                   index:fromIndex
                                itemView:fromItemView];
            
            [self handleItemViewWithCell:nil
                                   index:toIndex
                                itemView:toItemView];
        });
    }
    
    if (progress == 1) {
        if (fromIndex == toIndex) {
            [self.collectionView reloadData];
        }
        ht_dispatch_after(delayTime, ^{
            [self scrollToCenterWithIndex:toIndex];
        });
    }
    
    self.currentProgress = progress;
}

- (void)handleItemViewWithCell:(UICollectionViewCell *)cell
                         index:(NSInteger)index
                      itemView:(UIView *)itemView {
    
    UIView *currentItemView = itemView;
    UIView *lastItemView = [self getItemViewWithIndex:index];
    UICollectionViewCell *currentCell = cell;
    if (!currentCell) {
        currentCell = [self getCellWithIndex:index];
    }
    
    if (currentItemView) {
        if (lastItemView != currentItemView) {
            if (index < self.itemViews.count) {
                [self.itemViews replaceObjectAtIndex:index withObject:currentItemView];
            }
            [currentCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [currentCell.contentView addSubview:currentItemView];
        } else {
            if (currentCell.contentView.subviews.firstObject != currentItemView) {
                [currentCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [currentCell.contentView addSubview:currentItemView];
            }
        }
        currentCell.contentView.frame = currentCell.bounds;
        currentItemView.center = CGPointMake(CGRectGetWidth(currentCell.contentView.bounds) / 2, CGRectGetHeight(currentCell.contentView.bounds) / 2);
    } else {
        [currentCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)scrollToCenterWithIndex:(NSInteger)index {

    if (self.collectionView.contentSize.width <= CGRectGetWidth(self.collectionView.bounds) ||
        !self.configure.ht_items ||
        self.collectionView.isDragging) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:!self.collectionView.hidden];
}

- (UIView *)getItemViewWithIndex:(NSInteger)index {
    
    if (index < self.itemViews.count) {
        return self.itemViews[index];
    }
    return nil;
}

- (UICollectionViewCell *)getCellWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        CGRect rect = [self.layout layoutAttributesForItemAtIndexPath:indexPath].frame;
        if (CGRectEqualToRect(rect, CGRectZero) && index < self.itemViews.count) {
            CGFloat totalWith = 0.0;
            for (NSInteger i = 0; i < index; i++) {
                totalWith += CGRectGetWidth(self.itemViews[i].bounds) + self.configure.ht_itemMargin;
            }
            rect = CGRectMake(self.configure.ht_inset.left + totalWith, self.configure.ht_inset.top, CGRectGetWidth(self.itemViews[index].bounds), CGRectGetHeight(self.bounds) - self.configure.ht_inset.top - self.configure.ht_inset.bottom);
        }
        cell = [[UICollectionViewCell alloc] initWithFrame:rect];
    }
    return cell;
}

- (BOOL)checkAnimationViews:(NSArray<UIView *> *)animationViews {
    
    if (animationViews.count != self.animationViews.count) {
        return NO;
    }
    
    __block BOOL isSame = YES;
    [self.animationViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (animationViews[idx] != obj) {
            isSame = NO;
            *stop = YES;
        }
    }];
    return isSame;
}

#pragma mark — UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.configure.ht_items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)
                                              forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 14.0, *)) {
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }
    cell.backgroundColor = UIColor.clearColor;
    if (self.configure.ht_viewForItemAtIndex) {
        UIView *itemView =
        self.configure.ht_viewForItemAtIndex([self getItemViewWithIndex:indexPath.row],
                                             indexPath.row,
                                             self.currentSelectedIndex == indexPath.row,
                                             HTSegmentViewItemPositionCenter,
                                             self.animationViews);
        [self handleItemViewWithCell:cell
                               index:indexPath.row
                            itemView:itemView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentProgress != 1) { return;}
    
    [collectionView reloadData];
    collectionView.userInteractionEnabled = NO;
    ht_dispatch_after(0.3, ^{
        collectionView.userInteractionEnabled = YES;
    });
    NSInteger fromIndex = self.currentSelectedIndex;
    
    BOOL needHandle =
    !self.configure.ht_clickItemAtIndex ? YES :
    self.configure.ht_clickItemAtIndex(indexPath.row, indexPath.row == self.currentSelectedIndex);
    
    if (needHandle) {
        [HTSegmentViewAnimate.new animateWithDuration:.25 animations:^(CGFloat progress) {
            [self handleAnimationViewWithFromIndex:fromIndex
                                           toIndex:indexPath.row
                                          progress:progress];
        }];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *itemView = self.itemViews[indexPath.row];
    if (itemView) {
        return CGSizeMake(CGRectGetWidth(itemView.bounds), CGRectGetHeight(collectionView.bounds) - self.configure.ht_inset.top - self.configure.ht_inset.bottom);
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.configure.ht_itemMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return self.configure.ht_inset;
}


#pragma mark — getters and setters
- (HTSegmentViewConfigure *)configure {
    if (!_configure){
        _configure = [HTSegmentViewConfigure defaultConfigure];
    }
    return _configure;
}

- (UICollectionView *)collectionView {
    if (!_collectionView){
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:self.layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 10.0, *)) {
            _collectionView.prefetchingEnabled = NO;
        }
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout){
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (NSMutableArray<UIView *> *)itemViews {
    if (!_itemViews){
        _itemViews = @[].mutableCopy;
    }
    return _itemViews;
}

- (NSMutableArray<UIView *> *)animationViews {
    if (!_animationViews){
        _animationViews = @[].mutableCopy;
    }
    return _animationViews;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    _currentSelectedIndex = currentSelectedIndex;
    self.configure.ht_startIndex = currentSelectedIndex;
}

- (void)dealloc {
    [self.observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }];
    [self.configure deallocBlock];
}

@end

@implementation HTSegmentViewConfigure

+ (instancetype)defaultConfigure {
    HTSegmentViewConfigure *configure = [[self alloc] init];
    configure.insetAndMarginRatio(1.0).itemMargin(MAXFLOAT);
    return configure;
}

- (void)clearConfigure {
    
    [self
     .insetAndMarginRatio(1.0)
     .itemMargin(0)
     .numberOfItems(0)
     .inset(UIEdgeInsetsZero)
     .keepingMarginAndInset(NO)
     deallocBlock];
}

- (HTSegmentViewConfigure *(^)(UIEdgeInsets))inset {
    return ^(UIEdgeInsets value){
        self.ht_inset = value;
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(CGFloat))insetAndMarginRatio {
    return ^(CGFloat value){
        self.ht_insetAndMarginRatio = value;
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(NSInteger))startIndex {
    return ^(NSInteger index){
        self.ht_startIndex = index;
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(BOOL))keepingMarginAndInset {
    return ^(BOOL value){
        self.ht_keepingMarginAndInset = value;
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(NSInteger))numberOfItems {
    return ^(NSInteger items){
        self.ht_items = items;
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(CGFloat))itemMargin {
    return ^(CGFloat margin){
        self.ht_itemMargin = margin;
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(BOOL (^)(NSInteger,
                                        BOOL)))clickItemAtIndex {
    
    return ^(BOOL (^block)(NSInteger,
                           BOOL)){
        self.ht_clickItemAtIndex = [block copy];
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(UIView *(^)(UIView *,
                                           NSInteger,
                                           CGFloat,
                                           HTSegmentViewItemPosition,
                                           NSArray<UIView *> *)))viewForItemAtIndex {
    
    return ^(UIView *(^block)(UIView *,
                              NSInteger,
                              CGFloat,
                              HTSegmentViewItemPosition,
                              NSArray<UIView *> *)){
        self.ht_viewForItemAtIndex = [block copy];
        return self;
    };
}

- (HTSegmentViewConfigure *(^)(NSArray<UIView *> *(^)(NSArray<UIView *> *,
                                                      UICollectionViewCell *,
                                                      UICollectionViewCell *,
                                                      NSInteger,
                                                      NSInteger,
                                                      CGFloat)))animationViews {
    
    return ^(NSArray<UIView *> *(^block)(NSArray<UIView *> *,
                                         UICollectionViewCell *,
                                         UICollectionViewCell *,
                                         NSInteger,
                                         NSInteger,
                                         CGFloat)){
        self.ht_animationViews = [block copy];
        return self;
    };
}

- (NSInteger)getCurrentIndex {
    return self.ht_startIndex;
}

- (UIEdgeInsets)getInset {
    return self.ht_inset;
}

- (CGFloat)getItemMargin {
    return self.ht_itemMargin;
}

- (void)deallocBlock {
    self.ht_animationViews = nil;
    self.ht_clickItemAtIndex = nil;
    self.ht_viewForItemAtIndex = nil;
}


@end
