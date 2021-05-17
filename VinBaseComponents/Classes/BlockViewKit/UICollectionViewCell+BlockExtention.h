//
//  UICollectionViewCell+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (BlockExtention)

@property (nonatomic,strong) id ht_cellData;
@property (nonatomic,strong,readonly) id ht_sectionData;
@property (nonatomic,strong,readonly) id ht_collectionViewData;
@property (nonatomic,strong,readonly) NSIndexPath *ht_indexPath;
@property (nonatomic,strong,readonly) UICollectionView *ht_collectionView;

+ (instancetype)ht_cellWithCollectionView:(UICollectionView *)collectionView
                                indexPath:(NSIndexPath *)indexPath
                                 cellData:(id)cellData;

- (void)ht_cellLoad;
- (void)ht_reloadCellData;

@end

NS_ASSUME_NONNULL_END
