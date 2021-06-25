//
//  UITableView+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UITableView+BlockExtention.h"
#import <VinBaseComponents/NSObject+RACExtension.h>
#import <VinBaseComponents/HTRunTimeMethods.h>

@interface HTTableViewDelegateConfigure () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,copy) NSInteger(^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger(^numberOfRowsInSection)(UITableView *tableView, NSInteger section);
// cell
@property (nonatomic,copy) UITableViewCell *(^cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) CGFloat (^estimatedHeightForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didDeselectRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisplayCell)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath);
// sectionHeader
@property (nonatomic,copy) CGFloat (^estimatedHeightForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) CGFloat (^heightForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UIView *(^viewForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^willDisplayHeaderView)(UITableView *tableView,UIView *view,NSInteger section);
// sectionFooter
@property (nonatomic,copy) CGFloat (^estimatedHeightForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) CGFloat (^heightForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UIView *(^viewForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^willDisplayFooterView)(UITableView *tableView,UIView *view,NSInteger section);
//Edit
@property (nonatomic,copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) UITableViewCellEditingStyle
(^editingStyleForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^commitEditingStyle)
(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath);
@property (nonatomic,copy) NSArray<UITableViewRowAction *> *
(^editActionsForRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willBeginEditingRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) BOOL (^canMoveRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) BOOL (^shouldIndentWhileEditingRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) NSIndexPath *(^targetIndexPathForMoveFromRowAtIndexPath)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath);
@property (nonatomic,copy) void (^moveRowAtIndexPath)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath);
@property (nonatomic,copy) NSArray<NSString *> *(^sectionAndCellDataKey)(void);
@property (nonatomic,copy) Class(^cellClassForRow)(id cellData, NSIndexPath * indexPath);
@property (nonatomic,copy) void(^cellWithData)(UITableViewCell *cell, id cellData, NSIndexPath *indexPath);
@property (nonatomic,copy) Class(^sectionHeaderFooterViewClassAtSection)(id sectionData,
                                                                  HTTableSeactionViewKinds seactionViewKinds,
                                                                  NSUInteger section);
@property (nonatomic,copy) void(^sectionHeaderFooterViewWithSectionData)(UIView *headerFooterView,
                                                                        id sectionData,
                                                                        HTTableSeactionViewKinds seactionViewKinds,
                                                                        NSUInteger section);
@property (nonatomic,copy) void(^emtyViewBlock)(UITableView *,UIView *);
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSString *cellDataKey;
@property (nonatomic,copy) NSString *sectionDataKey;
@property (nonatomic,strong) NSArray<Class> *cellClasses;
@property (nonatomic,strong) NSArray<Class> *headerFooterViewClasses;
@end
@implementation HTTableViewDelegateConfigure

- (HTTableViewDelegateConfigure *(^)(NSInteger (^)(UITableView *, NSInteger)))configNumberOfRowsInSection {
    
    @weakify(self);
    return ^(NSInteger (^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.numberOfRowsInSection = [block copy];
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(UITableViewCell *(^)(UITableView *, NSIndexPath *)))configCellForRowAtIndexPath {
    
    @weakify(self);
    return ^(UITableViewCell *(^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.cellForRowAtIndexPath = [block copy];
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(NSInteger (^)(UITableView *)))configNumberOfSections {
    
    @weakify(self);
    return ^id(NSInteger (^block)(UITableView *)) {
        @strongify(self);
        self.numberOfSections = [block copy];
        return self.addDelegateMethod(@"numberOfSectionsInTableView:", ^id {
            return ^NSInteger(HTTableViewDelegateConfigure *_self, UITableView *_tableView) {
                return
                _self.numberOfSections ?
                _self.numberOfSections(_tableView) : [_self getSectionCount];
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(CGFloat (^)(UITableView *, NSIndexPath *)))configEstimatedHeightForRowAtIndexPath{
    
    @weakify(self);
    return ^id(CGFloat (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.estimatedHeightForRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:estimatedHeightForRowAtIndexPath:", ^id {
            return ^CGFloat(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
               return
                _self.estimatedHeightForRowAtIndexPath ?
                _self.estimatedHeightForRowAtIndexPath(_tableView, _indexPath) : _tableView.estimatedRowHeight;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(CGFloat (^)(UITableView *, NSIndexPath *)))configHeightForRowAtIndexPath {
    
    @weakify(self);
    return ^id(CGFloat (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.heightForRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:heightForRowAtIndexPath:", ^id {
            return ^CGFloat(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
               return
                _self.heightForRowAtIndexPath ?
                _self.heightForRowAtIndexPath(_tableView, _indexPath) : _tableView.rowHeight;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, NSIndexPath *)))configDidSelectRowAtIndexPath {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.didSelectRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:didSelectRowAtIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                !_self.didSelectRowAtIndexPath ?:
                _self.didSelectRowAtIndexPath(_tableView, _indexPath);
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, NSIndexPath *)))configDidDeselectRowAtIndexPath {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.didDeselectRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:didDeselectRowAtIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                !_self.didDeselectRowAtIndexPath ?:
                _self.didDeselectRowAtIndexPath(_tableView, _indexPath);
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, UITableViewCell *, NSIndexPath *)))configWillDisplayCell {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, UITableViewCell *, NSIndexPath *)){
        @strongify(self);
        self.willDisplayCell = [block copy];
        return self.addDelegateMethod(@"tableView:willDisplayCell:forRowAtIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UITableViewCell *_cell,  NSIndexPath *_indexPath) {
                _self.willDisplayCell ?
                _self.willDisplayCell(_tableView, _cell, _indexPath) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableViewCell *, id, NSIndexPath *)))configCellWithData {
    
    @weakify(self);
    return ^id(void (^block)(UITableViewCell *, id, NSIndexPath *)){
        @strongify(self);
        self.cellWithData = [block copy];
        return self.addDelegateMethod(@"tableView:willDisplayCell:forRowAtIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UITableViewCell *_cell,  NSIndexPath *_indexPath) {
                _self.cellWithData ?
                _self.cellWithData(_cell, [_self getCellDataAtIndexPath:_indexPath], _indexPath) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(CGFloat (^)(UITableView *, NSInteger)))configEstimatedHeightForHeaderInSection{
    
    @weakify(self);
    return ^id(CGFloat (^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.estimatedHeightForHeaderInSection = [block copy];
        return self.addDelegateMethod(@"tableView:estimatedHeightForHeaderInSection:", ^id {
            return ^CGFloat(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSInteger _section) {
               return
                _self.estimatedHeightForHeaderInSection ?
                _self.estimatedHeightForHeaderInSection(_tableView, _section) : _tableView.estimatedSectionHeaderHeight;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(CGFloat (^)(UITableView *, NSInteger)))configHeightForHeaderInSection {
    
    @weakify(self);
    return ^id(CGFloat (^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.heightForHeaderInSection = [block copy];
        return self.addDelegateMethod(@"tableView:heightForHeaderInSection:", ^id {
            return ^CGFloat(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSInteger _section) {
               return
                _self.heightForHeaderInSection ?
                _self.heightForHeaderInSection(_tableView, _section) : (_tableView.sectionHeaderHeight > 0 ? _tableView.sectionHeaderHeight : 0.01f);
            };
        });
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(UIView *(^)(UITableView *, NSInteger)))configViewForHeaderInSection {
    
    @weakify(self);
    return ^id(UIView *(^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.viewForHeaderInSection = [block copy];
        return [self handleViewForHeaderInSection];
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, UIView *, NSInteger)))configWillDisplayHeaderView {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, UIView *, NSInteger)){
        @strongify(self);
        self.willDisplayHeaderView = [block copy];
        return self.addDelegateMethod(@"tableView:willDisplayHeaderView:forSection:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UIView *_view,  NSInteger _section) {
                _self.willDisplayHeaderView ?
                _self.willDisplayHeaderView(_tableView, _view, _section) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(CGFloat (^)(UITableView *, NSInteger)))configEstimatedHeightForFooterInSection{
    
    @weakify(self);
    return ^id(CGFloat (^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.estimatedHeightForFooterInSection = [block copy];
        return self.addDelegateMethod(@"tableView:estimatedHeightForFooterInSection:", ^id {
            return ^CGFloat(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSInteger _section) {
               return
                _self.estimatedHeightForFooterInSection ?
                _self.estimatedHeightForFooterInSection(_tableView, _section) : _tableView.estimatedSectionFooterHeight;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(CGFloat (^)(UITableView *, NSInteger)))configHeightForFooterInSection {
    
    @weakify(self);
    return ^id(CGFloat (^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.heightForFooterInSection = [block copy];
        return self.addDelegateMethod(@"tableView:heightForFooterInSection:", ^id {
            return ^CGFloat(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSInteger _section) {
               return
                _self.heightForFooterInSection ?
                _self.heightForFooterInSection(_tableView, _section) : (_tableView.sectionFooterHeight > 0 ? _tableView.sectionFooterHeight : 0.01f);
            };
        });
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(UIView *(^)(UITableView *, NSInteger)))configViewForFooterInSection {
    
    @weakify(self);
    return ^(UIView *(^block)(UITableView *, NSInteger)){
        @strongify(self);
        self.viewForFooterInSection = [block copy];
        return [self handleViewForFooterInSection];
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, UIView *, NSInteger)))configWillDisplayFooterView {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, UIView *, NSInteger)){
        @strongify(self);
        self.willDisplayFooterView = [block copy];
        return self.addDelegateMethod(@"tableView:willDisplayFooterView:forSection:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UIView *_view,  NSInteger _section) {
                _self.willDisplayFooterView ?
                _self.willDisplayFooterView(_tableView, _view, _section) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(BOOL (^)(UITableView *, NSIndexPath *)))configCanEditRowAtIndexPath {
    
    @weakify(self);
    return ^id(BOOL (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.canEditRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:canEditRowAtIndexPath:", ^id {
            return ^BOOL(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                return
                _self.canEditRowAtIndexPath ?
                _self.canEditRowAtIndexPath(_tableView, _indexPath) : false;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(UITableViewCellEditingStyle (^)(UITableView *, NSIndexPath *)))configEditingStyleForRowAtIndexPath {
    
    @weakify(self);
    return ^id(UITableViewCellEditingStyle (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.editingStyleForRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:editingStyleForRowAtIndexPath:", ^id {
            return ^UITableViewCellEditingStyle(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                return
                _self.editingStyleForRowAtIndexPath ?
                _self.editingStyleForRowAtIndexPath(_tableView, _indexPath) : UITableViewCellEditingStyleNone;
            };
        });
    };
}


- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, UITableViewCellEditingStyle, NSIndexPath *)))configCommitEditingStyle {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, UITableViewCellEditingStyle, NSIndexPath *)){
        @strongify(self);
        self.commitEditingStyle = [block copy];
        return self.addDelegateMethod(@"tableView:commitEditingStyle:forRowAtIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UITableViewCellEditingStyle _editingStyle, NSIndexPath *_indexPath) {
                _self.commitEditingStyle ?
                _self.commitEditingStyle(_tableView, _editingStyle, _indexPath) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(NSArray<UITableViewRowAction *> *(^)(UITableView *, NSIndexPath *)))configEditActionsForRowAtIndexPath {
    
    @weakify(self);
    return ^id(NSArray<UITableViewRowAction *> *(^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.editActionsForRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:editActionsForRowAtIndexPath:", ^id {
            return ^NSArray<UITableViewRowAction *> *(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                return
                _self.editActionsForRowAtIndexPath ?
                _self.editActionsForRowAtIndexPath(_tableView, _indexPath) : @[];
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(BOOL (^)(UITableView *, NSIndexPath *)))configCanMoveRowAtIndexPath {
    
    @weakify(self);
    return ^id(BOOL (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.canMoveRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:canMoveRowAtIndexPath:", ^id {
            return ^BOOL(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                return
                _self.canMoveRowAtIndexPath ?
                _self.canMoveRowAtIndexPath(_tableView, _indexPath) : false;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, NSIndexPath *)))configWillBeginEditingRowAtIndexPath {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.willBeginEditingRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:willBeginEditingRowAtIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                _self.willBeginEditingRowAtIndexPath ?
                _self.willBeginEditingRowAtIndexPath(_tableView, _indexPath) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(BOOL (^)(UITableView *, NSIndexPath *)))configShouldIndentWhileEditingRowAtIndexPath {
    
    @weakify(self);
    return ^id(BOOL (^block)(UITableView *, NSIndexPath *)){
        @strongify(self);
        self.shouldIndentWhileEditingRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:shouldIndentWhileEditingRowAtIndexPath:", ^id {
            return ^BOOL(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_indexPath) {
                return
                _self.shouldIndentWhileEditingRowAtIndexPath ?
                _self.shouldIndentWhileEditingRowAtIndexPath(_tableView, _indexPath) : true;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(NSIndexPath *(^)(UITableView *, NSIndexPath *, NSIndexPath *)))configTargetIndexPathForMoveFromRowAtIndexPath {
    
    @weakify(self);
    return ^id(NSIndexPath *(^block)(UITableView *, NSIndexPath *, NSIndexPath *)){
        @strongify(self);
        self.targetIndexPathForMoveFromRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:", ^id {
            return ^NSIndexPath *(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_sourceIndexPath, NSIndexPath *_proposedDestinationIndexPath) {
                return
                _self.targetIndexPathForMoveFromRowAtIndexPath ?
                _self.targetIndexPathForMoveFromRowAtIndexPath(_tableView, _sourceIndexPath,_proposedDestinationIndexPath) : _proposedDestinationIndexPath;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, NSIndexPath *, NSIndexPath *)))configMoveRowAtIndexPath {
    
    @weakify(self);
    return ^id(void (^block)(UITableView *, NSIndexPath *, NSIndexPath *)){
        @strongify(self);
        self.moveRowAtIndexPath = [block copy];
        return self.addDelegateMethod(@"tableView:moveRowAtIndexPath:toIndexPath:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSIndexPath *_sourceIndexPath, NSIndexPath *_destinationIndexPath) {
                _self.moveRowAtIndexPath ?
                _self.moveRowAtIndexPath(_tableView, _sourceIndexPath,_destinationIndexPath) : nil;
            };
        });
    };
}

- (HTTableViewDelegateConfigure *(^)(Class (^)(id, HTTableSeactionViewKinds, NSUInteger)))configSectionHeaderFooterViewClassAtSection {
    
    @weakify(self);
    return ^(Class (^block)(id, HTTableSeactionViewKinds, NSUInteger)){
        @strongify(self);
        self.sectionHeaderFooterViewClassAtSection = [block copy];
        [self handleViewForHeaderInSection];
        [self handleViewForFooterInSection];
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UIView *, id, HTTableSeactionViewKinds, NSUInteger)))configSectionHeaderFooterViewWithSectionData {
    
    @weakify(self);
    return ^id(void (^block)(UIView *, id, HTTableSeactionViewKinds, NSUInteger)){
        @strongify(self);
        self.sectionHeaderFooterViewWithSectionData = [block copy];
        self.addDelegateMethod(@"tableView:willDisplayHeaderView:forSection:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UIView *_view,  NSInteger _section) {
                _self.sectionHeaderFooterViewWithSectionData ?
                _self.sectionHeaderFooterViewWithSectionData(_view,
                                                            [self getSectionDtaAtSection:_section],
                                                            HTTableSeactionViewKindsHeader,
                                                             _section) : nil;
            };
        });
        self.addDelegateMethod(@"tableView:willDisplayFooterView:forSection:", ^id {
            return ^(HTTableViewDelegateConfigure *_self, UITableView *_tableView, UIView *_view,  NSInteger _section) {
                _self.sectionHeaderFooterViewWithSectionData ?
                _self.sectionHeaderFooterViewWithSectionData(_view,
                                                            [self getSectionDtaAtSection:_section],
                                                            HTTableSeactionViewKindsFooter,
                                                             _section) : nil;
            };
        });
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(NSArray<NSString *> *(^)(void)))configSectionAndCellDataKey {
    
    @weakify(self);
    return ^(NSArray<NSString *> *(^block)(void)){
        @strongify(self);
        self.sectionAndCellDataKey = [block copy];
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(Class (^)(id, NSIndexPath *)))configCellClassForRow {
    
    @weakify(self);
    return ^(Class (^block)(id, NSIndexPath *)){
        @strongify(self);
        self.cellClassForRow = [block copy];
        return self;
    };
}

- (HTTableViewDelegateConfigure *(^)(void (^)(UITableView *, UIView *)))configEmtyView {
    
    @weakify(self);
    return ^(void (^block)(UITableView *, UIView *)){
        @strongify(self);
        self.emtyViewBlock = [block copy];
        return self;
    };
}

- (id)handleViewForHeaderInSection {
    return self.addDelegateMethod(@"tableView:viewForHeaderInSection:", ^id {
        return ^UIView * (HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSInteger _section) {
            
            if (_self.viewForHeaderInSection) {
                return _self.viewForHeaderInSection(_tableView, _section);
            } else {
                id headerClass;
                id sectionData = [_self getSectionDtaAtSection:_section];
                if (_self.sectionHeaderFooterViewClassAtSection) {
                    headerClass = _self.sectionHeaderFooterViewClassAtSection(sectionData,0, _section);;
                } else {
                    NSArray *array = _self.headerFooterViewClasses;
                    if (array.count == 1) {
                        headerClass = array.firstObject;
                    };
                }
                if (class_isMetaClass(object_getClass(headerClass)) && [NSStringFromClass(class_getSuperclass(headerClass)) isEqualToString:@"UITableViewHeaderFooterView"]) {
                    UITableViewHeaderFooterView *view = [headerClass ht_headerFooterViewWithTableView:_tableView
                                                                                              section:_section
                                                                                    seactionViewKinds:HTTableSeactionViewKindsHeader
                                                                                          sectionData:sectionData];
                    return (UIView *)view;
                } else if ([headerClass isKindOfClass:UIView.class]) {
                    return (UIView *)headerClass;
                }
                return UIView.new;
            }
        };
    });
}

- (id)handleViewForFooterInSection {
    return self.addDelegateMethod(@"tableView:viewForFooterInSection:", ^id {
        return ^UIView * (HTTableViewDelegateConfigure *_self, UITableView *_tableView, NSInteger _section) {
            
            if (_self.viewForFooterInSection) {
                return _self.viewForFooterInSection(_tableView, _section);
            } else {
                id headerClass;
                id sectionData = [_self getSectionDtaAtSection:_section];
                if (_self.sectionHeaderFooterViewClassAtSection) {
                    headerClass = _self.sectionHeaderFooterViewClassAtSection(sectionData,1, _section);;
                } else {
                    NSArray *array = _self.headerFooterViewClasses;
                    if (array.count == 1) {
                        headerClass = array.firstObject;
                    };
                }
                if (class_isMetaClass(object_getClass(headerClass)) && [NSStringFromClass(class_getSuperclass(headerClass)) isEqualToString:@"UITableViewHeaderFooterView"]) {
                    UITableViewHeaderFooterView *view = [headerClass ht_headerFooterViewWithTableView:_tableView
                                                                                              section:_section
                                                                                    seactionViewKinds:HTTableSeactionViewKindsFooter
                                                                                          sectionData:sectionData];
                    return (UIView *)view;
                } else if ([headerClass isKindOfClass:UIView.class]) {
                    return (UIView *)headerClass;
                }
                return UIView.new;
            }
        };
    });
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return
    self.numberOfRowsInSection ?
    self.numberOfRowsInSection(tableView, section) : [self getCellCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellForRowAtIndexPath) {
        UITableViewCell *cell = self.cellForRowAtIndexPath(tableView, indexPath);
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
        UITableViewCell *cell = cellClass ? [cellClass ht_cellWithTableView:tableView
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
    
    if ([self isArrayWithData:self.ht_tableViewData] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        return ((NSArray *)self.ht_tableViewData).count;
    }
    
    return self.ht_tableViewData ? 1 : 0;
}

- (NSInteger)getCellCountInSection:(NSInteger)section {
    
    id cellData = [self getCellKeyDataWithSection:section];
    if ([self isArrayWithData:cellData]) {
        return ((NSArray *)cellData).count;
    }
    
    if ([self isArrayWithData:self.ht_tableViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        return ((NSArray *)self.ht_tableViewData).count;
    }
    
    return self.ht_tableViewData ? 1 : 0;
}

- (id)getCellDataAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath) { return nil;}
    
    id cellData = [self getCellKeyDataWithSection:indexPath.section];
    if ([self isArrayWithData:cellData]) {
        if (((NSArray *)cellData).count > indexPath.row) {
            return ((NSArray *)cellData)[indexPath.row];
        }
    }
    
    if ([self isArrayWithData:self.ht_tableViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        if (((NSArray *)self.ht_tableViewData).count > indexPath.row) {
            return ((NSArray *)self.ht_tableViewData)[indexPath.row];
        }
    }
    
    return self.ht_tableViewData;
}

- (id)getSectionDtaAtSection:(NSInteger)section {
    
    id sectionData = [self getSectionData];
    if ([self isArrayWithData:sectionData]) {
        if (((NSArray *)sectionData).count > section) {
            return ((NSArray *)sectionData)[section];
        }
    }
    
    if ([self isArrayWithData:self.ht_tableViewData] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        if (((NSArray *)self.ht_tableViewData).count > section) {
            return ((NSArray *)self.ht_tableViewData)[section];
        }
    }
    
    return self.ht_tableViewData;
}

- (id)getSectionData {
    
    NSString *sectionKey = [self getSectionKey];
    if (![sectionKey isKindOfClass:NSString.class]) {
        return sectionKey;
    }
    if (sectionKey.length && sectionKey.length) {
        NSArray *keys = [sectionKey componentsSeparatedByString:@"."];
        id data = self.ht_tableViewData;
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
    if (self.ht_tableViewData && cellKey.length) {
        
        id sectionData = [self getSectionData] ?: self.ht_tableViewData;
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

- (id)ht_tableViewData {
    return self.tableView.ht_tableViewData;
}

- (void)dealloc {
    if (![self isMemberOfClass:HTTableViewDelegateConfigure.class] &&
        [NSStringFromClass(self.class) hasSuffix:@"HTTableViewDelegateConfigure_"]) {
        Class cls = self.class;
        objc_disposeClassPair(cls);
    }
}
@end


@interface UITableView ()
@property (nonatomic,strong) HTTableViewDelegateConfigure *ht_delegateConfigure;
@end
@implementation UITableView (BlockExtention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ht_ExtendImplementationOfVoidMethodWithoutArguments([UITableView class], @selector(reloadData), ^(UITableView *selfObject) {
            [selfObject ht_reloadData];
        });
    });
}

+ (instancetype)ht_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> * _Nullable)headerFooterViewClasses
                           dataSource:(id<UITableViewDataSource>)dataSource
                             delegate:(id<UITableViewDelegate>)delegate {
    
    UITableView *tableView = [[self alloc] initWithFrame:frame style:style];
    [tableView ht_registerCellWithCellClasses:cellClasses];
    [tableView ht_registerHeaderFooterWithViewClasses:headerFooterViewClasses];
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    [tableView ht_tableViewLoad];
    return tableView;
}

+ (instancetype)ht_tableViewWithFrame:(CGRect)frame
                                style:(UITableViewStyle)style
                        tableViewData:(id)tableViewData
                          cellClasses:(NSArray<Class> *)cellClasses
              headerFooterViewClasses:(NSArray<Class> * _Nullable)headerFooterViewClasses
                    delegateConfigure:(void (^)(HTTableViewDelegateConfigure *configure))delegateConfigure {
    
    UITableView *tableView = [[self alloc] initWithFrame:frame style:style];
    tableView.ht_tableViewData = tableViewData;
    [tableView ht_registerCellWithCellClasses:cellClasses];
    [tableView ht_registerHeaderFooterWithViewClasses:headerFooterViewClasses];
    tableView.ht_delegateConfigure = tableView.delegateInstance;
    !delegateConfigure ?: delegateConfigure(tableView.ht_delegateConfigure);
    tableView.ht_delegateConfigure.tableView = tableView;
    tableView.ht_delegateConfigure.cellClasses = cellClasses;
    tableView.ht_delegateConfigure.headerFooterViewClasses = headerFooterViewClasses;
    tableView.dataSource = tableView.ht_delegateConfigure;
    tableView.delegate = tableView.ht_delegateConfigure;
    [tableView ht_tableViewLoad];
    return tableView;
}

- (HTTableViewDelegateConfigure *)delegateInstance {
    const char *clasName = [[NSString stringWithFormat:@"HTTableViewDelegateConfigure_%d_%d", arc4random() % 100, arc4random() % 100] cStringUsingEncoding:NSASCIIStringEncoding];
    if (!objc_getClass(clasName)){
        Class cls = objc_allocateClassPair(HTTableViewDelegateConfigure.class, clasName, 0);
        objc_registerClassPair(cls);
        return [[cls alloc] init];
    }
    // 尾递归调用
    return [self delegateInstance];
}

- (void)ht_tableViewLoad {
    if (@available(iOS 11.0, *)){
        self.estimatedRowHeight = 44.0f;
        self.estimatedSectionHeaderHeight = 0.01f;
        self.estimatedSectionFooterHeight = 0.01f;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.sectionHeaderHeight= 0.01f;
    self.sectionFooterHeight = 0.01f;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
};
- (void)ht_reloadWithTableViewData:(id)tableViewData
                        sectionKey:(NSString * _Nullable)sectionKey
                           cellKey:(NSString * _Nullable)cellKey {
    
    self.ht_delegateConfigure.sectionDataKey = sectionKey;
    self.ht_delegateConfigure.cellDataKey = cellKey;
    
    if (self.ht_tableViewData != tableViewData) {
        self.ht_tableViewData = tableViewData;
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

- (BOOL)ht_cellIsVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *visibleCellIndexPaths = self.indexPathsForVisibleRows;
    for (NSIndexPath *visibleIndexPath in visibleCellIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (void)ht_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    if (section > self.numberOfSections - 1) {
        return;
    }
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
}

- (void)ht_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    if (section > self.numberOfSections - 1) {
        return;
    }
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self deleteSections:sections withRowAnimation:animation];
}

- (void)ht_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    if (section > self.numberOfSections - 1) {
        return;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:animation];
}

- (void)ht_clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath* path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
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
            self.ht_delegateConfigure.numberOfRowsInSection ?
            self.ht_delegateConfigure.numberOfRowsInSection(self, 0) :
            [self.ht_delegateConfigure getCellCountInSection:0];
            
            if (cellCount == 0) {
                self.ht_emtyContainerView.hidden = NO;
                self.ht_emtyContainerView.frame = [self emptyFram];
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
        [self registerNib:[UINib nibWithNibName:cellClassString
                                         bundle:nil] forCellReuseIdentifier:cellClassString];
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:cellClassString];
    }
}

- (void)ht_registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (!viewClasses.count) { return; }
    [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self ht_registerHeaderFooterWithViewClass:obj];
    }];
}

- (void)ht_registerHeaderFooterWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:viewClassString
                                         bundle:nil] forHeaderFooterViewReuseIdentifier:viewClassString];
    }else{
        [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:viewClassString];
    }
}

- (void)setHt_delegateConfigure:(HTTableViewDelegateConfigure *)ht_delegateConfigure {
    objc_setAssociatedObject(self,
                             @selector(ht_delegateConfigure),
                             ht_delegateConfigure,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTTableViewDelegateConfigure *)ht_delegateConfigure {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_tableViewData:(id)ht_tableViewData {
    objc_setAssociatedObject(self,
                             @selector(ht_tableViewData),
                             ht_tableViewData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ht_tableViewData {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_willReloadDataAsynHandler:(void (^)(UITableView *tableView))ht_willReloadDataAsynHandler {
    objc_setAssociatedObject(self,
                             @selector(ht_willReloadDataAsynHandler),
                             ht_willReloadDataAsynHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *tableView))ht_willReloadDataAsynHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_willReloadDataHandler:(void (^)(UITableView *tableView))ht_willReloadDataHandler {
    objc_setAssociatedObject(self,
                             @selector(ht_willReloadDataHandler),
                             ht_willReloadDataHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *tableView))ht_willReloadDataHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_didReloadDataHandler:(void (^)(UITableView *tableView))ht_didReloadDataHandler {
    objc_setAssociatedObject(self,
                             @selector(ht_didReloadDataHandler),
                             ht_didReloadDataHandler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *tableView))ht_didReloadDataHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)ht_emtyContainerView {
    
    UIView *emptyView = objc_getAssociatedObject(self, _cmd);
    if (!emptyView) {
        emptyView = UIView.new;
//        emtyView.backgroundColor = self.backgroundColor;
        emptyView.frame = [self emptyFram];
        emptyView.hidden = YES;
        [self addSubview:emptyView];
        [self bringSubviewToFront:emptyView];
        objc_setAssociatedObject(self, _cmd, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return emptyView;
}

- (CGRect)emptyFram {
    CGRect result;
    if (@available(iOS 11.0, *)) {
        CGFloat width = self.bounds.size.width - self.contentInset.left - self.contentInset.right;
        CGFloat height = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom - self.adjustedContentInset.top - self.adjustedContentInset.bottom;
        result = CGRectMake(self.contentInset.left, self.contentInset.top, width, height);
    } else {
        CGFloat width = self.bounds.size.width - self.contentInset.left - self.contentInset.right;
        CGFloat height = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
        result = CGRectMake(self.contentInset.left, self.contentInset.top, width, height);
    }
    return result;
}

@end
