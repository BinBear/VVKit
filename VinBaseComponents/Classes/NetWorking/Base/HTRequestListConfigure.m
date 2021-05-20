//
//  HTRequestListConfigure.m
//  HeartTrip
//
//  Created by vin on 2020/11/13.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTRequestListConfigure.h"
#import <ReactiveObjC/ReactiveObjC.h>

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
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL showHUD) {
        @strongify(self);
        self.configure_showHUD = showHUD;
        return self;
    };
}
- (HTRequestListConfigure *(^)(BOOL))showError {
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL showError) {
        @strongify(self);
        self.configure_showError = showError;
        return self;
    };
}
- (HTRequestListConfigure *(^)(BOOL))signature {
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL signature) {
        @strongify(self);
        self.configure_signature = signature;
        return self;
    };
}
- (HTRequestListConfigure *(^)(BOOL))cache {
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL cache) {
        @strongify(self);
        self.configure_cache = cache;
        return self;
    };
}

- (HTRequestListConfigure *(^)(BOOL))needToken {
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL needToken) {
        @strongify(self);
        self.configure_needToken = needToken;
        return self;
    };
}

- (HTRequestListConfigure * _Nonnull (^)(BOOL))needHandleLoginState{
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL needHandleLoginState) {
        @strongify(self);
        self.configure_needHandleLoginState = needHandleLoginState;
        return self;
    };
}

- (HTRequestListConfigure *(^)(BOOL))needQuery {
    @weakify(self);
    return ^HTRequestListConfigure *(BOOL needQuery) {
        @strongify(self);
        self.configure_needQuery = needQuery;
        return self;
    };
}


- (HTRequestListConfigure *(^)(HTNetworkRequestType))requestMethodType {
    @weakify(self);
    return ^HTRequestListConfigure *(HTNetworkRequestType requestType) {
        @strongify(self);
        self.configure_requestMethodType = requestType;
        return self;
    };
}

- (HTRequestListConfigure *(^)(HTRequestType))requestType {
    @weakify(self);
    return ^HTRequestListConfigure *(HTRequestType requestType) {
        @strongify(self);
        self.configure_requestType = requestType;
        return self;
    };
}

- (HTRequestListConfigure *(^)(HTResponseType))responseType {
    @weakify(self);
    return ^HTRequestListConfigure *(HTResponseType requestType) {
        @strongify(self);
        self.configure_responseType = requestType;
        return self;
    };
}

- (HTRequestListConfigure *(^)(id))serverName {
    @weakify(self);
    return ^HTRequestListConfigure *(id serverName) {
        @strongify(self);
        self.configure_serverName = serverName;
        return self;
    };
}

- (HTRequestListConfigure * _Nonnull (^)(NSString * _Nonnull))uploadFile{
    @weakify(self);
    return ^HTRequestListConfigure *(NSString *uploadFile){
        @strongify(self);
        self.configure_uploadFile = uploadFile;
        return self;
    };
}

- (HTRequestListConfigure * _Nonnull (^)(NSString * _Nonnull))uploadFileName{
    @weakify(self);
    return ^HTRequestListConfigure *(NSString *uploadFileName){
        @strongify(self);
        self.configure_uploadFileName = uploadFileName;
        return self;
    };
}

- (HTRequestListConfigure *(^)(NSDictionary *))httpHeaderParams {
    @weakify(self);
    return ^HTRequestListConfigure *(NSDictionary *params){
        @strongify(self);
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
