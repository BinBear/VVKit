//
//  NSArray+VinKit.m
//  HotCoin
//
//  Created by vin on 2021/5/25.
//

#import "NSArray+VinKit.h"

@implementation NSArray (VinKit)

- (void)vv_each:(void (NS_NOESCAPE ^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        !block ? : block(obj);
    }];
}

- (void)vv_eachWithIndex:(void (NS_NOESCAPE ^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        !block ? : block(obj, idx);
    }];
}

- (NSArray *)vv_map:(id (NS_NOESCAPE ^)(id object))block {
    if (!block) { return self; }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        id item = block(object);
        if (item) {
            [result addObject:item];
        }
    }
    return result;
}

- (NSArray *)vv_mapWithIndex:(id (NS_NOESCAPE ^)(NSInteger index, id item))block {
    if (!block) { return self; }

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id item = block(idx,obj);
        if (item) {
            [result addObject:item];
        }
    }];
    return [result copy];
}

- (NSArray *)vv_filter:(BOOL (NS_NOESCAPE ^)(id object))block {
    if (!block) { return self; }
    
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)vv_reject:(BOOL (NS_NOESCAPE ^)(id object))block {
    if (!block) { return self; }
    
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

- (id)vv_detect:(BOOL (NS_NOESCAPE ^)(id object))block {
    if (!block) { return nil; }
    
    for (id object in self) {
        if (block(object)) {
            return object;
        }
    }
    return nil;
}

- (id)vv_reduce:(id (NS_NOESCAPE ^)(id accumulator, id object))block {
    return [self vv_reduce:nil withBlock:block];
}

- (id)vv_reduce:(id _Nullable)initial withBlock:(id (NS_NOESCAPE ^)(id _Nullable accumulator, id object))block {
    if (!block) { return nil; }
    id accumulator = initial;
    
    for(id object in self) {
        accumulator = accumulator ? block(accumulator, object) : object;
    }
    return accumulator;
}

- (nullable NSString *)vv_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (jsonData) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return nil;
}

- (nullable NSString *)vv_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData) {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    return nil;
}

@end

@implementation NSArray (VinSort)

#pragma mark -
#pragma mark 二分查找（循环）
- (NSInteger)vv_bsearchWithLoop:(NSString *)propertyName value:(double)value {
    NSInteger low = 0;
    NSInteger high = self.count - 1;
    
    while (low <= high)
    {
        //为什么不写(low + high) / 2，是因为如果 low 和 high 比较大的话，两者之和就有可能会溢出。
        NSInteger mid = low + ((high - low) >> 1);
        double middleNumber = [[self[mid] valueForKey:propertyName] doubleValue];
        if ([@(middleNumber) compare:@(value)] == NSOrderedSame)
        {
            return mid;
        }
        else if ([@(middleNumber) compare:@(value)] == NSOrderedAscending)
        {
            low = mid + 1;
        }
        else
        {
            high = mid - 1;
        }
    }
    
    return -1;
}

#pragma mark -
#pragma mark 二分查找（递归）
- (NSInteger)vv_bsearchWithRecursion:(NSString *)propertyName value:(double)value {
    return [self vv_bsearchInternally:propertyName value:value low:0 high:self.count - 1];
}

- (NSInteger)vv_bsearchInternally:(NSString *)propertyName value:(double)value low:(NSInteger)low high:(NSInteger)high {
    if (low > high)
    {
        return -1;
    }
    
    //相比除法运算来说，计算机处理位运算要快得多。这里也等同于（NSInteger mid = low + (high - low) / 2）
    NSInteger mid = low + ((high - low) >> 1);
    double middleNumber = [[self[mid] valueForKey:propertyName] doubleValue];
    if ([@(middleNumber) compare:@(value)] == NSOrderedSame)
    {
        return mid;
    }
    else if ([@(middleNumber) compare:@(value)] == NSOrderedAscending)
    {
        return [self vv_bsearchInternally:propertyName value:value low:mid + 1 high:high];
    }
    else
    {
        return [self vv_bsearchInternally:propertyName value:value low:low high:mid - 1];
    }
}

#pragma mark -
#pragma mark 二分查找第一个给定值（循环）
- (NSInteger)vv_bsearchFirstItemWithLoop:(NSString *)propertyName value:(double)value {
    NSInteger low = 0;
    NSInteger high = self.count - 1;
    
    while (low <= high)
    {
        //为什么不写(low + high) / 2，是因为如果 low 和 high 比较大的话，两者之和就有可能会溢出。
        NSInteger mid = low + ((high - low) >> 1);
        double middleNumber = [[self[mid] valueForKey:propertyName] doubleValue];
        if ([@(middleNumber) compare:@(value)] == NSOrderedDescending)
        {
            high = mid - 1;
        }
        else if ([@(middleNumber) compare:@(value)] == NSOrderedAscending)
        {
            low = mid + 1;
        }
        else
        {
            if (mid == 0 || [@([[self[mid - 1] valueForKey:propertyName] doubleValue]) compare:@(value)] != NSOrderedSame)
            {
                return mid;
            }
            else
            {
                high = mid - 1;
            }
        }
    }
    
    return -1;
}

#pragma mark -
#pragma mark 二分查找最后一个给定值（循环）
- (NSInteger)vv_bsearchLastItemWithLoop:(NSString *)propertyName value:(double)value {
    NSInteger low = 0;
    NSInteger high = self.count - 1;
    
    while (low <= high)
    {
        //为什么不写(low + high) / 2，是因为如果 low 和 high 比较大的话，两者之和就有可能会溢出。
        NSInteger mid = low + ((high - low) >> 1);
        double middleNumber = [[self[mid] valueForKey:propertyName] doubleValue];
        if ([@(middleNumber) compare:@(value)] == NSOrderedDescending)
        {
            high = mid - 1;
        }
        else if ([@(middleNumber) compare:@(value)] == NSOrderedAscending)
        {
            low = mid + 1;
        }
        else
        {
            if (mid == self.count - 1 || [@([[self[mid + 1] valueForKey:propertyName] doubleValue]) compare:@(value)] != NSOrderedSame)
            {
                return mid;
            }
            else
            {
                low = mid + 1;
            }
        }
    }
    
    return -1;
}

#pragma mark -
#pragma mark 二分查找第一个大于等于给定值（循环）
- (NSInteger)vv_bsearchMoreWithLoop:(NSString *)propertyName value:(double)value {
    NSInteger low = 0;
    NSInteger high = self.count - 1;
    
    while (low <= high)
    {
        NSInteger mid = low + ((high - low) >> 1);
        double middleNumber = [[self[mid] valueForKey:propertyName] doubleValue];
        if ([@(middleNumber) compare:@(value)] == NSOrderedAscending)
        {
            low = mid + 1;
        }
        else
        {
            if (mid == 0 || [@([[self[mid - 1] valueForKey:propertyName] doubleValue]) compare:@(value)] == NSOrderedAscending)
            {
                return mid;
            }
            else
            {
                high = mid - 1;
            }
        }
    }
    
    return -1;
}

#pragma mark -
#pragma mark 二分查找最后一个小于等于给定值的元素
- (NSInteger)vv_bsearchLessWithLoop:(NSString *)propertyName value:(double)value {
    NSInteger low = 0;
    NSInteger high = self.count - 1;
    
    while (low <= high)
    {
        NSInteger mid = low + ((high - low) >> 1);
        double middleNumber = [[self[mid] valueForKey:propertyName] doubleValue];
        if ([@(middleNumber) compare:@(value)] == NSOrderedDescending)
        {
            high = mid - 1;
        }
        else
        {
            if (mid == self.count - 1 || [@([[self[mid + 1] valueForKey:propertyName] doubleValue]) compare:@(value)] == NSOrderedDescending)
            {
                return mid;
            }
            else
            {
                low = mid + 1;
            }
        }
    }
    
    return -1;
}

@end
