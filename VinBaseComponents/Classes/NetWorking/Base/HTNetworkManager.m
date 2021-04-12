//
//  HTNetworkManager.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTNetworkManager.h"

@interface HTNetworkManager ()
@property (nonatomic,strong) HTNetworking *ht_Network;
@property (nonatomic,strong) HTNetworkCache *ht_NetworkCache;
@property (nonatomic,strong) HTNetworkTaskInfo *ht_NetworkTask;
@end

@implementation HTNetworkManager
+ (instancetype)manager {
    
    static HTNetworkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init];
        _instance.ht_NetworkCache = [[HTNetworkCache alloc] init];
        _instance.ht_NetworkTask = [[HTNetworkTaskInfo alloc] init];
        _instance.ht_Network = [HTNetworking networkWithCache:_instance.ht_NetworkCache
                                                     withTask:_instance.ht_NetworkTask];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

+ (HTNetworking *)network {
    return [[self manager] ht_Network];
}

+ (HTNetworkCache *)networkCache {
    return [[self manager] ht_NetworkCache];
}

+ (HTNetworkTaskInfo *)networkTaskInfo {
    return [[self manager] ht_NetworkTask];
}
@end
