//
//  UICollectionReusableView+BlockExtention.h
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HTCollectionSeactionViewKinds) {
    HTCollectionSeactionViewKindsHeader,
    HTCollectionSeactionViewKindsFooter
};

@interface UICollectionReusableView (BlockExtention)

@property (nonatomic,strong) id ht_sectionData;
@property (nonatomic,assign,readonly) NSInteger ht_section;
@property (nonatomic,strong,readonly) id ht_collectionViewData;
@property (nonatomic,strong,readonly) UICollectionView *ht_collectionView;
@property (nonatomic,assign,readonly) HTCollectionSeactionViewKinds ht_seactionViewKinds;

+ (UICollectionReusableView *)ht_headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                                          indexPath:(NSIndexPath *)indexPath
                                                  seactionViewKinds:(HTCollectionSeactionViewKinds)seactionViewKinds
                                                        sectionData:(id)sectionData;
- (void)ht_headerFooterViewLoad;
- (void)ht_reloadHeaderFooterViewData;

@end

NS_ASSUME_NONNULL_END
