//
//  HTNetworkTaskInfo.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTNetworkTaskInfo : NSObject

// 请求中的Tasks数组
- (NSMutableArray *)resumingSingleTasks;

// 添加请求的Task
- (void)addResumingSingleTask:(NSURLSessionTask *)task;

// 取消请求的Task
- (void)cancelResumingSingleTask:(NSURLSessionTask *)task;

// 根据URL取消请求
- (void)cancelResumingSingleTaskWithURL:(NSString *)url;

// 取消所有请求
- (void)cancelAllResumingSingleTask;

@end

NS_ASSUME_NONNULL_END
