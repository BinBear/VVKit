//
//  UICollectionView+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+BlockExtention.h"
#import "UICollectionViewCell+BlockExtention.h"
#import "UICollectionReusableView+BlockExtention.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTCollectionViewDelegateConfigure : HTScrollViewDelegateConfigure

@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configNumberOfSections)(NSInteger (^)(UICollectionView *collectionView));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configNumberOfItemsInSection)(NSInteger (^)(UICollectionView *collectionView, NSInteger section));
// cell
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configCellForItemAtIndexPath)(UICollectionViewCell *(^)(UICollectionView *collectionView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configDidSelectItemAtIndexPath)(void (^)(UICollectionView *collectionView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configWillDisplayCell)(void(^)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath));
// header footer
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configSeactionHeaderFooterViewAtIndexPath)(UICollectionReusableView *(^)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configWillDisPlayHeaderFooterViewAtIndexPath)(void (^)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath));
// layout

@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configLayoutSize)(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configLayoutInsets)(UIEdgeInsets (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configLayoutMinimumLineSpacing)(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configLayoutMinimumInteritemSpacing)(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configLayoutReferenceSizeForHeader)(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configLayoutReferenceSizeForFooter)(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section));

@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configSectionAndCellDataKey)(NSArray<NSString *> *(^)(void));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configCellClassForRow)(Class (^)(id cellData, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configCellWithData)(void (^)(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configSectionHeaderFooterViewClassAtSection)(Class (^)(id sectionData,HTCollectionSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configSectionHeaderFooterViewWithSectionData)(void (^)(UIView *headerFooterView,id sectionData,HTCollectionSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HTCollectionViewDelegateConfigure *(^configEmtyView)(void(^)(UICollectionView *tableView, UIView *emtyContainerView));
@end

@interface UICollectionView (BlockExtention)

@property (nonatomic,strong,nullable) id ht_collectionViewData;
@property (nonatomic,strong,readonly) HTCollectionViewDelegateConfigure *ht_delegateConfigure;

@property (nonatomic,copy,nullable) void (^ht_willReloadDataAsynHandler)(UICollectionView *collectionView);
@property (nonatomic,copy,nullable) void (^ht_willReloadDataHandler)(UICollectionView *collectionView);
@property (nonatomic,copy,nullable) void (^ht_didReloadDataHandler)(UICollectionView *collectionView);

+ (instancetype)ht_collectionViewWithFrame:(CGRect)frame
                                    layout:(UICollectionViewLayout *)layout
                               cellClasses:(NSArray<Class> * _Nullable)cellClasses
                         headerViewClasses:(NSArray<Class> * _Nullable)headerViewClasses
                         footerViewClasses:(NSArray<Class> * _Nullable)footerViewClasses
                                dataSource:(id<UICollectionViewDataSource> _Nullable)dataSource
                                  delegate:(id<UICollectionViewDelegate> _Nullable)delegate;

+ (instancetype)ht_collectionViewWithFrame:(CGRect)frame
                                    layout:(UICollectionViewLayout *)layout
                        collectionViewData:(id _Nullable)collectionViewData
                               cellClasses:(NSArray<Class> *_Nullable)cellClasses
                         headerViewClasses:(NSArray<Class> *_Nullable)headerViewClasses
                         footerViewClasses:(NSArray<Class> *_Nullable)footerViewClasses
                        delegateConfigure:(void (^_Nullable)(HTCollectionViewDelegateConfigure *configure))delegateConfigure;

- (void)ht_colletionViewLoad;
- (id)ht_sectionDataAtSection:(NSInteger)section;
- (id)ht_cellDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)ht_reloadWithCollectionViewData:(id)colllectionViewData
                             sectionKey:(NSString * _Nullable)sectionKey
                                cellKey:(NSString * _Nullable)cellKey;

- (void)ht_registerCellWithCellClass:(Class)cellClass;
- (void)ht_registerCellWithCellClasses:(NSArray<Class> *)cellClasses;

- (void)ht_registerHeaderWithViewClass:(Class)viewClass;
- (void)ht_registerHeaderWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)ht_registerFooterWithViewClass:(Class)viewClass;
- (void)ht_registerFooterWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)ht_clearSelectedItemsAnimated:(BOOL)animated;
- (BOOL)ht_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
