//
//  NSObject+NSObjectWithNSDictionary.h
//  ZJTracker
//
//  Created by liudukun on 16/7/28.
//  Copyright © 2016年 liudukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObjectWithNSDictionary)

- (NSDictionary*)toDictionary;

- (NSString *)toJsonString;

@end

