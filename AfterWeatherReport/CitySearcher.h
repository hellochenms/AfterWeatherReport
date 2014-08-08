//
//  CitySearcher.h
//  pm25App
//
//  Created by Chen Meisong on 14-8-6.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySearcher : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)searchForKeyword:(NSString *)keyword;
@end
