//
//  City.m
//  AfterWeatherReport
//
//  Created by Chen Meisong on 14-8-8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "City.h"

@implementation City

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.updateDate forKey:@"updateDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.updateDate = [coder decodeObjectForKey:@"updateDate"];
    }
    return self;
}

#pragma mark -
- (BOOL)isEqual:(id)object {
    if ([super isEqual:object]) {
        return YES;
    }
    if (![object isKindOfClass:[City class]]) {
        return NO;
    }
    City *city = object;
    
    return ([self.name isEqualToString:city.name]);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@%@", [super description], self.name];
}
@end
