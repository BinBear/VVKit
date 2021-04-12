//
//  HTRequestListConfigure.h
//  HeartTrip
//
//  Created by vin on 2020/11/13.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworkTypeDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTRequestListConfigure : NSObject

+ (instancetype)defaultConfigure;

- (HTRequestListConfigure *(^)(BOOL))showHUD;
- (HTRequestListConfigure *(^)(BOOL))showError;
- (HTRequestListConfigure *(^)(BOOL))signature;
- (HTRequestListConfigure *(^)(BOOL))cache;
- (HTRequestListConfigure *(^)(BOOL))needToken;
- (HTRequestListConfigure *(^)(BOOL))needHandleLoginState;
- (HTRequestListConfigure *(^)(BOOL))needQuery;
- (HTRequestListConfigure *(^)(HTNetworkRequestType))requestMethodType;
- (HTRequestListConfigure *(^)(HTRequestType))requestType;
- (HTRequestListConfigure *(^)(HTResponseType))responseType;
- (HTRequestListConfigure *(^)(id))serverName;
- (HTRequestListConfigure *(^)(NSString *))uploadFile;
- (HTRequestListConfigure *(^)(NSString *))uploadFileName;
- (HTRequestListConfigure *(^)(NSDictionary *))httpHeaderParams;

- (BOOL)isShowHUD;
- (BOOL)isShowError;
- (BOOL)isSignature;
- (BOOL)isCache;
- (BOOL)isNeedToken;
- (BOOL)isNeedHandleLoginState;
- (BOOL)isNeedQuery;
- (HTNetworkRequestType)getRequestMethodType;
- (HTRequestType)getRequestType;
- (HTResponseType)getResponseType;
- (id)getServerName;
- (NSString *)getUploadFile;
- (NSString *)getUploadFileName;
- (NSDictionary *)getHttpHeaderParams;



@end

NS_ASSUME_NONNULL_END
