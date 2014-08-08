//
//  HotCitiesConfig.h
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCitiesConfig : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, readonly) NSArray *hotCities;
@end
