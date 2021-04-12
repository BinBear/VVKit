//
//  HTNetworkManager.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTNetworkManager : NSObject

+ (HTNetworking *)network;

+ (HTNetworkCache *)networkCache;

+ (HTNetworkTaskInfo *)networkTaskInfo;

@end

NS_ASSUME_NONNULL_END
