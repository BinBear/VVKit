//
//  HTRequestList.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HTDataSuccess)(NSDictionary *response);

typedef void(^HTDataFail)(NSError *error,NSURLSessionTask *task);

typedef void(^HTRequestConfigure)(HTRequestListConfigure *configure);

@interface HTRequestList : NSObject

/**
 post请求
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (HTURLSessionTask *)requestPost:(NSString * _Nullable)url
                           params:(id _Nullable)params
                        configure:(HTRequestConfigure _Nullable)configure
                          success:(HTDataSuccess _Nullable)success
                             fail:(HTDataFail _Nullable)fail;

/**
 get请求
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (HTURLSessionTask *)requestGet:(NSString * _Nullable)url
                          params:(id _Nullable)params
                       configure:(HTRequestConfigure _Nullable)configure
                         success:(HTDataSuccess _Nullable)success
                            fail:(HTDataFail _Nullable)fail;

@end

NS_ASSUME_NONNULL_END
