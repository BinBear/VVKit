//
//  UICollectionReusableView+BlockExtention.m
//  HeartTrip
//
//  Created by vin on 2020/1/5.
//  Copyright © BinBear. All rights reserved.
//

#import "UICollectionReusableView+BlockExtention.h"
#import "UICollectionView+BlockExtention.h"
#import <VinBaseComponents/VVRunTimeMethods.h>

@interface UICollectionReusableView ()
@property (nonatomic, assign) NSInteger ht_section;
@property (nonatomic, assign) HTCollectionSeactionViewKinds ht_seactionViewKinds;
@end


@implementation UICollectionReusableView (BlockExtention)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 重新实现initWithFrame：，内部会先调用父类的initWithFrame：方法
        vv_ExtendImplementationOfNonVoidMethodWithSingleArgument([UICollectionReusableView class], @selector(initWithFrame:), CGRect, UICollectionReusableView *, ^UICollectionReusableView *(UICollectionReusableView *selfObject, CGRect firstArgv, UICollectionReusableView *originReturnValue) {
            [selfObject ht_headerFooterViewLoad];
            return originReturnValue;
        });
        
        // 重新实现initWithCoder：，内部会先调用父类的initWithCoder：方法
        vv_ExtendImplementationOfNonVoidMethodWithSingleArgument([UICollectionReusableView class], @selector(initWithCoder:), NSCoder *, UICollectionReusableView *, ^UICollectionReusableView *(UICollectionReusableView *selfObject, NSCoder *firstArgv, UICollectionReusableView *originReturnValue) {
            [selfObject ht_headerFooterViewLoad];
            return originReturnValue;
        });
        
    });
}

+ (UICollectionReusableView *)ht_headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                                          indexPath:(NSIndexPath *)indexPath
                                                  seactionViewKinds:(HTCollectionSeactionViewKinds)seactionViewKinds
                                                        sectionData:(id)sectionData {
    
    NSString *kinds = seactionViewKinds == HTCollectionSeactionViewKindsHeader ?
    UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter;
    UICollectionReusableView *headerFooterView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kinds
                                       withReuseIdentifier:NSStringFromClass(self)
                                              forIndexPath:indexPath];
    headerFooterView.ht_seactionViewKinds = seactionViewKinds;
    headerFooterView.ht_section = indexPath.section;
    headerFooterView.ht_sectionData = sectionData;
    [headerFooterView ht_reloadHeaderFooterViewData];
    return headerFooterView;
}

- (void)ht_headerFooterViewLoad {}
- (void)ht_reloadHeaderFooterViewData {}

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

- (void)setHt_section:(NSInteger)ht_section {
    objc_setAssociatedObject(self,
                             @selector(ht_section),
                             @(ht_section),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)ht_section {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHt_seactionViewKinds:(HTCollectionSeactionViewKinds)ht_seactionViewKinds {
    objc_setAssociatedObject(self,
                             @selector(ht_seactionViewKinds),
                             @(ht_seactionViewKinds),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTCollectionSeactionViewKinds)ht_seactionViewKinds {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
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
