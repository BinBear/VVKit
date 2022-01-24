//
//  NSDictionary+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSDictionary+VinKit.h"

@implementation NSDictionary (VinKit)

+ (NSDictionary *)vv_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2 {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dict1];
    NSMutableDictionary * resultTemp = [NSMutableDictionary dictionaryWithDictionary:dict1];
    [resultTemp addEntriesFromDictionary:dict2];
    [resultTemp enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([dict1 objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[dict1 objectForKey: key] vv_dictionaryByMergingWith:(NSDictionary *)obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        } else if([dict2 objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[dict2 objectForKey: key] vv_dictionaryByMergingWith:(NSDictionary *)obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        }
    }];
    return [result copy];
    
}

- (NSDictionary *)vv_dictionaryByMergingWith:(NSDictionary *)dict {
    return [[self class] vv_dictionaryByMerging:self with:dict];
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

- (nullable NSString *)vv_jsonSortKeyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingSortedKeys error:&error];
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
