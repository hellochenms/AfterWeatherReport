//
//  City.h
//  AfterWeatherReport
//
//  Created by Chen Meisong on 14-8-8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject<NSCoding>
@property (nonatomic) NSString  *name;
@property (nonatomic) NSDate    *updateDate;
@end
