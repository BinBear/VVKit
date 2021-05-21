//
//  HTCycleView.m
//  HeartTrip
//
//  Created by vin on 2020/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTCycleView.h"
#import <VinBaseComponents/NSObject+RACExtension.h>

@interface HTCycleViewProvider ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) id protocolObject;
@property (nonatomic, copy) UIView *(^ht_view)(id);
@property (nonatomic, copy) void (^ht_viewWillAppear)(id, id, BOOL);
@property (nonatomic, copy) void (^ht_viewDidDisAppear)(id, id);
@property (nonatomic, copy) void (^ht_viewClickAction)(id, id);
@property (nonatomic, copy) void (^ht_viewReloadData)(id, id, id);
@end
@implementation HTCycleViewProvider
- (instancetype)view:(UIView * _Nonnull (^)(id _Nonnull))block {
    self.ht_view = [block copy];
    return self;
}
- (instancetype)viewReloadData:(void (^)(id _Nonnull, id _Nonnull, id _Nullable))block {
    self.ht_viewReloadData = [block copy];
    return self;
}
- (instancetype)viewWillAppear:(void (^)(id _Nonnull, id _Nonnull, BOOL))block {
    self.ht_viewWillAppear = [block copy];
    return self;
}
- (instancetype)viewDidDisAppear:(void (^)(id _Nonnull, id _Nonnull))block {
    self.ht_viewDidDisAppear = [block copy];
    return self;
}
- (instancetype)viewClickAction:(void (^)(id _Nonnull, id _Nonnull))block {
    self.ht_viewClickAction = [block copy];
    return self;
}
@end


@interface HTCycleViewConfigure ()
@property (nonatomic, assign) BOOL ht_isCycle;
@property (nonatomic, assign) BOOL ht_isAutoCycle;
@property (nonatomic, assign) NSTimeInterval ht_interval;
@property (nonatomic, assign) HTCycleViewDirection ht_direction;
@property (nonatomic, assign) HTCycleViewLoadStyle ht_loadStyle;
@property (nonatomic, copy) NSInteger (^ht_totalIndexs)(id);
@property (nonatomic, copy) NSInteger (^ht_startIndex)(id);
@property (nonatomic,copy) id (^ht_viewAtIndex)(id, NSInteger);
@property (nonatomic,copy) void(^ht_viewWillAppearAtIndex)(id, id, NSInteger, BOOL);
@property (nonatomic,copy) void(^ht_viewDidDisAppearAtIndex)(id, id, NSInteger);
@property (nonatomic,copy) void(^ht_clickActionAtIndex)(id, id, NSInteger);
@property (nonatomic,copy) void(^ht_currentIndexChange)(id, NSInteger, NSInteger);
@property (nonatomic,copy) void(^ht_roundingIndexChange)(id, NSInteger, NSInteger);
@property (nonatomic,copy) void(^ht_scrollProgress)(id, NSInteger, NSInteger, CGFloat);
@property (nonatomic,weak) id<HTCycleViewScrollDelegate> ht_scrollDelegate;
@end

@implementation HTCycleViewConfigure
- (instancetype)init {
    self = [super init];
    if (self) {
        self.ht_interval = 2;
        self.ht_loadStyle  = 1;
        self.ht_isAutoCycle = YES;
        self.ht_isCycle = YES;
        self.ht_direction = HTCycleViewDirectionTop;
    }
    return self;
}
- (instancetype)isCycle:(BOOL)isCycle {
    self.ht_isCycle = isCycle;
    return self;
}
- (instancetype)isAutoCycle:(BOOL)isAutoCycle {
    self.ht_isAutoCycle = isAutoCycle;
    return self;
}
- (instancetype)interval:(NSTimeInterval)interval {
    self.ht_interval = interval;
    return self;
}
- (instancetype)direction:(HTCycleViewDirection)direction {
    self.ht_direction = direction;
    return self;
}
- (instancetype)loadStyle:(HTCycleViewLoadStyle)loadStyle {
    self.ht_loadStyle = loadStyle;
    return self;
}
- (instancetype)startIndex:(NSInteger(^)(id))block {
    self.ht_startIndex = [block copy];
    return self;
}
- (instancetype)totalIndexs:(NSInteger(^)(id))block {
    self.ht_totalIndexs = [block copy];
    return self;
}
- (instancetype)viewProviderAtIndex:(id  _Nonnull (^)(id _Nonnull, NSInteger))block {
    self.ht_viewAtIndex = [block copy];
    return self;
}
- (instancetype)viewWillAppearAtIndex:(void (^)(id _Nonnull, id _Nonnull, NSInteger, BOOL))block {
    self.ht_viewWillAppearAtIndex = [block copy];
    return self;
}
- (instancetype)viewDidDisAppearAtIndex:(void (^)(id _Nonnull, id _Nonnull, NSInteger))block {
    self.ht_viewDidDisAppearAtIndex = [block copy];
    return self;
}
- (instancetype)clickActionAtIndex:(void (^)(id _Nonnull,id _Nonnull, NSInteger))block {
    self.ht_clickActionAtIndex = [block copy];
    return self;
}
- (instancetype)currentIndexChange:(void (^)(id _Nonnull, NSInteger, NSInteger))block {
    self.ht_currentIndexChange = [block copy];
    return self;
}
- (instancetype)roundingIndexChange:(void (^)(id _Nonnull, NSInteger, NSInteger))block {
    self.ht_roundingIndexChange = [block copy];
    return self;
}
- (instancetype)scrollProgress:(void (^)(id _Nonnull, NSInteger, NSInteger, CGFloat))block {
    self.ht_scrollProgress = [block copy];
    return self;
}
- (instancetype)scrollDelegate:(id<HTCycleViewScrollDelegate>)delegate {
    self.ht_scrollDelegate = delegate;
    return self;
}
@end


@interface HTGestureColletionView : UICollectionView <UIGestureRecognizerDelegate>
@end
@implementation HTGestureColletionView
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan &&
            self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}
@end

@interface HTCycleViewCell : UICollectionViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL isTempAddView;
@end
@implementation HTCycleViewCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath {
    HTCycleViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class)
    forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (@available(iOS 14.0, *)) {
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }
    return cell;
}
@end



@interface HTCycleView () <UICollectionViewDelegate, UICollectionViewDataSource>{
    struct {
        unsigned int didScroll                          :1;
        unsigned int willBeginDragging                  :1;
        unsigned int willEndDragging                    :1;
        unsigned int didEndDragging                     :1;
        unsigned int willBeginDecelerating              :1;
        unsigned int didEndDecelerating                 :1;
        unsigned int didEndScrollingAnimation           :1;
        
    } _scrollDelegateFlags; //将代理对象是否能响应相关协议方法缓存在结构体中
}
@property (nonatomic, strong) HTCycleViewConfigure *configure;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) HTGestureColletionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, HTCycleViewProvider<HTCycleView *> *> *viewProviderDict;
@property (nonatomic, strong) NSMutableIndexSet *didLoadIndexSet;
@property (nonatomic, assign) NSInteger totalIndexs;
@property (nonatomic, assign) NSInteger repeatCount;
@property (nonatomic, assign) BOOL isCycle;
@property (nonatomic, assign) BOOL isAutoCycle;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) HTCycleViewDirection direction;
@property (nonatomic, assign) HTCycleViewLoadStyle loadStyle;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger roundingIndex;
@property (nonatomic, assign) NSInteger currentCycleIndex;
@property (nonatomic, assign) NSInteger targetIndex;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) CGFloat lastScrollProgress;
@property (nonatomic, assign) NSInteger lastFromIndex;
@property (nonatomic, assign) NSInteger lastToIndex;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) BOOL isNoAnimation;
@property (nonatomic, assign) CGFloat lastP;
@property (nonatomic, strong) NSIndexPath *lastViewWillAppearIndexPath;
@end

@implementation HTCycleView

#pragma mark — life cycle methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.layout.itemSize = self.collectionView.bounds.size;
}

#pragma mark — public methods
- (void)reloadData {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER); 
    
    self.interval = self.configure.ht_interval;
    self.direction = self.configure.ht_direction;
    self.loadStyle = self.configure.ht_loadStyle;
    self.totalIndexs = self.configure.ht_totalIndexs ? self.configure.ht_totalIndexs(self) : 0;
    NSInteger startIndex = self.configure.ht_startIndex ? self.configure.ht_startIndex(self) : 0;
    if (startIndex > self.totalIndexs - 1) { startIndex = 0;}
    self.isCycle = self.totalIndexs > 1 && self.configure.ht_isCycle;
    self.isAutoCycle = self.configure.ht_isAutoCycle && self.totalIndexs > 1;
    self.repeatCount = self.isCycle ? 200 : 1;
    self.currentCycleIndex = (NSInteger)(self.repeatCount / 2) - (self.isReverse ? 1 : 0);
    self.targetIndex = startIndex;
    self.layout.scrollDirection =
    (self.direction == HTCycleViewDirectionLeft || self.direction == HTCycleViewDirectionRight) ?
    UICollectionViewScrollDirectionHorizontal :
    UICollectionViewScrollDirectionVertical;
    [self clearData];
    [self.collectionView reloadData];
    if (!self.totalIndexs) { return;}
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _scrollToIndex:self.totalIndexs * self.currentCycleIndex + self.indexWithIndex(startIndex)  animated:NO];
        if (self.isAutoCycle) {
            [self startTimer];
        }
    });
    
    dispatch_semaphore_signal(self.semaphore);
}

- (void)reloadDataAtIndex:(NSInteger)index parameter:(id)parameter {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    UIView *atView = self.viewAtIndex(index);
    if (!atView) { return; }
    
    [self viewProviderWithIndex:index handler:^(HTCycleViewProvider *provider) {
        !provider.ht_viewReloadData ?: provider.ht_viewReloadData(self, atView, parameter);
    }];
    
    if (atView &&
        [atView conformsToProtocol:@protocol(HTCycleViewReloadDataProtocol)] &&
        [atView respondsToSelector:@selector(cycleViewReloadDataAtIndex:parameter:)]) {
        [(id<HTCycleViewReloadDataProtocol>)atView cycleViewReloadDataAtIndex:index parameter:parameter];
    }
    
    dispatch_semaphore_signal(self.semaphore);
}

- (void)scrollToNextIndexWithAnimated:(BOOL)animated {
    NSInteger index = self.currentIndex + 1;
    if (index > self.totalIndexs - 1) {
        index = 0;
    }
    [self scrollToIndex:index animated:animated];
}

- (void)scrollToLastIndexWithAnimated:(BOOL)animated {
    NSInteger index = self.currentIndex - 1;
    if (index < 0) {
        index = self.totalIndexs - 1;
    }
    [self scrollToIndex:index animated:animated];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index == self.currentIndex || index > self.totalIndexs - 1) {return;}

    [self closeAndOpenTimer];
    
    if (self.isCycle) {
        
        NSInteger cyclePage = [self getCurrentCycleIndex];
        if (index < self.currentIndex) {
            if (self.isReverse) {
                if (cyclePage - 1 < 0) {
                    [self _scrollToIndex:self.totalIndexs * (NSInteger)(self.repeatCount / 2) + self.indexWithIndex(self.currentIndex) animated:NO];
                }
                cyclePage = [self getCurrentCycleIndex];
                cyclePage -= 1;
            } else {
                if (cyclePage + 1 >= self.repeatCount) {
                    [self _scrollToIndex:self.totalIndexs * (NSInteger)(self.repeatCount / 2 - 1) + self.currentIndex animated:NO];
                }
                cyclePage = [self getCurrentCycleIndex];
                cyclePage += 1;
            }
        }
        
        int absInt = abs((int)(index - self.currentIndex));
        if (animated && ((absInt >= 2 || index < self.currentIndex) && !(self.currentIndex == self.totalIndexs - 1 && index == 0))) {
            UIView *view = self.viewAtIndex(self.currentIndex);
            NSInteger tempIndex = cyclePage * self.totalIndexs + self.indexWithIndex(index) + ((self.isReverse) ? 1 : - 1);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tempIndex inSection:0];
            self.isNoAnimation = YES;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:self.scrollPosition
                                                    animated:NO];
            } completion:^(BOOL finished) {
                self.isNoAnimation = NO;
                HTCycleViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                if (cell) {
                    [cell.contentView addSubview:view];
                    view.frame = cell.contentView.bounds;
                    cell.isTempAddView = YES;
                }
                [self _scrollToIndex:cyclePage * self.totalIndexs + self.indexWithIndex(index) animated:animated];
            }];
        } else {
            [self _scrollToIndex:cyclePage * self.totalIndexs + self.indexWithIndex(index) animated:animated];
        }
        
    } else {
        
        int absInt = abs((int)(index - self.currentIndex));
        if (animated && absInt >= 2) {
            UIView *view = self.viewAtIndex(self.currentIndex);
            NSInteger tempValue = self.isReverse ? -1 : 1;
            NSInteger tempIndex = index > self.currentIndex ? index - tempValue : index + tempValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tempIndex inSection:0];
            [self.collectionView performBatchUpdates:^{
                self.isNoAnimation = YES;
                [self.collectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:self.scrollPosition
                                                    animated:NO];
            } completion:^(BOOL finished) {
                self.isNoAnimation = NO;
                HTCycleViewCell *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                if (cell) {
                    [cell.contentView addSubview:view];
                    view.frame = cell.contentView.bounds;
                    cell.isTempAddView = YES;
                }
                [self _scrollToIndex:self.indexWithIndex(index) animated:animated];
            }];
        } else {
            [self _scrollToIndex:self.indexWithIndex(index) animated:animated];
        }
    }
}

#pragma mark — private methods
- (void)_scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (index > [self.collectionView numberOfItemsInSection:0] - 1) {
        return;
    }
    NSInteger targetIndex = self.indexWithIndex(index % self.totalIndexs);
    self.targetIndex = targetIndex;
    self.isNoAnimation = !animated;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                    atScrollPosition:self.scrollPosition
                                            animated:animated];
    } completion:^(BOOL finished) {
        self.isNoAnimation = NO;
        if (!animated) {
            if (self.loadStyle == HTCycleViewLoadStyleDidAppear &&
                ![self.didLoadIndexSet containsIndex:index]) {
                self.targetIndex = targetIndex;
                [self addViewWithDidApper];
            }
            NSInteger lastIndex = self.currentIndex;
            [self handleRecycleWithIndex:index];
            [self updateCurrentIndex];
            [self updateCurrentCycleIndex];
            self.roundingIndex = self.currentIndex;
            if (lastIndex < 0) {
              lastIndex = self.currentIndex;
            }
            !self.configure.ht_scrollProgress ?:
            self.configure.ht_scrollProgress(self, lastIndex, self.currentIndex, 1.0);
        }
    }];
}

- (void)addViewForCell:(HTCycleViewCell *)cell
     isWillDisplayCell:(BOOL)flag {
    
    NSIndexPath *indexPath = cell.indexPath;
    NSInteger index = self.indexWithIndexPath(indexPath);
    if (index != self.targetIndex) {
        return;
    }
    
    UIView *view = self.viewAtIndex(index);
    BOOL hasLoad = [self.didLoadIndexSet containsIndex:index];
    if (flag &&
        !hasLoad &&
        self.loadStyle == HTCycleViewLoadStyleDidAppear) {
        return;
    }
        
    if (!hasLoad &&
        self.configure.ht_viewAtIndex) {
        [self.didLoadIndexSet addIndex:index];
        if (self.configure.ht_viewAtIndex) {
            id<HTCycleViewProviderProtocol> protocolObject = self.configure.ht_viewAtIndex(self, index);
            if (protocolObject && [protocolObject respondsToSelector:@selector(configCycleView:index:)]) {
                HTCycleViewProvider *provider = [[HTCycleViewProvider alloc] init];
                provider.index = index;
                [protocolObject configCycleView:provider index:index];
                if (provider.retainProvider) {
                    provider.protocolObject = protocolObject;
                }
                [self.viewProviderDict setObject:provider forKey:@(index)];
                if (provider.ht_view) {
                    view = provider.ht_view(self);
                    if ([view isKindOfClass:UIView.class]) {
                        provider.view = view;
                    }
                }
            }
        }
    }
    
    if ([view isKindOfClass:UIView.class]) {
        [cell.contentView addSubview:view];
        view.frame = cell.contentView.bounds;
        if (!(self.lastViewWillAppearIndexPath &&
             self.lastViewWillAppearIndexPath.row != indexPath.row &&
             self.indexWithIndexPath(self.lastViewWillAppearIndexPath) == index)) {
            [self viewProviderWithIndex:index handler:^(HTCycleViewProvider *provider) {
                !provider.ht_viewWillAppear ?:
                provider.ht_viewWillAppear(self, view, !hasLoad);
            }];
            !self.configure.ht_viewWillAppearAtIndex ?:
            self.configure.ht_viewWillAppearAtIndex(self, view, index, !
                                                    hasLoad);
        }
        self.lastViewWillAppearIndexPath = indexPath;
    }
}

- (void)viewProviderWithIndex:(NSInteger)index
                      handler:(void(^)(HTCycleViewProvider *provider))handler {
    HTCycleViewProvider *provider = [self.viewProviderDict objectForKey:@(index)];
    if (provider) {
        !handler ?: handler(provider);
    }
}

- (void)DidEndScroll {
    if (self.loadStyle == HTCycleViewLoadStyleDidAppear) {
        [self addViewWithDidApper];
    }
    [self updateCurrentIndex];
    [self updateCurrentCycleIndex];
}

- (void)clearData {
    self.currentIndex = -1;
    self.roundingIndex = -1;
    self.lastViewWillAppearIndexPath = nil;
    [self stopTimer];
    [self.viewProviderDict removeAllObjects];
    [self.didLoadIndexSet removeAllIndexes];
}

- (void)updateCurrentIndex {
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        NSInteger index = (int)(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width) % self.totalIndexs;
        self.currentIndex = self.indexWithIndex(index);
    } else {
        NSInteger index = (int)(self.collectionView.contentOffset.y / self.collectionView.bounds.size.height) % self.totalIndexs;
        self.currentIndex = self.indexWithIndex(index);
    }
}

- (void)updateCurrentCycleIndex {
    self.currentCycleIndex = [self getCurrentCycleIndex];
}

- (void)addViewWithDidApper {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof HTCycleViewCell * _Nonnull obj,
                                                                       NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = self.indexWithIndexPath(obj.indexPath);
            if (![self.didLoadIndexSet containsIndex:index]) {
                [self addViewForCell:obj isWillDisplayCell:NO];
            }
        }];
    });
}

- (void)handleRecycleWithIndex:(NSInteger)index {
    if (self.isCycle) {
        if (self.isBoundary(index)) {
            NSInteger offsetIndex = - 1;
            if (index == 0) {
                offsetIndex = 0;
            }
            [self _scrollToIndex:(self.totalIndexs * ((NSInteger)self.repeatCount / 2)  + offsetIndex) animated:NO];
        }
    }
}

- (NSInteger)getCurrentCycleIndex {
    NSInteger index = 0;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x / (self.collectionView.bounds.size.width * self.totalIndexs));
    } else {
        index = (self.collectionView.contentOffset.y / (self.collectionView.bounds.size.height * self.totalIndexs));
    }
    return MAX(0, index);
}

- (UIView *(^)(NSInteger))viewAtIndex {
    return ^UIView *(NSInteger index){
        HTCycleViewProvider *provider = [self.viewProviderDict objectForKey:@(index)];
        if (provider) {
            return provider.view;
        }
        return nil;
    };
}

- (NSInteger(^)(NSIndexPath *))indexWithIndexPath {
    return ^(NSIndexPath *indexPath){
        NSInteger index = indexPath.row % self.totalIndexs;
        if (self.isReverse) {
            index = self.totalIndexs - index - 1;
        }
        return index;
    };
}

- (NSInteger(^)(NSInteger))indexWithIndex {
    return ^(NSInteger index){
        if (self.isReverse) {
            index = self.totalIndexs - 1 - index;
        }
        if (index > self.totalIndexs - 1) {
            index = self.totalIndexs - 1 - index;
        }
        if (index < 0) {
            index = self.totalIndexs - 1 + index;
        }
        return index;
    };
}

- (UICollectionViewScrollPosition)scrollPosition {
    return
    self.layout.scrollDirection == UICollectionViewScrollDirectionVertical ?
    UICollectionViewScrollPositionCenteredVertically :
    UICollectionViewScrollPositionCenteredHorizontally;
}

- (BOOL)isReverse {
    return self.direction == HTCycleViewDirectionRight || self.direction == HTCycleViewDirectionBottom;
}

- (BOOL (^)(CGFloat))isBoundary {
    return ^BOOL (CGFloat index){
        return index == 0 || index == [self.collectionView numberOfItemsInSection:0] - 1;
    };
}

#pragma mark — UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.totalIndexs * self.repeatCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [HTCycleViewCell cellWithCollectionView:collectionView
                                         indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(HTCycleViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.isDragging || self.viewAtIndex(self.indexWithIndexPath(indexPath))) {
        self.targetIndex = self.indexWithIndexPath(indexPath);
    }
    [self addViewForCell:cell isWillDisplayCell:YES];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(HTCycleViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!(self.isCycle && self.isBoundary(indexPath.row)) && !cell.isTempAddView) {
        if (cell.contentView.subviews.count) {
            NSInteger index = self.indexWithIndexPath(indexPath);
            [self viewProviderWithIndex:index handler:^(HTCycleViewProvider *provider) {
                !provider.ht_viewDidDisAppear ?: provider.ht_viewDidDisAppear(self, provider.view);
            }];
            UIView *view = self.viewAtIndex(index);
            if (view) {
                !self.configure.ht_viewDidDisAppearAtIndex ?:
                self.configure.ht_viewDidDisAppearAtIndex(self, view, index);
            }
        }
    }
    cell.isTempAddView = NO;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = self.indexWithIndexPath(indexPath);
    [self viewProviderWithIndex:index handler:^(HTCycleViewProvider *provider) {
        !provider.ht_viewClickAction ?:
        provider.ht_viewClickAction(self, self.viewAtIndex(index));
    }];
    !self.configure.ht_clickActionAtIndex ?:
    self.configure.ht_clickActionAtIndex(self, self.viewAtIndex(index), index);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isNoAnimation) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset = scrollView.contentOffset.y / scrollView.bounds.size.height;
    }
    
    if (self.isCycle) {
       if (self.isBoundary(offset)) {
           NSInteger offsetIndex = - 1;
           if (offset == 0) {
               offsetIndex = 0;
           }
           [self _scrollToIndex:(self.totalIndexs * ((NSInteger)self.repeatCount / 2)  + offsetIndex) animated:NO];
       }
    }
            
    self.roundingIndex = self.indexWithIndex((int)(offset + 0.5) % self.totalIndexs);;
    
    if (scrollView.isDragging) {
        if (ceilf(offset) != ceilf(self.lastP) &&
            floorf(offset) != offset &&
            floorf(self.lastP) != self.lastP) {
            BOOL isStepScroll = NO;
            NSInteger tempIndex = 0;
            NSInteger fromIndex = 0;
            NSInteger toIndex = 0;
            if (offset > self.lastP) {
                tempIndex = self.indexWithIndex((int)offset % self.totalIndexs);
                isStepScroll = tempIndex != self.currentIndex;
                fromIndex = self.currentIndex;
                toIndex = tempIndex;
                
            } else {
                tempIndex = self.indexWithIndex((int)offset % self.totalIndexs + 1);
                isStepScroll = tempIndex != self.currentIndex;
                fromIndex = self.currentIndex;
                toIndex = tempIndex;
            }
            if (isStepScroll) {
                self.currentIndex = tempIndex;
                [self updateCurrentCycleIndex];
                !self.configure.ht_scrollProgress ?:
                self.configure.ht_scrollProgress(self, fromIndex, toIndex, 1.0);
            }
            self.lastScrollProgress = 0.0;
        }
    }
    self.lastP = offset;
    
    if (self.configure.ht_scrollProgress) {
        
        NSInteger fromIndex = 0;
        NSInteger toIndex = 0;
        CGFloat progress = 0.0;
        CGFloat scrollProgress = offset - self.currentCycleIndex  * self.totalIndexs - self.indexWithIndex(self.currentIndex);
        int intProgress = (int)scrollProgress;
        scrollProgress = scrollProgress - intProgress;

        if (scrollProgress < 0) {
            NSInteger tempIndex = self.isReverse ?  1 :  - 1;
            NSInteger tempIntProgress = self.isReverse ? - intProgress : intProgress;
            NSInteger lastIndex = self.currentIndex + tempIndex + tempIntProgress;
            if (lastIndex < 0) {
                lastIndex = self.indexWithIndex(self.totalIndexs + lastIndex);
            }
            lastIndex = lastIndex % self.totalIndexs;
            
            if (scrollProgress <= self.lastScrollProgress) {
                fromIndex = self.currentIndex;
                toIndex = lastIndex;
                progress = - scrollProgress;
            } else {
                fromIndex = lastIndex;
                toIndex = self.currentIndex;
                progress = 1 + scrollProgress;
            }
            
        } else if (scrollProgress > 0) {
            
            NSInteger tempIndex = self.isReverse ?  - 1 :  1;
            NSInteger tempIntProgress = self.isReverse ?  - intProgress :  intProgress;
            NSInteger nexIndex = self.currentIndex + tempIndex + tempIntProgress;
            if (nexIndex < 0) {
                nexIndex = self.totalIndexs + nexIndex;
            }
            nexIndex = nexIndex % self.totalIndexs;
            if (scrollProgress >= self.lastScrollProgress) {
                fromIndex = self.currentIndex;
                toIndex = nexIndex;
                progress = scrollProgress;
            } else {
                fromIndex = nexIndex;
                toIndex = self.currentIndex;
                progress = 1 - scrollProgress;
            }

        } else {
            progress = 1;
            fromIndex = self.lastFromIndex;
            toIndex = self.lastToIndex;
            [self updateCurrentIndex];
            [self updateCurrentCycleIndex];
        }

        if (fromIndex != toIndex) {
            self.configure.ht_scrollProgress(self, fromIndex, toIndex, progress);
        }
        self.lastScrollProgress = scrollProgress;
        self.lastFromIndex = fromIndex;
        self.lastToIndex = toIndex;
    }
    
    if (_scrollDelegateFlags.didScroll) {
        [self.configure.ht_scrollDelegate scrollViewDidScroll:scrollView cycleView:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isAutoCycle) {
        [self stopTimer];
    }
    if (_scrollDelegateFlags.willBeginDragging) {
        [self.configure.ht_scrollDelegate scrollViewWillBeginDragging:scrollView cycleView:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isAutoCycle) {
        [self startTimer];
    }
    if (decelerate == 0) {
        [self DidEndScroll];
    }
    if (_scrollDelegateFlags.didEndDragging) {
        [self.configure.ht_scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate cycleView:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self DidEndScroll];
    if (_scrollDelegateFlags.didEndDecelerating) {
        [self.configure.ht_scrollDelegate scrollViewDidEndDecelerating:scrollView cycleView:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self DidEndScroll];
    if (_scrollDelegateFlags.didEndScrollingAnimation) {
        [self.configure.ht_scrollDelegate scrollViewDidEndScrollingAnimation:scrollView cycleView:self];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_scrollDelegateFlags.willBeginDecelerating) {
        [self.configure.ht_scrollDelegate scrollViewWillBeginDecelerating:scrollView cycleView:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_scrollDelegateFlags.willEndDragging) {
        [self.configure.ht_scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset cycleView:self];
    }
}

#pragma mark — timer
- (void)next {
    [self scrollToNextIndexWithAnimated:YES];
}

- (void)closeAndOpenTimer {
    if (self.isAutoCycle) {
        [self stopTimer];
        ht_dispatch_after(0.25, ^{
            [self startTimer];
        });
    }
}

- (void)startTimer {
    [self stopTimer];
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC),
                              self.interval * NSEC_PER_SEC,
                              0 * NSEC_PER_SEC);
    @weakify(self);
    dispatch_source_set_event_handler(self.timer,
                                      ^{
                                          @autoreleasepool{
                                              @strongify(self);
                                              [self next];
                                          }
                                      });
    dispatch_resume(self.timer);
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = NULL;
    }
}

#pragma mark — getters and setters
- (HTCycleViewConfigure *)configure {
    if (!_configure){
        _configure = [[HTCycleViewConfigure alloc] init];
        _scrollDelegateFlags.didScroll = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:cycleView:)];
        _scrollDelegateFlags.willBeginDragging = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:cycleView:)];
        _scrollDelegateFlags.willEndDragging = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:cycleView:)];
        _scrollDelegateFlags.didEndDragging = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:cycleView:)];
        _scrollDelegateFlags.willBeginDecelerating = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:cycleView:)];
        _scrollDelegateFlags.didEndDecelerating = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:cycleView:)];
        _scrollDelegateFlags.didEndScrollingAnimation = [_configure.ht_scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:cycleView:)];
    }
    return _configure;
}

- (HTGestureColletionView *)collectionView {
    if (!_collectionView){
        _collectionView = [[HTGestureColletionView alloc] initWithFrame:self.bounds
                                                   collectionViewLayout:self.layout];
        [_collectionView registerClass:[HTCycleViewCell class] forCellWithReuseIdentifier:NSStringFromClass(HTCycleViewCell.class)];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
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
        _layout.sectionInset = UIEdgeInsetsZero;
        _layout.itemSize = self.bounds.size;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

- (NSMutableDictionary<NSNumber *,HTCycleViewProvider<HTCycleView *> *> *)viewProviderDict {
    if (!_viewProviderDict) {
        _viewProviderDict = @{}.mutableCopy;
    }
    return _viewProviderDict;
}

- (NSMutableIndexSet *)didLoadIndexSet {
    if (!_didLoadIndexSet) {
        _didLoadIndexSet = [[NSMutableIndexSet alloc] init];
    }
    return _didLoadIndexSet;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex == _currentIndex) {
        return;
    }
    _currentIndex = currentIndex;

    if (currentIndex >= 0) {
        !self.configure.ht_currentIndexChange ?:
        self.configure.ht_currentIndexChange(self, self.totalIndexs, currentIndex);
    }
}

- (void)setRoundingIndex:(NSInteger)roundingIndex {
    if (_roundingIndex == roundingIndex) {
        return;
    }
    _roundingIndex = roundingIndex;
    if (roundingIndex >= 0) {
        !self.configure.ht_roundingIndexChange ?:
        self.configure.ht_roundingIndexChange(self, self.totalIndexs, roundingIndex);
    }
}

- (NSArray<NSNumber *> *)visibleIndexs {
    NSMutableArray *array = @[].mutableCopy;
    for (HTCycleViewCell *cell in self.collectionView.visibleCells) {
        [array addObject:@(self.indexWithIndexPath(cell.indexPath))];
    }
    return array.copy;
}

- (NSArray<UIView *> *)visibleViews {
    NSMutableArray *array = @[].mutableCopy;
    for (NSNumber *index in self.visibleIndexs) {
        [array addObject:self.viewAtIndex(index.integerValue) ?: UIView.new];
    }
    return array.copy;
}

- (NSIndexSet *)didLoadIndexs {
    return self.didLoadIndexSet.copy;
}


@end
