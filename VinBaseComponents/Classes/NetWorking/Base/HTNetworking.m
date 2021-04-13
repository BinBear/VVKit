//
//  HTNetworking.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTNetworking.h"
#import "HTJSON.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <ReactiveObjC/ReactiveObjC.h>

#ifndef __OPTIMIZE__
#define NSLog(...) {}
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
#define NSLog(...) {}
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

@interface HTNetworking ()
@property (strong, nonatomic) HTAppDotNetAPIClient *netManager;
@property (strong, nonatomic) HTNetworkCache *networkCache;
@property (strong, nonatomic) HTNetworkTaskInfo *networkTask;
@end

@implementation HTNetworking

+ (instancetype)networkWithCache:(HTNetworkCache *)cache
                        withTask:(HTNetworkTaskInfo *)taskInfo {
    HTNetworking *netWork = [[self alloc] init];
    netWork.networkCache = cache;
    netWork.networkTask = taskInfo;
    [netWork defaultNetworkConfigure];
    return netWork;
}

- (HTURLSessionTask *)requestConfigure:(HTRequestListConfigure *)configure
                                   url:(NSString *)url
                             parameter:(id)parameter
                         formDataBlock:(HTFormData)formDataBlock
                         progressBlock:(HTTransProgress)progressBlock
                          successBlock:(HTResponseSuccess)successBlock
                          failureBlock:(HTResponseFail)failureBlock{
    
    if (![url isKindOfClass:NSString.class] || url.length == 0) {return nil;}
    if (self.ht_shouldEncode) {
        url = [self ht_URLEncode:url];
    }
    NSString *cacheKey  = @"";
    if (configure.isCache) {cacheKey = url;}
    
    HTAppDotNetAPIClient *manager = [self netManager];
    [self handleRequestData];
    [self handleHTTPHeader:configure.getHttpHeaderParams];
    HTURLSessionTask *sessionTask = nil;
    
    if (self.ht_networkStatus == kHTNetworkStatusNotReachable ||  self.ht_networkStatus == kHTNetworkStatusUnknown ) {
        id cacheData = nil;
        if (configure.isCache) {
            cacheData = [self.networkCache getCacheForKey:cacheKey];
        }
        cacheData ?
        (!successBlock ?: [self handleSuccessCallback:successBlock withTask:nil withResponse:cacheData]) :
        (!failureBlock ?: [self handleFailCallback:failureBlock WithTask:nil WithError:nil]);
        if (self.ht_isDebug) {
            NSString *errorStr = @"当前网络不可用，且无缓存数据";
            cacheData ?
            [self logWithSuccessResponse:cacheData
                                     url:url
                                  params:parameter] :
            [self logWithFailError:[NSError errorWithDomain:errorStr code:-10086 userInfo:nil]
                               url:url
                            params:parameter];
        }
        return nil;
    }
    

    @weakify(self);
    // 成功回调
    void (^success)(NSURLSessionDataTask *, id) =
    ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        @strongify(self);
        !configure.isCache ?: [self.networkCache setCache:responseObject forKey:cacheKey];
        !successBlock ?: [self handleSuccessCallback:successBlock withTask:task withResponse:responseObject];
        !self.ht_isDebug ?:[self logWithSuccessResponse:responseObject
                                                    url:url
                                                 params:parameter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(.1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [self.networkTask cancelResumingSingleTask:task];
        });
    };
    // 失败回调
    void (^failure)(NSURLSessionDataTask *, NSError *) =
    ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error){
        @strongify(self);
        id cacheData = nil;
        if (configure.isCache) {
            cacheData = [self.networkCache getCacheForKey:cacheKey];
        }
        cacheData ?
        (!successBlock ?: [self handleSuccessCallback:successBlock withTask:task withResponse:cacheData]) :
        (!failureBlock ?: [self handleFailCallback:failureBlock WithTask:task WithError:error]);
        !self.ht_isDebug ?:[self logWithFailError:error
                                              url:url
                                           params:parameter];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(.1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [self.networkTask cancelResumingSingleTask:task];
        });
    };
    // 传输进度回调
    void (^transProgress)(NSProgress * _Nonnull progress) =
    ^(NSProgress * _Nonnull progress){
        !progressBlock ?: progressBlock(progress.completedUnitCount,progress.totalUnitCount);
    };
    
    switch (configure.getRequestMethodType) {
        case kHTNetworRequestTypeGet:{
            sessionTask = [manager GET:url
                            parameters:parameter
                               headers:nil
                              progress:transProgress
                               success:success
                               failure:failure];
        }break;
        case kHTNetworRequestTypePost:{
            sessionTask = [manager POST:url
                             parameters:parameter
                                headers:nil
                               progress:transProgress
                                success:success
                                failure:failure];
        }break;
        case kHTNetworRequestTypePostFormData:{
            sessionTask = [manager POST:url
                             parameters:parameter
                                headers:nil
              constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                !formDataBlock ?: formDataBlock(formData);
            }
                               progress:transProgress
                                success:success
                                failure:failure];
        }break;
        case kHTNetworRequestTypeHead:{
            @weakify(self);
            sessionTask = [manager HEAD:url
                             parameters:parameter
                                headers:nil
                                success:^(NSURLSessionDataTask * _Nonnull task) {
                @strongify(self);
                !successBlock ?: successBlock(nil,task);
                [self.networkTask cancelResumingSingleTask:task];
            }
                                failure:failure];
        }break;
        case kHTNetworRequestTypePatch:{
            sessionTask = [manager PATCH:url
                              parameters:parameter
                                 headers:nil
                                 success:success
                                 failure:failure];
        }break;
        case kHTNetworRequestTypeDelete:{
            sessionTask = [manager DELETE:url
                               parameters:parameter
                                  headers:nil
                                  success:success
                                  failure:failure];
        }break;
        default:
            break;
    }
    
    [sessionTask resume];
    
    if (![self.networkTask.resumingSingleTasks containsObject:sessionTask]) {
        [self.networkTask addResumingSingleTask:sessionTask];
    }
    
    return sessionTask;
}

- (HTURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                          progressBlock:(HTTransProgress)progressBlock
                           successBlock:(HTResponseSuccess)successBlock
                           failureBlock:(HTResponseFail)failureBlock {
    if (![url isKindOfClass:NSString.class] || url.length == 0) {return nil;}
    if (self.ht_shouldEncode) {
        url = [self ht_URLEncode:url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    HTAppDotNetAPIClient *manager = [self netManager];
    [self handleRequestData];
    HTURLSessionTask *sessionTask = nil;
    @weakify(self);
    sessionTask =
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        !progressBlock ?: progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        @strongify(self);
        error ?
        (!failureBlock ?: [self handleFailCallback:failureBlock WithTask:nil WithError:nil]):
        (!successBlock ?: [self handleSuccessCallback:successBlock withTask:nil withResponse:responseObject]);
        
        error ?
        (!self.ht_isDebug ?: [self logWithFailError:error
                                                url:url
                                             params:nil]):
        (!self.ht_isDebug ?: [self logWithSuccessResponse:responseObject
                                                      url:url
                                                   params:nil]);

        [self.networkTask cancelResumingSingleTask:sessionTask];
    }];
    
    [sessionTask resume];
    
    if (![self.networkTask.resumingSingleTasks containsObject:sessionTask]) {
        [self.networkTask addResumingSingleTask:sessionTask];
    }
    
    return sessionTask;;
}


- (HTURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                        progressBlock:(HTTransProgress)progressBlock
                         successBlock:(HTResponseSuccess)successBlock
                         failureBlock:(HTResponseFail)failureBlock {
    if (![url isKindOfClass:NSString.class] || url.length == 0) {return nil;}
    if (self.ht_shouldEncode) {
        url = [self ht_URLEncode:url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    HTAppDotNetAPIClient *manager = [self netManager];
    [self handleRequestData];
    
    HTURLSessionTask *sessionTask = nil;
    @weakify(self);
    sessionTask =
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        !progressBlock ?: progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        @strongify(self);
        error ?
        (!failureBlock ?: [self handleFailCallback:failureBlock WithTask:nil WithError:nil]):
        (!successBlock ?: [self handleSuccessCallback:successBlock withTask:nil withResponse:filePath.absoluteString]);
        
        error ?
        (!self.ht_isDebug ?: [self logWithFailError:error
                                                url:url
                                             params:nil]):
        (!self.ht_isDebug ?: [self logWithSuccessResponse:filePath.absoluteString
                                                      url:url
                                                   params:nil]);

        [self.networkTask cancelResumingSingleTask:sessionTask];
    }];
    
    [sessionTask resume];
    
    if (![self.networkTask.resumingSingleTasks containsObject:sessionTask]) {
        [self.networkTask addResumingSingleTask:sessionTask];
    }
    
    return sessionTask;
}
#pragma mark - Private
// 创建AF请求实体类
- (HTAppDotNetAPIClient *)netManager {
    if (!_netManager) {
        _netManager = [HTAppDotNetAPIClient sharedClient];
        _netManager.operationQueue.maxConcurrentOperationCount = 5;
        _netManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _netManager.responseSerializer.acceptableContentTypes =
        [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/jpeg",
                                                                                  @"image/png",
                                                                                  @"application/x-www-form-urlencoded",
                                                                                  @"multipart/form-data"
                                                                                  ]];
        [self detectNetwork];
    }
    return _netManager;
}

// 默认请求配置
- (void)defaultNetworkConfigure {
    self.ht_timeout = 90;
    self.ht_shouldObtain = false;
    self.ht_isDebug = true;
    self.ht_shouldEncode = false;
    self.ht_shouldCallbackCancelRequest = false;
    self.ht_requestType = kHTRequestTypeJSON;
    self.ht_responseType = kHTResponseTypeData;
    self.ht_networkStatus = kHTNetworkStatusReachableViaWWAN;
}
// 配置请求数据
- (void)handleRequestData{
    self.netManager.requestSerializer.timeoutInterval = self.ht_timeout;
    switch (self.ht_requestType) {
        case kHTRequestTypeJSON: {
            self.netManager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case kHTRequestTypePlainText: {
            self.netManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    switch (self.ht_responseType) {
        case kHTResponseTypeJSON: {
            self.netManager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kHTResponseTypeXML: {
            self.netManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kHTResponseTypeData: {
            self.netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
}
// 配置请求头
- (void)handleHTTPHeader:(NSDictionary *)header{
    NSDictionary *headerDic = HTJSONMake(header).dictionary;
    [headerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class] && [obj length] > 0) {
            [self.netManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }else{
            [self.netManager.requestSerializer setValue:nil forHTTPHeaderField:key];
        }
    }];
}
// 开启网络状态监测
- (void)detectNetwork{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            self.ht_networkStatus = kHTNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            self.ht_networkStatus = kHTNetworkStatusUnknown;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            self.ht_networkStatus = kHTNetworkStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            self.ht_networkStatus = kHTNetworkStatusReachableViaWiFi;
        }
    }];
}
// URL encode
- (NSString *)ht_URLEncode:(NSString *)url {
    if ([url respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        
        static NSString * const kAFCharacterIDCMeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharacterIDCMeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < url.length) {
            NSUInteger length = MIN(url.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [url rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [url substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)url,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}
// 处理成功回调
- (void)handleSuccessCallback:(HTResponseSuccess)success withTask:(NSURLSessionDataTask *)task withResponse:(id)responseData {
    if (success) {
        NSDictionary *dataDic = [self tryToParseData:responseData];
        success(dataDic,task);
    }
}
// 处理失败回调
- (void)handleFailCallback:(HTResponseFail)fail WithTask:(NSURLSessionDataTask *)task WithError:(NSError *)error{
    if ([error code] == NSURLErrorCancelled) {
        if (self.ht_shouldCallbackCancelRequest) {
            if (fail) {
                fail(error,task);
            }
        }
    } else {
        if (fail) {
            fail(error,task);
        }
    }
}
// 解析json数据
- (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) {
        return nil;
    }
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:NULL];
    }
    return dic;
}

// 处理日志
- (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    DDLogDebug(@"\n");
    DDLogDebug(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
          url,
          params,
          [self tryToParseData:response]);
}
- (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    DDLogDebug(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        DDLogDebug(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
                   url,
                   format,
                   params);
    } else {
        DDLogDebug(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
                   url,
                   format,
                   params,
                   [error localizedDescription]);
    }
}


@end
