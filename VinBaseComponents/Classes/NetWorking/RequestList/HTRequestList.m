//
//  HTRequestList.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTRequestList.h"

@implementation HTRequestList

+ (HTURLSessionTask *)requestPost:(NSString *)url
                           params:(id)params
                        configure:(HTRequestConfigure)configure
                          success:(HTDataSuccess)success
                             fail:(HTDataFail)fail {
    HTRequestListConfigure *requestConfigure = [HTRequestListConfigure defaultConfigure];
    requestConfigure.requestMethodType(kHTNetworRequestTypePost);
    !configure ?: configure(requestConfigure);
    
    HTURLSessionTask *session =
    [HTNetworkManager.network requestConfigure:requestConfigure
                                           url:[self handelServiceUrl:url serverName:requestConfigure]
                                     parameter:params
                                 formDataBlock:nil
                                 progressBlock:nil
                                  successBlock:^(id  _Nullable response, NSURLSessionDataTask * _Nullable task) {
        !success?:success(response);
    }
                                  failureBlock:^(NSError * _Nullable error, NSURLSessionDataTask * _Nullable task) {
        !fail?:fail(error,task);
    }];
    
    
    return session;
}


+ (HTURLSessionTask *)requestGet:(NSString *)url
                          params:(id)params
                       configure:(HTRequestConfigure)configure
                         success:(HTDataSuccess)success
                            fail:(HTDataFail)fail {
    HTRequestListConfigure *requestConfigure = [HTRequestListConfigure defaultConfigure];
    requestConfigure.requestMethodType(kHTNetworRequestTypeGet);
    !configure ?: configure(requestConfigure);
    
    HTURLSessionTask *session =
    [HTNetworkManager.network requestConfigure:requestConfigure
                                           url:[self handelServiceUrl:url serverName:requestConfigure]
                                     parameter:params
                                 formDataBlock:nil
                                 progressBlock:nil
                                  successBlock:^(id  _Nullable response, NSURLSessionDataTask * _Nullable task) {
        !success?:success(response);
    }
                                  failureBlock:^(NSError * _Nullable error, NSURLSessionDataTask * _Nullable task) {
        !fail?:fail(error,task);
    }];
    
    
    return session;
}

#pragma mark - 根据服务名称跟请求地址获取完整链接
+ (NSString *)handelServiceUrl:(NSString *)url
                    serverName:(HTRequestListConfigure *)configure {
    NSString *urlStr = @"";
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        urlStr = url;
    } else {
        if ([configure.getServerName isKindOfClass:NSString.class] && [configure.getServerName length] > 0) {
            // 有多个服务，根据服务名称拼接URL
            urlStr = [NSString stringWithFormat:@"%@%@",configure.getServerName,url];
        }
    }
    return urlStr;
}

@end
