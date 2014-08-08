//
//  CityManager.m
//  pm25App
//
//  Created by Dragonet on 14-7-20.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import "CityManager.h"

@interface CityManager()<NSCoding>
@end

@implementation CityManager
+ (CityManager*)sharedInstance {
    static CityManager *s_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @try {
            s_sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathOfDataFile]];
        }
        @catch (NSException *exception) {
            [[NSFileManager defaultManager] removeItemAtPath:[self pathOfDataFile] error:nil];
        }
        @finally {
            if (!s_sharedInstance) {
                s_sharedInstance = [CityManager new];
            }
        }
//        [s_sharedInstance loadHotCities];//
    });
    
    return s_sharedInstance;
}

+ (NSString*)pathOfDataFile {
    static NSString *s_pathOfDataFile = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_pathOfDataFile = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"cityManager.data"];
    });
    
    return s_pathOfDataFile;
}

- (id)init{
    self = [super init];
    if (self) {
        _cities = [NSMutableArray array];
        _defaultCity = nil;
        [self addDefaultCities];//TODO:
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronize) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronize) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronize) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

//// 热点城市
//- (void)loadHotCities{
//    NSArray *srcHotCities = [HotCitiesConfig sharedInstance].hotCities;
//    NSMutableArray *destHotCities = [NSMutableArray array];
//    __block CityInfo *city = nil;
//    [srcHotCities enumerateObjectsUsingBlock:^(NSDictionary *cityDic, NSUInteger idx, BOOL *stop) {
//        city = [CityInfo new];
//        city.name = [cityDic objectForKey:@"name"];
//        [destHotCities addObject:city];
//    }];
//    self.hotCities = destHotCities;
//}

#pragma mark - 城市操作：添加、删除、重排序等
- (void)addCity:(City*)city {
    if (!city || [self.cities containsObject:city]) {
        return;
    }
    __block BOOL isExists = NO;
    [self.cities enumerateObjectsUsingBlock:^(City* curCity, NSUInteger idx, BOOL *stop) {
        isExists = [city isEqual:curCity];
        *stop = isExists;
    }];
    if (!isExists) {
        [self.cities addObject:city];
        [self synchronize];
    }
}
- (void)insertCity:(City*)city atIndex:(NSUInteger)index {
    if (!city || [self.cities containsObject:city] || index >= [self.cities count]) {
        return;
    }
    __block BOOL isExists = NO;
    [self.cities enumerateObjectsUsingBlock:^(City* curCity, NSUInteger idx, BOOL *stop) {
        isExists = [city isEqual:curCity];
        *stop = isExists;
    }];
    if (!isExists) {
        [self.cities insertObject:city atIndex:index];
        [self synchronize];
    }
}
- (void)removeCity:(City*)city {
    NSUInteger index = [self.cities indexOfObject:city];
    if (NSNotFound != index) {
        if ([city isEqual:self.defaultCity]) {
            if ([self.cities count] == 1){
                self.defaultCity = nil;
            } else if (index == [self.cities count] - 1) {
                self.defaultCity = [self.cities objectAtIndex:index - 1];
            } else {
                self.defaultCity = [self.cities objectAtIndex:index + 1];
            }
        }
        [self.cities removeObjectAtIndex:index];
        [self synchronize];
    }
}
- (void)moveCityFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    City *city = [self.cities objectAtIndex:fromIndex];
    [self.cities removeObject:city];
    if (toIndex == [self.cities count]) {
        [self.cities addObject:city];
    } else {
        [self.cities insertObject:self.cities atIndex:toIndex];
    }
    [self synchronize];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cities forKey:@"cities"];
    [aCoder encodeObject:self.defaultCity forKey:@"defaultCity"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _cities = [coder decodeObjectForKey:@"cities"];
        _defaultCity = [coder decodeObjectForKey:@"defaultCity"];
        if ([_cities indexOfObject:_defaultCity] == NSNotFound) {
            _defaultCity = [self.cities objectAtIndex:0];
        }
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(onApplicationDidBecomeActive)
//                                                     name:UIApplicationDidBecomeActiveNotification
//                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(synchronize)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(synchronize)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronize) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

#pragma mark -
//- (void)onApplicationDidBecomeActive{
//    [self.updateTimer invalidate];
//    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerFireUpdatePM25) userInfo:nil repeats:YES];
//}

#pragma mark - timer
//- (void)onTimerFireUpdatePM25{
//    NSTimeInterval interval = 60 * 30;
//    if (!self.isFirstLoadPM25Done
//        || -[self.defaultCity.updateDate timeIntervalSinceNow]  > interval) {
//        self.isFirstLoadPM25Done = YES;
//        [self updatePM25WithCompletionHandler:nil failHandler:nil];
//    }
//}

#pragma mark - network
- (void)updateDateWithCompletionHandler:(void (^)(void))completionHandler failHandler:(void (^)(void))failHandler{
//    [self.pm25Operation cancel];
//    NSMutableString *citiesString = [NSMutableString string];
//    [self.citiesArr enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
//        [citiesString appendString:[NSString stringWithFormat:@"%@,", city.name]];
//    }];
//    if ([citiesString length] > 0) {
//        [citiesString deleteCharactersInRange:NSMakeRange([citiesString length] - 1, 1)];
//    }
//    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://182.92.101.56/aqi?cities=", citiesString];
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlString(%@)  %s", urlString, __func__);
//    self.pm25Operation = [[PM25Engine sharedInstance] operationWithURLString:urlString];
//    __weak typeof(self) weakSelf = self;
//    [self.pm25Operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSDictionary *cityPM25s = completedOperation.responseJSON;
//        if (![cityPM25s isKindOfClass:[NSDictionary class]]) {
//            return;
//        }
//        __block id cityDic = nil;
//        NSDate *updateDate = [NSDate date];
//        [weakSelf.citiesArr enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
//            cityDic = [cityPM25s objectForKey:city.name];
//            if (!cityDic || cityDic == [NSNull null] || ![cityDic isKindOfClass:[NSDictionary class]]) {
//                weakSelf.isLoadingPM25 = NO;
//                return;
//            }
//            city.airQuality = [AirQuality airQualityWithDictionary:cityDic];
//            city.updateDate = updateDate;
//            if (completionHandler) {
//                completionHandler();
//            }
//        }];
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        NSLog(@"error(%@)  %s", error, __func__);
//        if (failHandler) {
//            failHandler();
//        }
//    }];
//    [[PM25Engine sharedInstance] enqueueOperation:self.pm25Operation];
}

#pragma mark -
- (void)addDefaultCities {
    
    for (NSInteger index = 0; index < 3; index++) {
        City* city = [City new];
        switch (index) {
            case 0:
            city.name = @"北京";
            break;
            
            case 1:
            city.name = @"上海";
            break;
            
            case 2:
            city.name = @"广州";
            break;
            
            default:
            break;
        }
        
        [self addCity:city];
    }
}

#pragma mark -
- (void)synchronize {
    [NSKeyedArchiver archiveRootObject:self toFile:[self.class pathOfDataFile]];
}

#pragma mark - 
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
