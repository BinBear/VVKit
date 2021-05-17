//
//  UITableView+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+BlockExtention.h"
#import "UITableViewCell+BlockExtention.h"
#import "UITableViewHeaderFooterView+BlockExtention.h"


NS_ASSUME_NONNULL_BEGIN

@interface HTTableViewDelegateConfigure : HTScrollViewDelegateConfigure

@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configNumberOfSections)(NSInteger (^)(UITableView *tableView));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configNumberOfRowsInSection)(NSInteger (^)(UITableView *tableView, NSInteger section));
// cell
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configCellForRowAtIndexPath)(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configEstimatedHeightForRowAtIndexPath)(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configHeightForRowAtIndexPath)(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configDidSelectRowAtIndexPath)(void (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configDidDeselectRowAtIndexPath)(void (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configWillDisplayCell)(void(^)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath));
// sectionHeader
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configEstimatedHeightForHeaderInSection)(CGFloat (^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configHeightForHeaderInSection)(CGFloat (^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configViewForHeaderInSection)(UIView *(^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configWillDisplayHeaderView)(void (^)(UITableView *tableView,UIView *view,NSInteger section));
// sectionFooter
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configEstimatedHeightForFooterInSection)(CGFloat (^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configHeightForFooterInSection)(CGFloat (^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configViewForFooterInSection)(UIView *(^)(UITableView *tableView,NSInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configWillDisplayFooterView)(void (^)(UITableView *tableView,UIView *view,NSInteger section));
// Edit
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configCanEditRowAtIndexPath)(BOOL (^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configEditingStyleForRowAtIndexPath)(UITableViewCellEditingStyle (^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configCommitEditingStyle)(void (^)(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configEditActionsForRowAtIndexPath)(NSArray<UITableViewRowAction *> * (^)(UITableView *tableView ,NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configWillBeginEditingRowAtIndexPath)(void (^)(UITableView *tableView, NSIndexPath *indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configCanMoveRowAtIndexPath)(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configShouldIndentWhileEditingRowAtIndexPath)(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configTargetIndexPathForMoveFromRowAtIndexPath)(NSIndexPath *(^)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configMoveRowAtIndexPath)(void(^)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath));


@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configSectionAndCellDataKey)(NSArray<NSString *> *(^)(void));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configCellClassForRow)(Class (^)(id cellData, NSIndexPath * indexPath));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configCellWithData)(void (^)(UITableViewCell *cell, id cellData, NSIndexPath *indexPath));

@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configSectionHeaderFooterViewClassAtSection)(Class (^)(id sectionData,HTTableSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configSectionHeaderFooterViewWithSectionData)(void (^)(UIView *headerFooterView,id sectionData,HTTableSeactionViewKinds seactionViewKinds,NSUInteger section));
@property (nonatomic,copy,readonly) HTTableViewDelegateConfigure *(^configEmtyView)(void(^)(UITableView *tableView,UIView *emtyContainerView));

@end


@interface UITableView (BlockExtention)

@property (nonatomic,strong) id ht_tableViewData;
@property (nonatomic,strong,readonly) HTTableViewDelegateConfigure *ht_delegateConfigure;

@property (nonatomic,copy) void (^ht_willReloadDataAsynHandler)(UITableView *tableView);
@property (nonatomic,copy) void (^ht_willReloadDataHandler)(UITableView *tableView);
@property (nonatomic,copy) void (^ht_didReloadDataHandler)(UITableView *tableView);


+ (instancetype)ht_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> * _Nullable)headerFooterViewClasses
                           dataSource:(id<UITableViewDataSource>)dataSource
                             delegate:(id<UITableViewDelegate>)delegate;


+ (instancetype)ht_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                        tableViewData:(id)tableViewData
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> * _Nullable)headerFooterViewClasses
                    delegateConfigure:(void (^)(HTTableViewDelegateConfigure *configure))delegateConfigure;

- (void)ht_tableViewLoad;
- (id)ht_sectionDataAtSection:(NSInteger)section;
- (id)ht_cellDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)ht_reloadWithTableViewData:(id)tableViewData
                        sectionKey:(NSString * _Nullable)sectionKey
                           cellKey:(NSString * _Nullable)cellKey;

- (void)ht_registerCellWithCellClass:(Class)cellClass;
- (void)ht_registerCellWithCellClasses:(NSArray<Class> *)cellClasses;

- (void)ht_registerHeaderFooterWithViewClass:(Class)viewClass;
- (void)ht_registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses;

- (void)ht_clearSelectedRowsAnimated:(BOOL)animated;
- (BOOL)ht_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath;
- (void)ht_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)ht_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)ht_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


@end

NS_ASSUME_NONNULL_END
