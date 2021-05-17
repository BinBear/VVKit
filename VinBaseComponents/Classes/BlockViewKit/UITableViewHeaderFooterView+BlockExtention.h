//
//  UITableViewHeaderFooterView+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HTTableSeactionViewKinds) {
    HTTableSeactionViewKindsHeader,
    HTTableSeactionViewKindsFooter
};

@interface UITableViewHeaderFooterView (BlockExtention)

@property (nonatomic,strong) id ht_sectionData;
@property (nonatomic,assign,readonly) NSInteger ht_section;
@property (nonatomic,weak,readonly) UITableView *ht_tableView;
@property (nonatomic,strong,readonly) id ht_tableViewData;
@property (nonatomic,assign,readonly) HTTableSeactionViewKinds ht_seactionViewKinds;

+ (instancetype)ht_headerFooterViewWithTableView:(UITableView *)tableView
                                         section:(NSInteger)section
                               seactionViewKinds:(HTTableSeactionViewKinds)seactionViewKinds
                                     sectionData:(id)sectionData;

- (void)ht_headerFooterViewLoad;
- (void)ht_reloadHeaderFooterViewData;

@end

NS_ASSUME_NONNULL_END
