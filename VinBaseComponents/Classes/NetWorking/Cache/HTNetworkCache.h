//
//  HTNetworkCache.h
//  HeartTrip
//
//  Created by vin on 2020/11/19.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTNetworkCache : NSObject

- (id<NSCoding>)getCacheForKey:(NSString *)key;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key;

- (void)removeCacheForKey:(NSString *)key;
- (void)removeAllCaches;

- (unsigned long long)totalCacheSize;

@end

NS_ASSUME_NONNULL_END
