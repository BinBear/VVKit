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

typedef NS_ENUM(NSInteger, HTNetworkStatus) {
    kHTNetworkStatusUnknown          = -1,//未知网络
    kHTNetworkStatusNotReachable     = 0,//网络无连接
    kHTNetworkStatusReachableViaWWAN = 1,//2，3，4G网络
    kHTNetworkStatusReachableViaWiFi = 2,//WIFI网络
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


#ifndef ht_weakify
#if __has_feature(objc_arc)

#define ht_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define ht_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef ht_strongify
#if __has_feature(objc_arc)

#define ht_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define ht_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif


#endif /* HTNetworkTypeDefine_h */
