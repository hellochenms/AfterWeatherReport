//
//  CityManager.h
//  pm25App
//
//  Created by Dragonet on 14-7-20.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface CityManager : NSObject 
+ (CityManager*)sharedInstance;
@property (nonatomic) NSMutableArray   *cities;
@property (nonatomic) City      *defaultCity;
@property (nonatomic) NSArray   *hotCities;//
- (void)addCity:(City*)city;
- (void)insertCity:(City*)city atIndex:(NSUInteger)index;
- (void)removeCity:(City*)city;
- (void)moveCityFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)updateDateWithCompletionHandler:(void (^)(void))completionHandler failHandler:(void (^)(void))failHandler;
@end
