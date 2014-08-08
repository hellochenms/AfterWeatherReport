//
//  HotCitiesConfig.m
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import "HotCitiesConfig.h"

@implementation HotCitiesConfig
+ (instancetype)sharedInstance{
    static HotCitiesConfig *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [HotCitiesConfig new];
    });
    
    return s_instance;
}

- (id)init{
    self = [super init];
    if (self) {
        NSData *hotCitiesJsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"]];
        _hotCities =  [NSJSONSerialization JSONObjectWithData:hotCitiesJsonData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return self;
}

@end
