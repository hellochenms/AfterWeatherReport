//
//  CollectionViewStyleCityCell.m
//  AfterWeatherReport
//
//  Created by Chen Meisong on 14-8-8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CollectionViewStyleCityCell.h"

@interface CollectionViewStyleCityCell()
@property (nonatomic) UILabel *label;
@end

@implementation CollectionViewStyleCityCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        
        _label = [[UILabel alloc] initWithFrame:frame];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_label];
        
    }
    return self;
}

- (void)reloadData:(City *)city {
    _label.text = city.name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
