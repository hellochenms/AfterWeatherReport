//
//  CityAddCollectionViewCell.m
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import "CityAddCollectionViewCell.h"

@interface CityAddCollectionViewCell()
@property (nonatomic) UIButton *cityButton;
@end

@implementation CityAddCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityButton.frame = CGRectMake(5, 0, 90, 50);
        _cityButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _cityButton.userInteractionEnabled = NO;
        [self addSubview:_cityButton];
    }
    return self;
}

- (void)reloadData:(NSString *)data isExists:(BOOL)isExists{
    [_cityButton setTitle:data forState:UIControlStateNormal];
    [self.cityButton setTitleColor:(isExists ? [UIColor lightGrayColor] : [UIColor colorWithRed:0x55/255.0 green:0x55/255.0 blue:0x55/255.0 alpha:1]) forState:UIControlStateNormal];
}

@end
