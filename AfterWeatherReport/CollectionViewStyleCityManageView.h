//
//  CollectionViewStyleCityManageView.h
//  AfterWeatherReport
//
//  Created by Chen Meisong on 14-8-8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityManageViewDelegate;

@interface CollectionViewStyleCityManageView : UIView
@property (nonatomic, copy) TapButtonHandler tapBackHandler;
@property (nonatomic, copy) TapButtonHandler tapAddCityHandler;
@property (nonatomic, weak) id<CityManageViewDelegate> delegate;
- (void)refreshUI;
@end

@protocol CityManageViewDelegate <NSObject>
- (void)cityManageView:(CollectionViewStyleCityManageView *)cityManageView deleteCityAtIndex:(NSInteger)index;
- (void)cityManageView:(CollectionViewStyleCityManageView *)cityManageView moveCityFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)cityManageView:(CollectionViewStyleCityManageView *)cityManageView didSelectedCellAtIndex:(NSInteger)index;
@end
