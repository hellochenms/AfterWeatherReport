//
//  CityAddCollectionViewCell.h
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityAddCollectionViewCell : UICollectionViewCell
- (void)reloadData:(NSString *)data isExists:(BOOL)isExists;
@end
