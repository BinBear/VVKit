//
//  HTRequestListConfigure.m
//  HeartTrip
//
//  Created by vin on 2020/11/13.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTRequestListConfigure.h"

@interface HTRequestListConfigure ()
@property (nonatomic,assign,getter=isConfigure_showHUD) BOOL configure_showHUD;
@property (nonatomic,assign,getter=isConfigure_showError) BOOL configure_showError;
@property (nonatomic,assign,getter=isConfigure_signature) BOOL configure_signature;
@property (nonatomic,assign,getter=isConfigure_cache) BOOL configure_cache;
@property (nonatomic,assign,getter=isConfigure_needToken) BOOL configure_needToken;
@property (nonatomic,assign,getter=isConfigure_needHandleLoginState) BOOL configure_needHandleLoginState;
@property (nonatomic,assign,getter=isConfigure_needQuery) BOOL configure_needQuery;
@property (nonatomic,assign,getter=isConfigure_requestMethodType) HTNetworkRequestType configure_requestMethodType;
@property (nonatomic,assign,getter=isConfigure_requestType) HTRequestType configure_requestType;
@property (nonatomic,assign,getter=isConfigure_responseType) HTResponseType configure_responseType;
@property (nonatomic,strong) id configure_serverName;
@property (nonatomic,  copy) NSString *configure_uploadFile;
@property (nonatomic,  copy) NSString *configure_uploadFileName;
@property (nonatomic,strong) NSDictionary *configure_httpHeaderParams;
@end

@implementation HTRequestListConfigure


+ (instancetype)defaultConfigure {
    HTRequestListConfigure *configure = [[self alloc] init];
    configure.configure_showHUD = false;
    configure.configure_signature = false;
    configure.configure_cache = false;
    configure.configure_needToken = false;
    configure.configure_needQuery = false;
    configure.configure_showError = true;
    configure.configure_needHandleLoginState = true;
    configure.configure_requestType = kHTRequestTypeJSON;
    configure.configure_uploadFile = @"file";

    return configure;
}

- (HTRequestListConfigure *(^)(BOOL))showHUD {
    return ^HTRequestListConfigure *(BOOL showHUD) {
        self.configure_showHUD = showHUD;
        return self;
    };
}
- (HTRequestListConfigure *(^)(BOOL))showError {
    return ^HTRequestListConfigure *(BOOL showError) {
        self.configure_showError = showError;
        return self;
    };
}
- (HTRequestListConfigure *(^)(BOOL))signature {
    return ^HTRequestListConfigure *(BOOL signature) {
        self.configure_signature = signature;
        return self;
    };
}
- (HTRequestListConfigure *(^)(BOOL))cache {
    return ^HTRequestListConfigure *(BOOL cache) {
        self.configure_cache = cache;
        return self;
    };
}

- (HTRequestListConfigure *(^)(BOOL))needToken {
    return ^HTRequestListConfigure *(BOOL needToken) {
        self.configure_needToken = needToken;
        return self;
    };
}

- (HTRequestListConfigure * _Nonnull (^)(BOOL))needHandleLoginState{
    return ^HTRequestListConfigure *(BOOL needHandleLoginState) {
        self.configure_needHandleLoginState = needHandleLoginState;
        return self;
    };
}

- (HTRequestListConfigure *(^)(BOOL))needQuery {
    return ^HTRequestListConfigure *(BOOL needQuery) {
        self.configure_needQuery = needQuery;
        return self;
    };
}


- (HTRequestListConfigure *(^)(HTNetworkRequestType))requestMethodType {
    return ^HTRequestListConfigure *(HTNetworkRequestType requestType) {
        self.configure_requestMethodType = requestType;
        return self;
    };
}

- (HTRequestListConfigure *(^)(HTRequestType))requestType {
    return ^HTRequestListConfigure *(HTRequestType requestType) {
        self.configure_requestType = requestType;
        return self;
    };
}

- (HTRequestListConfigure *(^)(HTResponseType))responseType {
    return ^HTRequestListConfigure *(HTResponseType requestType) {
        self.configure_responseType = requestType;
        return self;
    };
}

- (HTRequestListConfigure *(^)(id))serverName {
    return ^HTRequestListConfigure *(id serverName) {
        self.configure_serverName = serverName;
        return self;
    };
}

- (HTRequestListConfigure * _Nonnull (^)(NSString * _Nonnull))uploadFile{
    return ^HTRequestListConfigure *(NSString *uploadFile){
        self.configure_uploadFile = uploadFile;
        return self;
    };
}

- (HTRequestListConfigure * _Nonnull (^)(NSString * _Nonnull))uploadFileName{
    return ^HTRequestListConfigure *(NSString *uploadFileName){
        self.configure_uploadFileName = uploadFileName;
        return self;
    };
}

- (HTRequestListConfigure *(^)(NSDictionary *))httpHeaderParams {
    return ^HTRequestListConfigure *(NSDictionary *params){
        self.configure_httpHeaderParams = params;
        return self;
    };
}

- (BOOL)isShowHUD {
    return self.isConfigure_showHUD;
}

- (BOOL)isShowError {
    return self.isConfigure_showError;
}

- (BOOL)isSignature{
    return self.isConfigure_signature;
}

- (BOOL)isCache{
    return self.isConfigure_cache;
}
- (BOOL)isNeedToken{
    return self.isConfigure_needToken;
}
- (BOOL)isNeedHandleLoginState{
    return self.isConfigure_needHandleLoginState;
}
- (BOOL)isNeedQuery{
    return self.isConfigure_needQuery;
}
- (HTNetworkRequestType)getRequestMethodType{
    return self.configure_requestMethodType;
}
- (HTRequestType)getRequestType{
    return self.isConfigure_requestType;
}
- (HTResponseType)getResponseType{
    return self.configure_responseType;
}
- (id)getServerName {
    return self.configure_serverName;
}
- (NSString *)getUploadFile{
    return self.configure_uploadFile;
}
- (NSString *)getUploadFileName{
    return self.configure_uploadFileName;
}
- (NSDictionary *)getHttpHeaderParams {
    return self.configure_httpHeaderParams;
}


@end
