//
//  AddCityView.h
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

typedef void (^WantsAddCityHandler)(City *);

@interface AddCityView : UIView
@property (nonatomic, copy) TapButtonHandler tapBackHandler;
@property (nonatomic, copy) WantsAddCityHandler wantsAddCityHandler;
@end
