//
//  CityAddSearchResultCell.m
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import "CityAddSearchResultCell.h"

@interface CityAddSearchResultCell()
@property (nonatomic) UILabel *addressLabel;
@end

@implementation CityAddSearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 64)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textColor = [UIColor colorWithRed:0x55/255.0 green:0x55/255.0 blue:0x55/255.0 alpha:1];
        _addressLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_addressLabel];
        
        UIView *selectedBackgroundView = [UIView new];
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd8/255.0 green:0xd8/255.0 blue:0xd8/255.0 alpha:1];
        self.selectedBackgroundView = selectedBackgroundView;
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 63, 300, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithRed:0xd8/255.0 green:0xd8/255.0 blue:0xd8/255.0 alpha:1];
        [self.contentView addSubview:bottomLineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)reloadData:(NSString *)address isExists:(BOOL)isExists{
    _addressLabel.text = address;
    _addressLabel.textColor = (isExists ? [UIColor lightGrayColor] : [UIColor colorWithRed:0x55/255.0 green:0x55/255.0 blue:0x55/255.0 alpha:1]);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
