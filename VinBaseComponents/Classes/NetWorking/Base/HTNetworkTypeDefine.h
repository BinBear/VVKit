//
//  HTNetworkTypeDefine.h
//  HeartTrip
//
//  Created by vin on 2020/11/19.
//  Copyright © 2020 BinBear. All rights reserved.
//

#ifndef HTNetworkTypeDefine_h
#define HTNetworkTypeDefine_h


@class NSURLSessionTask;
@protocol AFMultipartFormData;

typedef NS_ENUM(NSUInteger, HTResponseType) {
    kHTResponseTypeJSON = 1, // 默认
    kHTResponseTypeXML  = 2, // XML
    kHTResponseTypeData = 3  // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
};

typedef NS_ENUM(NSUInteger, HTRequestType) {
    kHTRequestTypeJSON = 1, // 默认
    kHTRequestTypePlainText  = 2 // 普通text/html
};

typedef NS_ENUM(NSUInteger, HTNetworkRequestType) {
    kHTNetworRequestTypeGet,
    kHTNetworRequestTypePost,
    kHTNetworRequestTypePostFormData,
    kHTNetworRequestTypeHead,
    kHTNetworRequestTypePut,
    kHTNetworRequestTypePatch,
    kHTNetworRequestTypeDelete
};

typedef NSURLSessionTask HTURLSessionTask;

/*!
 *
 *  传输进度
 *
 *  @param bytesRead                 已传输的大小
 *  @param totalBytesRead            文件总大小
 *
 */
typedef void (^HTTransProgress)(int64_t bytesRead,int64_t totalBytesRead);

/*!
 *
 *  formData
 *
 *  @param formData                 formData数据
 *
 */
typedef void (^HTFormData)(id<AFMultipartFormData>  _Nullable formData);

/*!
 *
 *  请求成功的回调
 *
 *  @param response 服务端返回的数据
 */
typedef void(^HTResponseSuccess)(id _Nullable response,NSURLSessionDataTask * _Nullable task);

/*!
 *
 *  请求失败的回调
 *
 *  @param error 错误信息
 */
typedef void(^HTResponseFail)(NSError * _Nullable error,NSURLSessionDataTask * _Nullable task);


#endif /* HTNetworkTypeDefine_h */
