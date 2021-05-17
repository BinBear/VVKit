//
//  UITableViewHeaderFooterView+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UITableViewHeaderFooterView+BlockExtention.h"
#import "UITableView+BlockExtention.h"

@interface UITableViewHeaderFooterView ()
@property (nonatomic, assign) NSInteger ht_section;
@property (nonatomic, assign) HTTableSeactionViewKinds ht_seactionViewKinds;
@end

@implementation UITableViewHeaderFooterView (BlockExtention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 重新实现initWithReuseIdentifier：，内部会先调用父类的initWithReuseIdentifier：方法
        ht_ExtendImplementationOfNonVoidMethodWithSingleArgument([UITableViewHeaderFooterView class], @selector(initWithReuseIdentifier:), NSString *, UITableViewHeaderFooterView *, ^UITableViewHeaderFooterView *(UITableViewHeaderFooterView *selfObject, NSString *firstArgv, UITableViewHeaderFooterView *originReturnValue) {
            [selfObject ht_headerFooterViewLoad];
            return originReturnValue;
        });
        
        // 重新实现initWithCoder：，内部会先调用父类的initWithCoder：方法
        ht_ExtendImplementationOfNonVoidMethodWithSingleArgument([UITableViewHeaderFooterView class], @selector(initWithCoder:), NSCoder *, UITableViewHeaderFooterView *, ^UITableViewHeaderFooterView *(UITableViewHeaderFooterView *selfObject, NSCoder *firstArgv, UITableViewHeaderFooterView *originReturnValue) {
            [selfObject ht_headerFooterViewLoad];
            return originReturnValue;
        });
        
    });
}


+ (instancetype)ht_headerFooterViewWithTableView:(UITableView *)tableView
                                         section:(NSInteger)section
                               seactionViewKinds:(HTTableSeactionViewKinds)seactionViewKinds
                                     sectionData:(id)sectionData{
    UITableViewHeaderFooterView *headerFooterView =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    headerFooterView.ht_section = section;
    headerFooterView.ht_seactionViewKinds = seactionViewKinds;
    headerFooterView.ht_sectionData = sectionData;
    if (@available(iOS 14.0, *)) {
        headerFooterView.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }
    [headerFooterView ht_reloadHeaderFooterViewData];
    return headerFooterView;
};

- (void)ht_headerFooterViewLoad{};
- (void)ht_reloadHeaderFooterViewData{};

- (id)ht_tableViewData {
    if (self.superview) {
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

- (void)setHt_section:(NSInteger)ht_section {
    objc_setAssociatedObject(self,
                             @selector(ht_section),
                             @(ht_section),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)ht_section {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        NSUInteger numberOfSection = [self.ht_tableView numberOfSections];
        for (NSInteger i = 0; i < numberOfSection; i++) {
            UITableViewHeaderFooterView *headerView = [self.ht_tableView headerViewForSection:i];
            UITableViewHeaderFooterView *footerView = [self.ht_tableView footerViewForSection:i];
            if (headerView == self || footerView == self) {
                number = @(i);
                break;
            }
        }
    }
    return [number integerValue];
}

- (void)setHt_seactionViewKinds:(HTTableSeactionViewKinds)ht_seactionViewKinds {
    objc_setAssociatedObject(self,
                             @selector(ht_seactionViewKinds),
                             @(ht_seactionViewKinds),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTTableSeactionViewKinds)ht_seactionViewKinds {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        NSUInteger numberOfSection = [self.ht_tableView numberOfSections];
        for (NSInteger i = 0; i < numberOfSection; i++) {
            UITableViewHeaderFooterView *headerView = [self.ht_tableView headerViewForSection:i];
            if (headerView == self) {
                number = @(HTTableSeactionViewKindsHeader);
                break;
            }
            UITableViewHeaderFooterView *footerView = [self.ht_tableView footerViewForSection:i];
            if (footerView == self) {
                number = @(HTTableSeactionViewKindsFooter);
                break;
            }
        }
    }
   return [number integerValue];
}

- (void)setHt_sectionData:(id)ht_sectionData {
    objc_setAssociatedObject(self,
                             @selector(ht_sectionData),
                             ht_sectionData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ht_sectionData {
    return objc_getAssociatedObject(self, _cmd);
}

@end
