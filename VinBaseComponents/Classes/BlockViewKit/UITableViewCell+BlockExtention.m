//
//  UITableViewCell+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UITableViewCell+BlockExtention.h"
#import "UITableView+BlockExtention.h"
#import <VinBaseComponents/HTRunTimeMethods.h>

@interface UITableViewCell ()
@property (nonatomic,strong) NSIndexPath *ht_indexPath;
@end

@implementation UITableViewCell (BlockExtention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 重新实现initWithStyle:reuseIdentifier: ，内部会先调用父类的initWithStyle:reuseIdentifier: 方法
        ht_OverrideImplementation([UITableViewCell class], @selector(initWithStyle:reuseIdentifier:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UITableViewCell *(UITableViewCell *selfObject, UITableViewCellStyle style, NSString *reuseIdentifier) {
                // 调用父类
                UITableViewCell *(*originSelectorIMP)(id, SEL, UITableViewCellStyle, NSString *);
                originSelectorIMP = (UITableViewCell * (*)(id, SEL, UITableViewCellStyle, NSString *))originalIMPProvider();
                UITableViewCell *cell = originSelectorIMP(selfObject, originCMD, style, reuseIdentifier);
                [cell ht_cellLoad];
                return cell;
            };
        });
        
        // 重新实现initWithCoder：，内部会先调用父类的initWithCoder：方法
        ht_ExtendImplementationOfNonVoidMethodWithSingleArgument([UITableViewCell class], @selector(initWithCoder:), NSCoder *, UITableViewCell *, ^UITableViewCell *(UITableViewCell *selfObject, NSCoder *firstArgv, UITableViewCell *originReturnValue) {
            [selfObject ht_cellLoad];
            return originReturnValue;
        });
        
    });
}

+ (instancetype)ht_cellWithTableView:(UITableView *)tableview
                           indexPath:(NSIndexPath *)indexPath
                            cellData:(id)cellData {
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                            forIndexPath:indexPath];
    cell.ht_cellData = cellData;
    cell.ht_indexPath = indexPath;
    if (@available(iOS 14.0, *)) {
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }
    return cell;
}

- (void)ht_cellLoad {
    if (@available(iOS 14.0, *)) {
        self.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }
}
- (void)ht_reloadCellData {}

- (id)ht_sectionData {
    if (self.ht_tableView) {
        return [self.ht_tableView ht_sectionDataAtSection:self.ht_indexPath.section];
    }
    return nil;
}

- (id)ht_tableViewData {
    if (self.ht_tableView) {
       return self.ht_tableView.ht_tableViewData;
    }
    return nil;
}

- (UITableView *)ht_tableView {
    
    if (!self.superview) {
        return nil;
    }
    UITableView *tableView =
    (UITableView *)([NSStringFromClass(self.superview.class) isEqualToString:@"UITableViewWrapperView"] ?
    self.superview.superview :
    self.superview);
    
    if ([tableView isKindOfClass:UITableView.class]) {
        return tableView;
    }
    
    return nil;
}

- (void)setHt_cellData:(id)ht_cellData {
    objc_setAssociatedObject(self,
                             @selector(ht_cellData),
                             ht_cellData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ht_cellData {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHt_indexPath:(NSIndexPath *)ht_indexPath {
    objc_setAssociatedObject(self,
                             @selector(ht_indexPath),
                             ht_indexPath,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)ht_indexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    if (!indexPath) {
        indexPath = [self.ht_tableView indexPathForCell:self];
    }
    return indexPath;
}

@end
