//
//  UICollectionViewCell+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UICollectionViewCell+BlockExtention.h"
#import "UICollectionView+BlockExtention.h"
#import <VinBaseComponents/VVRunTimeMethods.h>

@interface UICollectionViewCell ()
@property (nonatomic,strong) NSIndexPath *ht_indexPath;
@end


@implementation UICollectionViewCell (BlockExtention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 重新实现initWithFrame：，内部会先调用父类的initWithFrame：方法
        vv_ExtendImplementationOfNonVoidMethodWithSingleArgument([UICollectionViewCell class], @selector(initWithFrame:), CGRect, UICollectionViewCell *, ^UICollectionViewCell *(UICollectionViewCell *selfObject, CGRect firstArgv, UICollectionViewCell *originReturnValue) {
            [selfObject ht_cellLoad];
            return originReturnValue;
        });
        
        // 重新实现initWithCoder：，内部会先调用父类的initWithCoder：方法
        vv_ExtendImplementationOfNonVoidMethodWithSingleArgument([UICollectionViewCell class], @selector(initWithCoder:), NSCoder *, UICollectionViewCell *, ^UICollectionViewCell *(UICollectionViewCell *selfObject, NSCoder *firstArgv, UICollectionViewCell *originReturnValue) {
            [selfObject ht_cellLoad];
            return originReturnValue;
        });
        
    });
}

+ (instancetype)ht_cellWithCollectionView:(UICollectionView *)collectionView
                                indexPath:(NSIndexPath *)indexPath
                                 cellData:(id)cellData {
    
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self)
                                              forIndexPath:indexPath];
    cell.ht_indexPath = indexPath;
    cell.ht_cellData = cellData;
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
    if (self.ht_collectionView) {
        return [self.ht_collectionView ht_sectionDataAtSection:self.ht_indexPath.section];
    }
    return nil;
}

- (id)ht_collectionViewData {
    if (self.ht_collectionView) {
        return self.ht_collectionView.ht_collectionViewData;
    }
    return nil;
}

- (UICollectionView *)ht_collectionView {
    if (!self.superview) {
        return nil;
    }
    UICollectionView *collectionView = ((UICollectionView *)self.superview);
    if ([collectionView isKindOfClass:UICollectionView.class]) {
        return collectionView;
    }
    return nil;
}

- (void)setHt_cellData:(id)ht_cellData {
    
    UITableView *table ;
    [table headerViewForSection:0];
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
    return objc_getAssociatedObject(self, _cmd);
}
@end
