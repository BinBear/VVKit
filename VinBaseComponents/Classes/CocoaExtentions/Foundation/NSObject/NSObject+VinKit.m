//
//  NSObject+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSObject+VinKit.h"
#import "NSString+VinKit.h"
#import "NSDecimalNumber+VinKit.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation NSObject (VinKit)

- (void)vv_setAssociateRetainValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)vv_setAssociateCopyValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)vv_setAssociateAssignValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)vv_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)vv_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

@end


@implementation NSObject (VinDevice)

+ (NSURL *)vv_documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)vv_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)vv_cachesURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)vv_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)vv_libraryURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)vv_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (BOOL)vv_fileExistInMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)vv_appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)vv_appDisplayName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)vv_appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)vv_appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)vv_appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)vv_userDeviceModel {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)]) {
        NSString *deviceModel = [[UIDevice currentDevice] model];
        return deviceModel;
    } else {
        return nil;
    }
}

+ (NSString *)vv_userDeviceName {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(name)]) {
        NSString *deviceName = [[UIDevice currentDevice] name];
        return deviceName;
    } else {
        return nil;
    }
}

+ (NSString *)vv_systemName {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemName)]) {
        NSString *systemName = [[UIDevice currentDevice] systemName];
        return systemName;
    } else {
        return nil;
    }
}

+ (NSString *)vv_systemVersion {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)]) {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        return systemVersion;
    } else {
        return nil;
    }
}

+ (NSString *)vv_uuidForVendor {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        return uuid.UUIDString;
    } else {
        return nil;
    }
}

+ (NSString *)vv_cfUUID {
    @try {
        CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
        if (theUUID) {
            NSString *tempUniqueID = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, theUUID);
            if (tempUniqueID == nil || tempUniqueID.length <= 0) {
                CFRelease(theUUID);
                return nil;
            }
            CFRelease(theUUID);
            return tempUniqueID;
        } else {
            CFRelease(theUUID);
            return nil;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+ (NSString *)vv_deviceModel {
    if ([self vv_isSimulator]) {
        return [NSString stringWithFormat:@"%s", getenv("SIMULATOR_MODEL_IDENTIFIER")];
    }
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)vv_deviceName {
    static dispatch_once_t onceToken;
    static NSString *name;
    dispatch_once(&onceToken, ^{
        NSString *model = [self vv_deviceModel];
        if (!model) {
            name = @"Unknown Device";
            return;
        }
        
        NSDictionary *dict = @{
            // See https://www.theiphonewiki.com/wiki/Models
            @"iPhone1,1" : @"iPhone 1G",
            @"iPhone1,2" : @"iPhone 3G",
            @"iPhone2,1" : @"iPhone 3GS",
            @"iPhone3,1" : @"iPhone 4 (GSM)",
            @"iPhone3,2" : @"iPhone 4",
            @"iPhone3,3" : @"iPhone 4 (CDMA)",
            @"iPhone4,1" : @"iPhone 4S",
            @"iPhone5,1" : @"iPhone 5",
            @"iPhone5,2" : @"iPhone 5",
            @"iPhone5,3" : @"iPhone 5c",
            @"iPhone5,4" : @"iPhone 5c",
            @"iPhone6,1" : @"iPhone 5s",
            @"iPhone6,2" : @"iPhone 5s",
            @"iPhone7,1" : @"iPhone 6 Plus",
            @"iPhone7,2" : @"iPhone 6",
            @"iPhone8,1" : @"iPhone 6s",
            @"iPhone8,2" : @"iPhone 6s Plus",
            @"iPhone8,4" : @"iPhone SE",
            @"iPhone9,1" : @"iPhone 7",
            @"iPhone9,2" : @"iPhone 7 Plus",
            @"iPhone9,3" : @"iPhone 7",
            @"iPhone9,4" : @"iPhone 7 Plus",
            @"iPhone10,1" : @"iPhone 8",
            @"iPhone10,2" : @"iPhone 8 Plus",
            @"iPhone10,3" : @"iPhone X",
            @"iPhone10,4" : @"iPhone 8",
            @"iPhone10,5" : @"iPhone 8 Plus",
            @"iPhone10,6" : @"iPhone X",
            @"iPhone11,2" : @"iPhone XS",
            @"iPhone11,4" : @"iPhone XS Max",
            @"iPhone11,6" : @"iPhone XS Max CN",
            @"iPhone11,8" : @"iPhone XR",
            @"iPhone12,1" : @"iPhone 11",
            @"iPhone12,3" : @"iPhone 11 Pro",
            @"iPhone12,5" : @"iPhone 11 Pro Max",
            @"iPhone12,8" : @"iPhone SE (2nd generation)",
            @"iPhone13,1" : @"iPhone 12 mini",
            @"iPhone13,2" : @"iPhone 12",
            @"iPhone13,3" : @"iPhone 12 Pro",
            @"iPhone13,4" : @"iPhone 12 Pro Max",
            @"iPhone14,4" : @"iPhone 13 mini",
            @"iPhone14,5" : @"iPhone 13",
            @"iPhone14,2" : @"iPhone 13 Pro",
            @"iPhone14,3" : @"iPhone 13 Pro Max",
            @"iPhone14,6" : @"iPhone SE (3nd generation)",
            @"iPhone14,7" : @"iPhone 14",
            @"iPhone14,8" : @"iPhone 14 Plus",
            @"iPhone15,2" : @"iPhone 14 Pro",
            @"iPhone15,3" : @"iPhone 14 Pro Max",
            
            @"iPad1,1" : @"iPad 1",
            @"iPad2,1" : @"iPad 2 (WiFi)",
            @"iPad2,2" : @"iPad 2 (GSM)",
            @"iPad2,3" : @"iPad 2 (CDMA)",
            @"iPad2,4" : @"iPad 2",
            @"iPad2,5" : @"iPad mini 1",
            @"iPad2,6" : @"iPad mini 1",
            @"iPad2,7" : @"iPad mini 1",
            @"iPad3,1" : @"iPad 3 (WiFi)",
            @"iPad3,2" : @"iPad 3 (4G)",
            @"iPad3,3" : @"iPad 3 (4G)",
            @"iPad3,4" : @"iPad 4",
            @"iPad3,5" : @"iPad 4",
            @"iPad3,6" : @"iPad 4",
            @"iPad4,1" : @"iPad Air",
            @"iPad4,2" : @"iPad Air",
            @"iPad4,3" : @"iPad Air",
            @"iPad4,4" : @"iPad mini 2",
            @"iPad4,5" : @"iPad mini 2",
            @"iPad4,6" : @"iPad mini 2",
            @"iPad4,7" : @"iPad mini 3",
            @"iPad4,8" : @"iPad mini 3",
            @"iPad4,9" : @"iPad mini 3",
            @"iPad5,1" : @"iPad mini 4",
            @"iPad5,2" : @"iPad mini 4",
            @"iPad5,3" : @"iPad Air 2",
            @"iPad5,4" : @"iPad Air 2",
            @"iPad6,3" : @"iPad Pro (9.7 inch)",
            @"iPad6,4" : @"iPad Pro (9.7 inch)",
            @"iPad6,7" : @"iPad Pro (12.9 inch)",
            @"iPad6,8" : @"iPad Pro (12.9 inch)",
            @"iPad6,11": @"iPad 5 (WiFi)",
            @"iPad6,12": @"iPad 5 (Cellular)",
            @"iPad7,1" : @"iPad Pro (12.9 inch, 2nd generation)",
            @"iPad7,2" : @"iPad Pro (12.9 inch, 2nd generation)",
            @"iPad7,3" : @"iPad Pro (10.5 inch)",
            @"iPad7,4" : @"iPad Pro (10.5 inch)",
            @"iPad7,5" : @"iPad 6 (WiFi)",
            @"iPad7,6" : @"iPad 6 (Cellular)",
            @"iPad7,11": @"iPad 7 (WiFi)",
            @"iPad7,12": @"iPad 7 (Cellular)",
            @"iPad8,1" : @"iPad Pro (11 inch)",
            @"iPad8,2" : @"iPad Pro (11 inch)",
            @"iPad8,3" : @"iPad Pro (11 inch)",
            @"iPad8,4" : @"iPad Pro (11 inch)",
            @"iPad8,5" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,6" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,7" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,8" : @"iPad Pro (12.9 inch, 3rd generation)",
            @"iPad8,9" : @"iPad Pro (11 inch, 2nd generation)",
            @"iPad8,10" : @"iPad Pro (11 inch, 2nd generation)",
            @"iPad8,11" : @"iPad Pro (12.9 inch, 4th generation)",
            @"iPad8,12" : @"iPad Pro (12.9 inch, 4th generation)",
            @"iPad11,1" : @"iPad mini (5th generation)",
            @"iPad11,2" : @"iPad mini (5th generation)",
            @"iPad11,3" : @"iPad Air (3rd generation)",
            @"iPad11,4" : @"iPad Air (3rd generation)",
            @"iPad11,6" : @"iPad (WiFi)",
            @"iPad11,7" : @"iPad (Cellular)",
            @"iPad12,1" : @"iPad (9th generation)",
            @"iPad12,2" : @"iPad (9th generation)",
            @"iPad13,1" : @"iPad Air (4th generation)",
            @"iPad13,2" : @"iPad Air (4th generation)",
            @"iPad13,4" : @"iPad Pro (11 inch, 3rd generation)",
            @"iPad13,5" : @"iPad Pro (11 inch, 3rd generation)",
            @"iPad13,6" : @"iPad Pro (11 inch, 3rd generation)",
            @"iPad13,7" : @"iPad Pro (11 inch, 3rd generation)",
            @"iPad13,8" : @"iPad Pro (12.9 inch, 5th generation)",
            @"iPad13,9" : @"iPad Pro (12.9 inch, 5th generation)",
            @"iPad13,10" : @"iPad Pro (12.9 inch, 5th generation)",
            @"iPad13,11" : @"iPad Pro (12.9 inch, 5th generation)",
            @"iPad13,16" : @"iPad Air (5th generation)",
            @"iPad13,17" : @"iPad Air (5th generation)",
            @"iPad14,1" : @"iPad mini (6th generation)",
            @"iPad14,2" : @"iPad mini (6th generation)",
            
            @"iPod1,1" : @"iPod touch 1",
            @"iPod2,1" : @"iPod touch 2",
            @"iPod3,1" : @"iPod touch 3",
            @"iPod4,1" : @"iPod touch 4",
            @"iPod5,1" : @"iPod touch 5",
            @"iPod7,1" : @"iPod touch 6",
            @"iPod9,1" : @"iPod touch 7",
            
            @"i386" : @"Simulator x86",
            @"x86_64" : @"Simulator x64",
            
            @"Watch1,1" : @"Apple Watch 38mm",
            @"Watch1,2" : @"Apple Watch 42mm",
            @"Watch2,3" : @"Apple Watch Series 2 38mm",
            @"Watch2,4" : @"Apple Watch Series 2 42mm",
            @"Watch2,6" : @"Apple Watch Series 1 38mm",
            @"Watch2,7" : @"Apple Watch Series 1 42mm",
            @"Watch3,1" : @"Apple Watch Series 3 38mm",
            @"Watch3,2" : @"Apple Watch Series 3 42mm",
            @"Watch3,3" : @"Apple Watch Series 3 38mm (LTE)",
            @"Watch3,4" : @"Apple Watch Series 3 42mm (LTE)",
            @"Watch4,1" : @"Apple Watch Series 4 40mm",
            @"Watch4,2" : @"Apple Watch Series 4 44mm",
            @"Watch4,3" : @"Apple Watch Series 4 40mm (LTE)",
            @"Watch4,4" : @"Apple Watch Series 4 44mm (LTE)",
            @"Watch5,1" : @"Apple Watch Series 5 40mm",
            @"Watch5,2" : @"Apple Watch Series 5 44mm",
            @"Watch5,3" : @"Apple Watch Series 5 40mm (LTE)",
            @"Watch5,4" : @"Apple Watch Series 5 44mm (LTE)",
            @"Watch5,9" : @"Apple Watch SE 40mm",
            @"Watch5,10" : @"Apple Watch SE 44mm",
            @"Watch5,11" : @"Apple Watch SE 40mm",
            @"Watch5,12" : @"Apple Watch SE 44mm",
            @"Watch6,1"  : @"Apple Watch Series 6 40mm",
            @"Watch6,2"  : @"Apple Watch Series 6 44mm",
            @"Watch6,3"  : @"Apple Watch Series 6 40mm",
            @"Watch6,4"  : @"Apple Watch Series 6 44mm",
            @"Watch6,6"  : @"Apple Watch Series 7 42mm",
            @"Watch6,7"  : @"Apple Watch Series 7 45mm",
            @"Watch6,8"  : @"Apple Watch Series 7 41mm",
            @"Watch6,9"  : @"Apple Watch Series 7 45mm",
            
            @"AudioAccessory1,1" : @"HomePod",
            @"AudioAccessory1,2" : @"HomePod",
            @"AudioAccessory5,1" : @"HomePod mini",
            
            @"AirPods1,1" : @"AirPods (1st generation)",
            @"AirPods1,2" : @"AirPods (2nd generation)",
            @"AirPods2,1" : @"AirPods (2nd generation)",
            @"AirPods1,3" : @"AirPods (3rd generation)",
            @"Audio2,1"   : @"AirPods (3rd generation)",
            @"AirPods2,2"   : @"AirPods Pro",
            @"AirPodsPro1,1": @"AirPods Pro",
            @"iProd8,1"     : @"AirPods Pro",
            @"AirPodsPro1,2" : @"AirPods Pro (2nd generation)",
            @"AirPodsMax1,1" : @"AirPods Max",
            @"iProd8,6"      : @"AirPods Max",
            
            @"AppleTV1,1"   : @"Apple TV 1",
            @"AppleTV2,1"   : @"Apple TV 2",
            @"AppleTV3,1"   : @"Apple TV 3",
            @"AppleTV3,2"   : @"Apple TV 3",
            @"AppleTV5,3"   : @"Apple TV 4",
            @"AppleTV6,2"   : @"Apple TV 4K",
            @"AppleTV11,1"  : @"Apple TV 4K (2nd generation)",
        };
        name = dict[model];
        if (!name) name = model;
        if ([self vv_isSimulator]) name = [name stringByAppendingString:@" Simulator"];
    });
    return name;
}

static NSInteger _isSimulator = -1;
+ (BOOL)vv_isSimulator {
    if (_isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        _isSimulator = 1;
#else
        _isSimulator = 0;
#endif
    }
    return _isSimulator > 0;
}

+ (NSString *)vv_localizedModel {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(localizedModel)]) {
        NSString *localizedModel = [[UIDevice currentDevice] localizedModel];
        return localizedModel;
    } else {
        return nil;
    }
}

+ (NSString *)vv_carrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return [carrier carrierName];
}

@end


@implementation NSObject (VinSwitchCase)

- (void)vv_switch:(NSDictionary<id<NSCopying>, VinCaseBlock> *)cases {
    [self vv_switch:cases withDefault:nil];
}

- (void)vv_switch:(NSDictionary<id<NSCopying>, VinCaseBlock> *)cases withDefault:(nullable VinCaseBlock)defaultBlock {
    NSAssert([self conformsToProtocol:@protocol(NSCopying)], @"必须遵守 <NSCopying> 协议");
    if (!cases || ![cases isKindOfClass:NSDictionary.class] || ![self conformsToProtocol:@protocol(NSCopying)]) {
        return;
    }
    VinCaseBlock caseBlock = nil;
    if ([self isKindOfClass:NSNumber.class]) {
        NSString *switchKey = vv_handleLossPrecision(((NSNumber *)self).doubleValue);
        NSNumber *caseKey;
        for (id item in cases.allKeys) {
            if ([item isKindOfClass:NSNumber.class]) {
                NSString *itemKey = vv_handleLossPrecision(((NSNumber *)item).doubleValue);
                if ([switchKey isEqualToString:itemKey]) {
                    caseKey = item;
                    break;
                }
            }
        }
        if (caseKey) {
            caseBlock = cases[caseKey];
        }
    } else {
        caseBlock = cases[(id<NSCopying>)self];
    }
    if (caseBlock) {
        caseBlock();
    } else if (defaultBlock) {
        defaultBlock();
    }
}

/// 处理精度丢失
NSString *vv_handleLossPrecision(double value) {
    NSInteger scale = vv_getDecimalDigits(value);
    scale = scale >= 12 ? 12 : scale;
    double total = pow(10, scale);
    double rounded = round(value * total);
    NSDecimalNumber *totalDeciaml = [NSDecimalNumber vv_decimalNumberWithDouble:total roundingScale:0 roundingMode:NSRoundDown];
    NSDecimalNumber *roundedDeciaml = [NSDecimalNumber vv_decimalNumberWithDouble:rounded roundingScale:0 roundingMode:NSRoundDown];
    NSDecimalNumber *rounded_up = [roundedDeciaml vv_dividing:totalDeciaml];
    NSString *str = [NSString vv_stringRoundDownFromNumber:rounded_up fractionDigits:scale];
    return [NSString vv_deleteSuffixAllZero:str];
}

/// 获取小数位数精度
NSInteger vv_getDecimalDigits(double number) {
    if (number == (long)number) return 0;
    NSInteger i = 0;
    while (true){
        i++;
        double total = number * pow(10, i);
        if (fmod(total,1) == 0) {
            return i;
        }
    }
}

@end

@implementation NSObject (UIKit)

+ (UIWindow *)vv_keyWindow {
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:UIWindowScene.class] && scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

@end
