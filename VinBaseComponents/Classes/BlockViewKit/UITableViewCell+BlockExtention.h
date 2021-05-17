//
//  UITableViewCell+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (BlockExtention)

@property (nonatomic,strong) id ht_cellData;
@property (nonatomic,strong,readonly) id ht_sectionData;
@property (nonatomic,strong,readonly) id ht_tableViewData;
@property (nonatomic,weak,readonly) UITableView *ht_tableView;
@property (nonatomic,strong,readonly) NSIndexPath *ht_indexPath;


+ (instancetype)ht_cellWithTableView:(UITableView *)tableview
                           indexPath:(NSIndexPath *)indexPath
                            cellData:(id)cellData;

- (void)ht_cellLoad;
- (void)ht_reloadCellData;

@end

NS_ASSUME_NONNULL_END
