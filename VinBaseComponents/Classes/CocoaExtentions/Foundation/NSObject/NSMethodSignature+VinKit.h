//
//  NSMethodSignature+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMethodSignature (VinKit)

@property (nonatomic,readonly,nullable) const char *vv_typeEncoding;
@property (nonatomic,copy,readonly,nullable) NSString *vv_typeString;

+ (instancetype)vv_classMethodSignatureWithClass:(Class)cls selector:(SEL)sel;

+ (instancetype)vv_instanceMethodSignatureWithClass:(Class)cls selector:(SEL)sel;

@end

NS_ASSUME_NONNULL_END
