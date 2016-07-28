//
//  NSObject+NSObjectWithNSDictionary.m
//  ZJTracker
//
//  Created by liudukun on 16/7/28.
//  Copyright © 2016年 liudukun. All rights reserved.
//

#import "NSObject+NSObjectWithNSDictionary.h"
#import "objc/runtime.h"


@implementation NSObject (NSObjectWithNSDictionary)


- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [self valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self objectsToDictionaryWithValue:value];//自定义处理数组，字典，其他类
        }
        [dicM setObject:value forKey:propName];
    }
    return dicM;
}

- (NSString *)toJsonString{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (instancetype)objectsToDictionaryWithValue:(id)value
{
    if([value isKindOfClass:[NSString class]]
       || [value isKindOfClass:[NSNumber class]]
       || [value isKindOfClass:[NSNull class]])
    {
        return value;
    }
    
    if([value isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = (NSArray *)value;
        NSMutableArray *arrM = [NSMutableArray array];
        for(id obj in objarr)
        {
            [arrM addObject:[obj toDictionary]];
        }
        return arrM;
    }
    
    if([value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *obj = (NSDictionary *)self;
        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
        for(NSString *key in obj.allKeys)
        {
            [dicM setObject:[obj toDictionary] forKey:key];
        }
        return dicM;
    }
    return [self toDictionary];
}

@end
