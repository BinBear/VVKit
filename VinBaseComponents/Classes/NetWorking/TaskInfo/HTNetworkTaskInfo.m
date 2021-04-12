//
//  HTNetworkTaskInfo.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTNetworkTaskInfo.h"
#import <os/lock.h>

@interface HTNetworkTaskInfo ()
@property (strong, nonatomic) NSMutableArray *resumingTasksArry;
@property (assign, nonatomic) os_unfair_lock  taskLock;
@end

@implementation HTNetworkTaskInfo

- (instancetype)init{
    if (self = [super init]) {
        self.taskLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}


// 请求中的Tasks数组
- (NSMutableArray *)resumingSingleTasks{
    return self.resumingTasksArry;
}

// 添加请求的Task
- (void)addResumingSingleTask:(NSURLSessionTask *)task{
    os_unfair_lock_lock(&_taskLock);
    if ([task isKindOfClass:NSURLSessionTask.class]) {
        [self.resumingTasksArry addObject:task];
    }
    os_unfair_lock_unlock(&_taskLock);
}

// 取消请求的Task
- (void)cancelResumingSingleTask:(NSURLSessionTask *)task{
    os_unfair_lock_lock(&_taskLock);
    if ([task isKindOfClass:NSURLSessionTask.class] &&
        task.state != NSURLSessionTaskStateCanceling &&
        task.state != NSURLSessionTaskStateCompleted) {
        [task cancel];
        [self.resumingTasksArry removeObject:task];
    }
    os_unfair_lock_unlock(&_taskLock);
}

// 根据URL取消请求
- (void)cancelResumingSingleTaskWithURL:(NSString *)url{
    os_unfair_lock_lock(&_taskLock);
    for (NSURLSessionTask *task in self.resumingTasksArry) {
        if (task.state != NSURLSessionTaskStateCanceling &&
            task.state != NSURLSessionTaskStateCompleted &&
            [task.currentRequest.URL.absoluteString hasSuffix:url]) {
            [task cancel];
            [self.resumingTasksArry removeObject:task];
        }
    }
    os_unfair_lock_unlock(&_taskLock);
}

// 取消所有请求
- (void)cancelAllResumingSingleTask{
    os_unfair_lock_lock(&_taskLock);
    for (NSURLSessionTask *task in self.resumingTasksArry) {
        if (task.state != NSURLSessionTaskStateCanceling &&
            task.state != NSURLSessionTaskStateCompleted) {
            [task cancel];
        }
    }
    [self.resumingTasksArry removeAllObjects];
    os_unfair_lock_unlock(&_taskLock);
}
#pragma mark - Getter
- (NSMutableArray *)resumingTasksArry{
    if (!_resumingTasksArry) {
        _resumingTasksArry = @[].mutableCopy;
    }
    return _resumingTasksArry;
}
@end
