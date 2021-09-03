//
//  NSMethodSignature+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSMethodSignature+VinKit.h"
#import "VVRunTimeMethods.h"

@implementation NSMethodSignature (VinKit)

- (NSString *)vv_typeString {
    
    SEL selector = sel_registerName("_typeString");
    IMP imp = [self methodForSelector:selector];
    if (imp != NULL) {
       return vv_ValueImpFuctoin(imp, NSString *, self, selector);
    }
    return nil;
}

- (const char *)vv_typeEncoding {
    return self.vv_typeString.UTF8String;
}

+ (instancetype)vv_classMethodSignatureWithClass:(Class)cls selector:(SEL)sel {
    
    if (!cls || !sel) {
        return nil;
    }
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    return [metacls instanceMethodSignatureForSelector:sel];
}

+ (instancetype)vv_instanceMethodSignatureWithClass:(Class)cls selector:(SEL)sel {
    
    if (!cls || !sel) {
        return nil;
    }
    Class class = objc_getClass(NSStringFromClass(cls).UTF8String);
    return [class instanceMethodSignatureForSelector:sel];
}

@end
