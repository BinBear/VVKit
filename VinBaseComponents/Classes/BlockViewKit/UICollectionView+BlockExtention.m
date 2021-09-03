//
//  UICollectionView+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UICollectionView+BlockExtention.h"
#import <VinBaseComponents/NSObject+RACExtension.h>
#import <VinBaseComponents/VVRunTimeMethods.h>

@interface HTCollectionViewDelegateConfigure ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy) NSInteger(^numberOfSections)(UICollectionView *collectionView);
@property (nonatomic,copy) NSInteger(^numberOfItemsInSection)(UICollectionView *collectionView, NSInteger section);
// cell
@property (nonatomic,copy) UICollectionViewCell *(^cellForItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didSelectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisplayCell)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath);
@property (nonatomic,copy) UICollectionReusableView  *(^seactionHeaderFooterView)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisPlayHeaderFooterView)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath);

@property (nonatomic,copy) CGSize(^layoutSize)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath);
@property (nonatomic,copy) UIEdgeInsets(^layoutInsets)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGFloat(^layoutMinimumLineSpacing)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGFloat(^layoutMinimumInteritemSpacing)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGSize(^layoutReferenceSizeForHeader)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGSize(^layoutReferenceSizeForFooter)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);

@property (nonatomic,copy) NSArray<NSString *> *(^sectionAndCellDataKey)(void);
@property (nonatomic,copy) Class(^cellClassForRow)(id cellData, NSIndexPath * indexPath);
@property (nonatomic,copy) void(^cellWithData)(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath);
@property (nonatomic,copy) Class(^sectionHeaderFooterViewClassAtSection)(id sectionData,HTCollectionSeactionViewKinds seactionViewKinds,NSUInteger section);
@property (nonatomic,copy) void(^sectionHeaderFooterViewWithSectionData)(UIView *headerFooterView,id sectionData,HTCollectionSeactionViewKinds seactionViewKinds,NSUInteger section);
@property (nonatomic,copy) void(^emtyViewBlock)(UICollectionView *,UIView *);

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,copy) NSString *cellDataKey;
@property (nonatomic,copy) NSString *sectionDataKey;
@property (nonatomic,strong) NSArray<Class> *cellClasses;
@property (nonatomic,strong) NSArray<Class> *headerViewClasses;
@property (nonatomic,strong) NSArray<Class> *footerViewClasses;
@end
@implementation HTCollectionViewDelegateConfigure

- (HTCollectionViewDelegateConfigure *(^)(NSInteger (^)(UICollectionView *, NSInteger)))configNumberOfItemsInSection {
    
    @weakify(self);
    return ^(NSInteger (^block)(UICollectionView *, NSInteger)){
        @strongify(self);
        self.numberOfItemsInSection = [block copy];
        return self;
    };
}

- (HTCollectionViewDelegateConfigure *(^)(UICollectionViewCell *(^)(UICollectionView *, NSIndexPath *)))configCellForItemAtIndexPath {
    
    @weakify(self);
    return ^(UICollectionViewCell *(^block)(UICollectionView *, NSIndexPath *)){
        @strongify(self);
        self.cellForItemAtIndexPath = [block copy];
        return self;
    };
}

- (HTCollectionViewDelegateConfigure *(^)(NSInteger (^)(UICollectionView *)))configNumberOfSections {
    
    @weakify(self);
    return ^id(NSInteger (^block)(UICollectionView *)){
        @strongify(self);
        self.numberOfSections = [block copy];
        return self.addDelegateMethod(@"numberOfSectionsInCollectionView:", ^id {
            return ^NSInteger(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView) {
                return
                _self.numberOfSections ?
                _self.numberOfSections(_collectionView) : [_self getSectionCount];
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(void (^)(UICollectionView *, NSIndexPath *)))configDidSelectItemAtIndexPath {
    
    @weakify(self);
    return ^id(void (^block)(UICollectionView *, NSIndexPath *)){
        @strongify(self);
        self.didSelectItemAtIndexPath = [block copy];
        return self.addDelegateMethod(@"collectionView:didSelectItemAtIndexPath:", ^id {
            return ^(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, NSIndexPath *_indexPath) {
                    _self.didSelectItemAtIndexPath ?
                    _self.didSelectItemAtIndexPath(_collectionView, _indexPath) : nil;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(void (^)(UICollectionView *, UICollectionViewCell *, NSIndexPath *)))configWillDisplayCell {
    
    @weakify(self);
    return ^id(void (^block)(UICollectionView *, UICollectionViewCell *, NSIndexPath *)){
        @strongify(self);
        self.willDisplayCell = [block copy];
        return self.addDelegateMethod(@"collectionView:willDisplayCell:forItemAtIndexPath:", ^id {
            return ^(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewCell *_cell, NSIndexPath *_indexPath) {
                _self.willDisplayCell ?
                _self.willDisplayCell(_collectionView, _cell, _indexPath) : nil;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(void (^)(UICollectionViewCell *, id, NSIndexPath *)))configCellWithData {
    
    @weakify(self);
    return ^id(void (^block)(UICollectionViewCell *, id, NSIndexPath *)){
        @strongify(self);
        self.cellWithData = [block copy];
        return self.addDelegateMethod(@"collectionView:willDisplayCell:forItemAtIndexPath:", ^id {
            return ^(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewCell *_cell, NSIndexPath *_indexPath) {
                _self.cellWithData ?
                _self.cellWithData(_cell, [_self getCellDataAtIndexPath:_indexPath], _indexPath) : nil;
            };
        });
    };
}


- (HTCollectionViewDelegateConfigure *(^)(UICollectionReusableView *(^)(UICollectionView *, NSString *, NSIndexPath *)))configSeactionHeaderFooterViewAtIndexPath {
    
    @weakify(self);
    return ^(UICollectionReusableView *(^block)(UICollectionView *, NSString *, NSIndexPath *)){
        @strongify(self);
        self.seactionHeaderFooterView = [block copy];
        return [self handleSeactionHeaderFooterView];
    };
}
             

- (HTCollectionViewDelegateConfigure *(^)(void (^)(UICollectionView *, UICollectionReusableView *, NSString *, NSIndexPath *)))configWillDisPlayHeaderFooterViewAtIndexPath {
    
    @weakify(self);
    return ^id(void (^block)(UICollectionView *, UICollectionReusableView *, NSString *, NSIndexPath *)){
        @strongify(self);
        self.willDisPlayHeaderFooterView = [block copy];
        return self.addDelegateMethod(@"collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:", ^id {
            return ^(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionReusableView *_view, NSString *_elementKind, NSIndexPath *_indexPath) {
                _self.willDisPlayHeaderFooterView ?
                _self.willDisPlayHeaderFooterView(_collectionView, _view, _elementKind, _indexPath) : nil;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(CGSize (^)(UICollectionView *, UICollectionViewLayout *, NSIndexPath *)))configLayoutSize {
    
    @weakify(self);
    return ^id(CGSize (^block)(UICollectionView *, UICollectionViewLayout *, NSIndexPath *)){
        @strongify(self);
        self.layoutSize = [block copy];
        return self.addDelegateMethod(@"collectionView:layout:sizeForItemAtIndexPath:", ^id {
            return ^CGSize(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewLayout *_collectionViewLayout, NSIndexPath *_indexPath) {
                CGSize size = CGSizeZero;
                if ([_collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewLayout;
                    size = layout.itemSize;
                }
                return
                _self.layoutSize ?
                _self.layoutSize(_collectionView, _collectionViewLayout, _indexPath) : size;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(UIEdgeInsets (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))configLayoutInsets {
    
    @weakify(self);
    return ^id(UIEdgeInsets (^block)(UICollectionView *, UICollectionViewLayout *, NSInteger)){
        @strongify(self);
        self.layoutInsets = [block copy];
        return self.addDelegateMethod(@"collectionView:layout:insetForSectionAtIndex:", ^id {
            return ^UIEdgeInsets(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewLayout *_collectionViewLayout, NSInteger _section) {
                UIEdgeInsets insets = UIEdgeInsetsZero;
                if ([_collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewLayout;
                    insets = layout.sectionInset;
                }
                return
                _self.layoutInsets ?
                _self.layoutInsets(_collectionView, _collectionViewLayout, _section) : insets;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(CGFloat (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))configLayoutMinimumLineSpacing {
    
    @weakify(self);
    return ^id(CGFloat (^block)(UICollectionView *, UICollectionViewLayout *, NSInteger)){
        @strongify(self);
        self.layoutMinimumLineSpacing = [block copy];
        return self.addDelegateMethod(@"collectionView:layout:minimumLineSpacingForSectionAtIndex:", ^id {
            return ^CGFloat(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewLayout *_collectionViewLayout, NSInteger _section) {
                CGFloat height = 0.0;
                if ([_collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewLayout;
                    height = layout.minimumLineSpacing;
                }
                return
                _self.layoutMinimumLineSpacing ?
                _self.layoutMinimumLineSpacing(_collectionView, _collectionViewLayout, _section) : height;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(CGFloat (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))configLayoutMinimumInteritemSpacing {
    
    @weakify(self);
    return ^id(CGFloat (^block)(UICollectionView *, UICollectionViewLayout *, NSInteger)){
        @strongify(self);
        self.layoutMinimumInteritemSpacing = [block copy];
        return self.addDelegateMethod(@"collectionView:layout:minimumInteritemSpacingForSectionAtIndex:", ^id {
            return ^CGFloat(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewLayout *_collectionViewLayout, NSInteger _section) {
                CGFloat height = 0.0;
                if ([_collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewLayout;
                    height = layout.minimumInteritemSpacing;
                }
                return
                _self.layoutMinimumInteritemSpacing ?
                _self.layoutMinimumInteritemSpacing(_collectionView, _collectionViewLayout, _section) : height;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(CGSize (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))configLayoutReferenceSizeForHeader {
    
    @weakify(self);
    return ^id(CGSize (^block)(UICollectionView *, UICollectionViewLayout *, NSInteger)){
        @strongify(self);
        self.layoutReferenceSizeForHeader = [block copy];
        return self.addDelegateMethod(@"collectionView:layout:referenceSizeForHeaderInSection:", ^id {
            return ^CGSize(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewLayout *_collectionViewLayout, NSInteger _section) {
                CGSize size = CGSizeZero;
                if ([_collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewLayout;
                    size = layout.headerReferenceSize;
                }
                return
                _self.layoutReferenceSizeForHeader ?
                _self.layoutReferenceSizeForHeader(_collectionView, _collectionViewLayout, _section) : size;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(CGSize (^)(UICollectionView *, UICollectionViewLayout *, NSInteger)))configLayoutReferenceSizeForFooter {
    
    @weakify(self);
    return ^id(CGSize (^block)(UICollectionView *, UICollectionViewLayout *, NSInteger)){
        @strongify(self);
        self.layoutReferenceSizeForFooter = [block copy];
        return self.addDelegateMethod(@"collectionView:layout:referenceSizeForFooterInSection:", ^id {
            return ^CGSize(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionViewLayout *_collectionViewLayout, NSInteger _section) {
                CGSize size = CGSizeZero;
                if ([_collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewLayout;
                    size = layout.footerReferenceSize;
                }
                return
                _self.layoutReferenceSizeForFooter ?
                _self.layoutReferenceSizeForFooter(_collectionView, _collectionViewLayout, _section) : size;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(Class (^)(id, HTCollectionSeactionViewKinds, NSUInteger)))configSectionHeaderFooterViewClassAtSection {
    
    @weakify(self);
    return ^(Class (^block)(id, HTCollectionSeactionViewKinds, NSUInteger)){
        @strongify(self);
        self.sectionHeaderFooterViewClassAtSection = [block copy];
        return [self handleSeactionHeaderFooterView];
    };
}

- (HTCollectionViewDelegateConfigure *(^)(void (^)(UIView *, id, HTCollectionSeactionViewKinds, NSUInteger)))configSectionHeaderFooterViewWithSectionData {
    
    @weakify(self);
    return ^id(void (^block)(UIView *, id, HTCollectionSeactionViewKinds, NSUInteger)){
        @strongify(self);
        self.sectionHeaderFooterViewWithSectionData = [block copy];
        return self.addDelegateMethod(@"collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:", ^id {
            return ^(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, UICollectionReusableView *_view, NSString *_elementKind, NSIndexPath *_indexPath) {
                HTCollectionSeactionViewKinds sectionKinds =
                [_elementKind isEqualToString:UICollectionElementKindSectionHeader] ?
                HTCollectionSeactionViewKindsHeader : HTCollectionSeactionViewKindsFooter;
                
                _self.sectionHeaderFooterViewWithSectionData ?
                _self.sectionHeaderFooterViewWithSectionData(_view,
                                                            [_self getSectionDtaAtSection:_indexPath.section],
                                                             sectionKinds,
                                                             _indexPath.section) : nil;
            };
        });
    };
}

- (HTCollectionViewDelegateConfigure *(^)(void (^)(UICollectionView *, UIView *)))configEmtyView {
    
    @weakify(self);
    return ^(void (^block)(UICollectionView *, UIView *)){
        @strongify(self);
        self.emtyViewBlock = [block copy];
        return self;
    };
}

- (HTCollectionViewDelegateConfigure *(^)(Class (^)(id, NSIndexPath *)))configCellClassForRow {
    
    @weakify(self);
    return ^(Class (^block)(id, NSIndexPath *)){
        @strongify(self);
        self.cellClassForRow = [block copy];
        return self;
    };
}

- (HTCollectionViewDelegateConfigure *(^)(NSArray<NSString *> *(^)(void)))configSectionAndCellDataKey {
    
    @weakify(self);
    return ^(NSArray<NSString *> *(^block)(void)){
        @strongify(self);
        self.sectionAndCellDataKey = [block copy];
        return self;
    };
}

- (id)handleSeactionHeaderFooterView {
    
    return self.addDelegateMethod(@"collectionView:viewForSupplementaryElementOfKind:atIndexPath:", ^id {
        return ^UICollectionReusableView *(HTCollectionViewDelegateConfigure *_self, UICollectionView *_collectionView, NSString *_kind, NSIndexPath *_indexPath) {
            
            if (_self.seactionHeaderFooterView) {
                return _self.seactionHeaderFooterView(_collectionView, _kind, _indexPath);
            } else {
                
                HTCollectionSeactionViewKinds sectionKinds =
                [_kind isEqualToString:UICollectionElementKindSectionHeader] ?
                HTCollectionSeactionViewKindsHeader : HTCollectionSeactionViewKindsFooter;
                
                id sectionData = [_self getSectionDtaAtSection:_indexPath.section];
                
                id secionHeaderFooterClass;
                if (_self.sectionHeaderFooterViewClassAtSection) {
                    secionHeaderFooterClass = _self.sectionHeaderFooterViewClassAtSection(sectionData,sectionKinds, _indexPath.section);
                } else {
                    NSArray *array =
                    sectionKinds == HTCollectionSeactionViewKindsHeader ?
                    _self.headerViewClasses : _self.footerViewClasses;
                    if (array.count == 1) {
                        secionHeaderFooterClass = array.firstObject;
                    };
                }
                
                if (class_isMetaClass(object_getClass(secionHeaderFooterClass)) && [NSStringFromClass(class_getSuperclass(secionHeaderFooterClass)) isEqualToString:@"UICollectionReusableView"]) {
                    return
                    [secionHeaderFooterClass ht_headerFooterViewWithCollectionView:_collectionView
                                                                         indexPath:_indexPath
                                                                 seactionViewKinds:sectionKinds
                                                                       sectionData:sectionData];
                } else if ([secionHeaderFooterClass isKindOfClass:UICollectionReusableView.class]) {
                    return (UICollectionReusableView *)secionHeaderFooterClass;
                }
                
                UICollectionReusableView *headerFooterView =
                [_collectionView dequeueReusableSupplementaryViewOfKind:_kind
                                                    withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)
                                                           forIndexPath:_indexPath];
                return headerFooterView;
            }
        };
    });
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return
    self.numberOfItemsInSection ?
    self.numberOfItemsInSection(collectionView, section) : [self getCellCountInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.cellForItemAtIndexPath) {
        UICollectionViewCell *cell = self.cellForItemAtIndexPath(collectionView, indexPath);
        if (@available(iOS 14.0, *)) {
            cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
        }
        [cell ht_reloadCellData];
        return cell;
    } else {
        
        Class cellClass;
        id cellData = [self getCellDataAtIndexPath:indexPath];
        if (self.cellClassForRow) {
            cellClass = self.cellClassForRow(cellData ,indexPath);
        } else {
            NSArray *array = self.cellClasses;
            if (array.count == 1) {
                cellClass = array.firstObject;
            };
        }
        
        UICollectionViewCell *cell = cellClass ? [cellClass ht_cellWithCollectionView:collectionView
                                                                            indexPath:indexPath
                                                                             cellData:cellData] : nil;
        [cell ht_reloadCellData];
        return cell;
    }
}


- (NSInteger)getSectionCount {
    
    id sectionData = [self getSectionData];
    if ([self isArrayWithData:sectionData]) {
        return ((NSArray *)sectionData).count;
    }
    
    if ([self isArrayWithData:self.ht_collectionViewData] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        return ((NSArray *)self.ht_collectionViewData).count;
    }
    
    return self.ht_collectionViewData ? 1 : 0;
}

- (NSInteger)getCellCountInSection:(NSInteger)section {
    
    id cellData = [self getCellKeyDataWithSection:section];
    if ([self isArrayWithData:cellData]) {
        return ((NSArray *)cellData).count;
    }
    
    if ([self isArrayWithData:self.ht_collectionViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        return ((NSArray *)self.ht_collectionViewData).count;
    }
    
    return self.ht_collectionViewData ? 1 : 0;
}

- (id)getCellDataAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    id cellData = [self getCellKeyDataWithSection:indexPath.section];
    if ([self isArrayWithData:cellData]) {
        if (((NSArray *)cellData).count > indexPath.row) {
            return ((NSArray *)cellData)[indexPath.row];
        }
    }
    
    if ([self isArrayWithData:self.ht_collectionViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        if (((NSArray *)self.ht_collectionViewData).count > indexPath.row) {
            return ((NSArray *)self.ht_collectionViewData)[indexPath.row];
        }
    }
    
    return self.ht_collectionViewData;
}

- (id)getSectionDtaAtSection:(NSInteger)section {
    
    id sectionData = [self getSectionData];
    if ([self isArrayWithData:sectionData]) {
        if (((NSArray *)sectionData).count > section) {
            return ((NSArray *)sectionData)[section];
        }
    }
    
    if ([self isArrayWithData:self.ht_collectionViewData] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        if (((NSArray *)self.ht_collectionViewData).count > section) {
            return ((NSArray *)self.ht_collectionViewData)[section];
        }
    }
    
    return self.ht_collectionViewData;
}

- (id)getSectionData {
    
    NSString *sectionKey = [self getSectionKey];
    if (![sectionKey isKindOfClass:NSString.class]) {
        return sectionKey;
    }
    if (sectionKey.length && sectionKey.length) {
        NSArray *keys = [sectionKey componentsSeparatedByString:@"."];
        id data = self.ht_collectionViewData;
        for (NSString *key in keys) {
            if ([self isObjectWithData:data]) {
                data = [data valueForKeyPath:key];
            }
        }
        return data;
    }
    return nil;
}

- (id)getCellKeyDataWithSection:(NSInteger)section {
    
    NSString *cellKey = [self getCellKey];
    if (![cellKey isKindOfClass:NSString.class]) {
        return cellKey;
    }
    if (self.ht_collectionViewData && cellKey.length) {
        
        id sectionData = [self getSectionData] ?: self.ht_collectionViewData;
        id cellData = sectionData;
        if ([self isArrayWithData:sectionData]) {
            if (section < ((NSArray *)sectionData).count) {
                cellData = ((NSArray *)sectionData)[section];
            } else {
                return @[].mutableCopy;
            }
        }
        
        if ([self isObjectWithData:cellData]) {
            
            NSArray *keys = [cellKey componentsSeparatedByString:@"."];
            if (keys.count) {
                id data = cellData;
                for (NSString *key in keys) {
                    if (key.length && [self isObjectWithData:data]) {
                        data = [data valueForKeyPath:key];
                    }
                }
                return data;
            } else {
                return cellData;
            }
        }
    }
    return nil;
}


- (NSString *)getSectionKey {
    if (self.sectionAndCellDataKey) {
        return self.sectionAndCellDataKey().firstObject;
    }
    return self.sectionDataKey;
}

- (NSString *)getCellKey {
    if (self.sectionAndCellDataKey) {
        return self.sectionAndCellDataKey().lastObject;
    }
    return self.cellDataKey;
}

- (BOOL)isArrayWithData:(id)data {
    if ([data isKindOfClass:NSArray.class] ||
        [data isKindOfClass:NSMutableArray.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)isObjectWithData:(id)data {
    if (!data) { return NO;}
    return ![self isArrayWithData:data];
}

- (id)ht_collectionViewData {
    return self.collectionView.ht_collectionViewData;
}

- (void)dealloc {
    if (![self isMemberOfClass:HTCollectionViewDelegateConfigure.class] &&
        [NSStringFromClass(self.class) hasSuffix:@"HTCollectionViewDelegateConfigure_"]) {
        Class cls = self.class;
        objc_disposeClassPair(cls);
    }
}
@end


@interface UICollectionView ()
@property (nonatomic,strong) HTCollectionViewDelegateConfigure *ht_delegateConfigure;
@end
@implementation UICollectionView (BlockExtention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vv_ExtendImplementationOfVoidMethodWithoutArguments([UICollectionView class], @selector(reloadData), ^(UICollectionView *selfObject) {
            [selfObject ht_reloadData];
        });
    });
}
+ (instancetype)ht_collectionViewWithFrame:(CGRect)frame
                                    layout:(UICollectionViewLayout *)layout
                               cellClasses:(NSArray<Class> *)cellClasses
                         headerViewClasses:(NSArray<Class> *)headerViewClasses
                         footerViewClasses:(NSArray<Class> *)footerViewClasses
                                dataSource:(id<UICollectionViewDataSource>)dataSource
                                  delegate:(id<UICollectionViewDelegate>)delegate {
    
    UICollectionView *colletionView = [[self alloc] initWithFrame:frame collectionViewLayout:layout];
    colletionView.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 10.0, *)) {
        colletionView.prefetchingEnabled = NO;
    }
    if (@available(iOS 11.0, *)) {
        colletionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [colletionView ht_registerCellWithCellClasses:cellClasses];
    [colletionView ht_registerHeaderWithViewClasses:headerViewClasses];
    [colletionView ht_registerFooterWithViewClasses:footerViewClasses];
    colletionView.dataSource = dataSource;
    colletionView.delegate = delegate;
    [colletionView ht_colletionViewLoad];
    return colletionView;
}

+ (instancetype)ht_collectionViewWithFrame:(CGRect)frame
                                    layout:(UICollectionViewLayout *)layout
                        collectionViewData:(id)collectionViewData
                               cellClasses:(NSArray<Class> *)cellClasses
                         headerViewClasses:(NSArray<Class> *)headerViewClasses
                         footerViewClasses:(NSArray<Class> *)footerViewClasses
                         delegateConfigure:(void (^)(HTCollectionViewDelegateConfigure *configure))delegateConfigure {
    
    UICollectionView *colletionView = [[self alloc] initWithFrame:frame collectionViewLayout:layout];
    colletionView.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 10.0, *)) {
        colletionView.prefetchingEnabled = NO;
    }
    if (@available(iOS 11.0, *)) {
        colletionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    colletionView.ht_collectionViewData = collectionViewData;
    [colletionView ht_registerCellWithCellClasses:cellClasses];
    [colletionView ht_registerHeaderWithViewClasses:headerViewClasses];
    [colletionView ht_registerFooterWithViewClasses:footerViewClasses];
    colletionView.ht_delegateConfigure = colletionView.delegateInstance;
    !delegateConfigure ?: delegateConfigure(colletionView.ht_delegateConfigure);
    colletionView.ht_delegateConfigure.collectionView = colletionView;
    colletionView.ht_delegateConfigure.cellClasses = cellClasses;
    colletionView.ht_delegateConfigure.headerViewClasses = headerViewClasses;
    colletionView.ht_delegateConfigure.footerViewClasses = footerViewClasses;
    colletionView.dataSource = colletionView.ht_delegateConfigure;
    colletionView.delegate = colletionView.ht_delegateConfigure;
    [colletionView ht_colletionViewLoad];
    return colletionView;
}

- (HTCollectionViewDelegateConfigure *)delegateInstance {
    const char *clasName = [[NSString stringWithFormat:@"HTCollectionViewDelegateConfigure_%d_%d", arc4random() % 100, arc4random() % 100] cStringUsingEncoding:NSASCIIStringEncoding];
    if (!objc_getClass(clasName)){
        Class cls = objc_allocateClassPair(HTCollectionViewDelegateConfigure.class, clasName, 0);
        objc_registerClassPair(cls);
        return [[cls alloc] init];
    }
    // 尾递归调用
    return [self delegateInstance];
}

- (void)ht_colletionViewLoad {}
- (void)ht_reloadWithCollectionViewData:(id)colllectionViewData
                             sectionKey:(NSString * _Nullable)sectionKey
                                cellKey:(NSString * _Nullable)cellKey {
    
    self.ht_delegateConfigure.sectionDataKey = sectionKey;
    self.ht_delegateConfigure.cellDataKey = cellKey;
    
    if (self.ht_collectionViewData != colllectionViewData) {
        self.ht_collectionViewData = colllectionViewData;
    }
    
    [self reloadData];
}

- (id)ht_sectionDataAtSection:(NSInteger)section {
    if (self.ht_delegateConfigure) {
        return [self.ht_delegateConfigure getSectionDtaAtSection:section];
    }
    return nil;
}

- (id)ht_cellDataAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ht_delegateConfigure) {
        return [self.ht_delegateConfigure getCellDataAtIndexPath:indexPath];
    }
    return nil;
}

- (void)ht_clearSelectedItemsAnimated:(BOOL)animated {
    NSArray *selectedItemIndexPaths = [self indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedItemIndexPaths) {
        [self deselectItemAtIndexPath:indexPath animated:animated];
    }
}

- (BOOL)ht_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visibleItemIndexPaths = self.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleItemIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (void)ht_reloadData {
    
    if (self.ht_willReloadDataAsynHandler) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.ht_willReloadDataAsynHandler(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self ht_handleReloadData];
            });
        });
    } else {
        [self ht_handleReloadData];
    }
}

- (void)ht_handleReloadData {
    !self.ht_willReloadDataHandler ?: self.ht_willReloadDataHandler(self);
    
    if (self.ht_delegateConfigure.emtyViewBlock) {
        
        NSInteger sectionCount =
        self.ht_delegateConfigure.numberOfSections ?
        self.ht_delegateConfigure.numberOfSections(self) :
        [self.ht_delegateConfigure getSectionCount];
        
        if (sectionCount <= 1) {
            
            NSInteger cellCount =
            self.ht_delegateConfigure.numberOfItemsInSection ?
            self.ht_delegateConfigure.numberOfItemsInSection(self, 0) :
            [self.ht_delegateConfigure getCellCountInSection:0];
            
            if (cellCount == 0) {
                self.ht_emtyContainerView.hidden = NO;
                [self.ht_emtyContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.ht_delegateConfigure.emtyViewBlock(self,self.ht_emtyContainerView);
            } else {
                self.ht_emtyContainerView.hidden = YES;
            }
        } else {
            self.ht_emtyContainerView.hidden = YES;
        }
    }
    
    !self.ht_didReloadDataHandler ?: self.ht_didReloadDataHandler(self);
}

- (void)ht_registerCellWithCellClasses:(NSArray<Class> *)cellClasses {
    
    if (!cellClasses.count) { return; }
    [cellClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self ht_registerCellWithCellClass:obj];
    }];
}

- (void)ht_registerCellWithCellClass:(Class)cellClass {
    
    if (!cellClass) { return; }
    
    NSString *cellClassString = NSStringFromClass(cellClass);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:cellClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass)
                                         bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    } else {
        [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

- (void)ht_registerHeaderWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (viewClasses.count) {
        [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {
            [self ht_registerHeaderWithViewClass:obj];
        }];
    }else{
        [self registerClass:UICollectionReusableView.class
 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
    }
    
}
- (void)ht_registerHeaderWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self ht_registerHeaderFooterViewIsNib:YES
                                      isHeader:YES
                                     viewClass:viewClass];
    } else {
        [self ht_registerHeaderFooterViewIsNib:NO
                                      isHeader:YES
                                     viewClass:viewClass];
    }
}

- (void)ht_registerFooterWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (viewClasses.count) {
        [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {
            [self ht_registerFooterWithViewClass:obj];
        }];
    }else{
        [self registerClass:UICollectionReusableView.class
 forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
        withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
    }
    
}
- (void)ht_registerFooterWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self ht_registerHeaderFooterViewIsNib:YES
                                      isHeader:NO
                                     viewClass:viewClass];
    } else {
        [self ht_registerHeaderFooterViewIsNib:NO
                                      isHeader:NO
                                     viewClass:viewClass];
    }
}

- (void)ht_registerHeaderFooterViewIsNib:(BOOL)isNib
                                isHeader:(BOOL)isHeader
                               viewClass:(Class)viewClass {
    
    NSString *ofKind = isHeader ? UICollectionElementKindSectionHeader :
    UICollectionElementKindSectionFooter;
    if (isNib) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass(viewClass)
                                         bundle:nil] forSupplementaryViewOfKind:ofKind withReuseIdentifier:NSStringFromClass(viewClass)];
    } else {
        [self registerClass:viewClass forSupplementaryViewOfKind:ofKind withReuseIdentifier:NSStringFromClass(viewClass)];
    }
}

- (void)setHt_delegateConfigure:(HTCollectionViewDelegateConfigure *)ht_delegateConfigure {
    
    objc_setAssociatedObject(self,
                             @selector(ht_delegateConfigure),
                             ht_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTCollectionViewDelegateConfigure *)ht_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setHt_collectionViewData:(id)ht_collectionViewData {
    objc_setAssociatedObject(self,
                             @selector(ht_collectionViewData),
                             ht_collectionViewData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ht_collectionViewData {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_willReloadDataAsynHandler:(void (^)(UICollectionView *collectionView))ht_willReloadDataAsynHandler {
    objc_setAssociatedObject(self,
                             @selector(ht_willReloadDataAsynHandler),
                             ht_willReloadDataAsynHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UICollectionView *collectionView))ht_willReloadDataAsynHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_willReloadDataHandler:(void (^)(UICollectionView *collectionView))ht_willReloadDataHandler {
    objc_setAssociatedObject(self,
                             @selector(ht_willReloadDataHandler),
                             ht_willReloadDataHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UICollectionView *collectionView))ht_willReloadDataHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_didReloadDataHandler:(void (^)(UICollectionView *collectionView))ht_didReloadDataHandler {
    objc_setAssociatedObject(self,
                             @selector(ht_didReloadDataHandler),
                             ht_didReloadDataHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UICollectionView *collectionView))ht_didReloadDataHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)ht_emtyContainerView {
    
    UIView *emtyView = objc_getAssociatedObject(self, _cmd);
    if (!emtyView) {
        emtyView = UIView.new;
        emtyView.backgroundColor = self.backgroundColor;
        
        if (@available(iOS 11.0, *)) {
            emtyView.frame = CGRectMake(self.contentInset.left, self.contentInset.top, self.bounds.size.width - self.contentInset.left - self.contentInset.right, self.bounds.size.height - self.contentInset.top - self.contentInset.bottom - self.adjustedContentInset.top - self.adjustedContentInset.bottom);
        } else {
            emtyView.frame = CGRectMake(self.contentInset.left, self.contentInset.top, self.bounds.size.width - self.contentInset.left - self.contentInset.right, self.bounds.size.height - self.contentInset.top - self.contentInset.bottom);
        }
        emtyView.hidden = YES;
        [self addSubview:emtyView];
        [self bringSubviewToFront:emtyView];
        objc_setAssociatedObject(self, _cmd, emtyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return emtyView;
}

@end
