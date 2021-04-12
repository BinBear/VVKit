//
//  HTNetworkCache.m
//  HeartTrip
//
//  Created by vin on 2020/11/19.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTNetworkCache.h"
#import <YYCache/YYCache.h>

static NSString *const KEY_YYNetworkCache = @"HT_YYNetworkCache";

@interface HTNetworkCache ()
@property (nonatomic,strong) YYCache *yyCache;
@end

@implementation HTNetworkCache

- (id<NSCoding>)getCacheForKey:(NSString *)key {
    return [self.yyCache objectForKey:key];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key {
    [self.yyCache setObject:cache forKey:key];
}

- (void)removeCacheForKey:(NSString *)key {
    [[YYCache cacheWithName:KEY_YYNetworkCache].diskCache removeObjectForKey:key];
}

- (void)removeAllCaches {
    [[YYCache cacheWithName:KEY_YYNetworkCache].diskCache removeAllObjects];
}

- (unsigned long long)totalCacheSize {
    return [YYCache cacheWithName:KEY_YYNetworkCache].diskCache.totalCost;
}

- (YYCache *)yyCache {
    if (!_yyCache){
        _yyCache = [YYCache cacheWithName:KEY_YYNetworkCache];
        _yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;;
    }
    return _yyCache;
}

@end
