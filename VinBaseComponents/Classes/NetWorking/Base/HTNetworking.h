//
//  HTNetworking.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTRequestListConfigure.h"
#import "HTNetworkCache.h"
#import "HTNetworkTaskInfo.h"
#import "HTAppDotNetAPIClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTNetworking : NSObject

// 设置请求超时时间，默认为90秒
@property (assign, nonatomic) NSTimeInterval  ht_timeout;
// 当检查到网络异常时，是否从从本地提取数据,默认false
@property (assign, nonatomic) BOOL  ht_shouldObtain;
// 是否开启接口打印信息,默认true
@property (assign, nonatomic) BOOL  ht_isDebug;
// 是否encode url,默认false
@property (assign, nonatomic) BOOL  ht_shouldEncode;
// 当取消请求时，是否要回调,默认false
@property (assign, nonatomic) BOOL  ht_shouldCallbackCancelRequest;
// 请求格式，默认为JSON,默认kHTRequestTypeJSON
@property (assign, nonatomic) HTRequestType  ht_requestType;
// 响应格式，默认为JSON,默认kHTResponseTypeData
@property (assign, nonatomic) HTResponseType  ht_responseType;
// 网络状态
@property (assign, nonatomic) HTNetworkStatus  ht_networkStatus;


+ (instancetype)networkWithCache:(HTNetworkCache *)cache
                        withTask:(HTNetworkTaskInfo *)taskInfo;

/**
 *
 *    常用请求
 *
 *    @param configure                                   配置信息
 *    @param url                                                请求路径
 *    @param parameter                                   参数
 *    @param formDataBlock                          用于上传图片（requestType为：kHTNetworRequestTypePostFormData）
 *    @param progressBlock                          进度
 *    @param successBlock                            成功回调
 *    @param failureBlock                            失败回调
 */
- (HTURLSessionTask *)requestConfigure:(HTRequestListConfigure * _Nullable)configure
                                   url:(NSString * _Nullable)url
                             parameter:(id _Nullable)parameter
                         formDataBlock:(HTFormData _Nullable)formDataBlock
                         progressBlock:(HTTransProgress _Nullable)progressBlock
                          successBlock:(HTResponseSuccess _Nullable)successBlock
                          failureBlock:(HTResponseFail _Nullable)failureBlock;

/**
 *
 *    上传文件
 *
 *    @param url                                                上传路径
 *    @param uploadingFile                          待上传文件的路径
 *    @param progressBlock                          进度
 *    @param successBlock                            成功回调
 *    @param failureBlock                            失败回调
 */
- (HTURLSessionTask *)uploadFileWithUrl:(NSString * _Nullable)url
                          uploadingFile:(NSString * _Nullable)uploadingFile
                          progressBlock:(HTTransProgress _Nullable)progressBlock
                           successBlock:(HTResponseSuccess _Nullable)successBlock
                           failureBlock:(HTResponseFail _Nullable)failureBlock;


/*!
 *
 *    下载文件
 *
 *    @param url                                                下载URL
 *    @param saveToPath                                 保存路径
 *    @param progressBlock                          进度
 *    @param successBlock                            成功回调
 *    @param failureBlock                            失败回调
 */
- (HTURLSessionTask *)downloadWithUrl:(NSString * _Nullable)url
                           saveToPath:(NSString * _Nullable)saveToPath
                        progressBlock:(HTTransProgress _Nullable)progressBlock
                         successBlock:(HTResponseSuccess _Nullable)successBlock
                         failureBlock:(HTResponseFail _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
