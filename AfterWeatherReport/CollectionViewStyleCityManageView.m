//
//  CollectionViewStyleCityManageView.m
//  AfterWeatherReport
//
//  Created by Chen Meisong on 14-8-8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CollectionViewStyleCityManageView.h"
#import "M2SimpleGridView.h"
#import "CollectionViewStyleCityCell.h"
#import "CityManager.h"

@interface CollectionViewStyleCityManageView()<M2SimpleGridViewDataSource, M2SimpleGridViewDelegate>
@property (nonatomic) UIView            *naviView;
@property (nonatomic) M2SimpleGridView  *cityGridView;
@property (nonatomic) UIButton          *backButton;
@property (nonatomic) UIButton          *editButton;
@end

@implementation CollectionViewStyleCityManageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0xea/255.0 green:0xea/255.0 blue:0xea/255.0 alpha:1];
        self.clipsToBounds = YES;
        
        float yModifierY = (isIOS7 ? 20 : 0);
        
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + yModifierY)];
        _naviView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_naviView];
        
        // contentView为适配iOS6/7而生
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, yModifierY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - yModifierY)];
        [self addSubview:contentView];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 60, 44);
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onTapBackButton) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:_backButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.center = CGPointMake(CGRectGetWidth(contentView.bounds) / 2, titleLabel.center.y);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = @"管理城市";
        [contentView addSubview:titleLabel];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(CGRectGetWidth(contentView.bounds) - 60, 0, 60, 44);
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(onTapEditButton) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:_editButton];
        
        _cityGridView = [[M2SimpleGridView alloc] initWithFrame:CGRectMake(0, 44 + (is4Inch ? 12 : 10), CGRectGetWidth(contentView.bounds), (is4Inch ? 480 : 396))];
        _cityGridView.dataSource = self;
        _cityGridView.delegate = self;
        [contentView addSubview:_cityGridView];
        
        [_cityGridView addObserver:self
                        forKeyPath:@"isEditing"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    }
    
    return self;
}

#pragma mark -
- (void)onTapBackButton{
    if (_cityGridView.isEditing) {
        [_cityGridView changeEditing:NO];
    }
    if (_tapBackHandler) {
        _tapBackHandler();
    }
}
- (void)onTapEditButton{
    [_cityGridView changeEditing:!_cityGridView.isEditing];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isEditing"]) {
        if (_cityGridView.isEditing) {
            [_editButton setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - M2SimpleGridViewDataSource
- (NSInteger)numberOfCellsInGridView:(M2SimpleGridView *)gridView{
    return [[CityManager sharedInstance].cities count];
}
- (UIView *)gridView:(M2SimpleGridView *)gridView cellAtIndex:(NSInteger)index{
    CollectionViewStyleCityCell *cell = [CollectionViewStyleCityCell new];
    City *city = [[CityManager sharedInstance].cities objectAtIndex:index];
    [cell reloadData:city];
    return cell;
}
- (CGSize)sizeOfCellForGridView:(M2SimpleGridView *)gridView{
    return CGSizeMake(88, (is4Inch ? 135 : 118));
}
- (NSInteger)cellCountInRowForGridView:(M2SimpleGridView *)gridView{
    return 3;
}
- (NSInteger)rowCountForGridView:(M2SimpleGridView *)gridView{
    return 3;
}
- (UIView *)addCellForGridView:(M2SimpleGridView *)gridView{
    UILabel *addView = [UILabel new];
    addView.backgroundColor = [UIColor blueColor];
    addView.textAlignment = NSTextAlignmentCenter;
    addView.text = @"添加城市";
    
    return addView;
}
- (UIImage *)imageOfDeleteCellForGridView:(M2SimpleGridView *)gridView{
    return [UIImage imageNamed:@"city_delete_button"];
}
- (CGSize)sizeOfDeleteCellForGridView:(M2SimpleGridView *)gridView{
    return CGSizeMake(20, 20);
}

#pragma mark - M2SimpleGridViewDelegate
- (void)wantsAddNewCellByGridView:(M2SimpleGridView *)gridView{
    if (_tapAddCityHandler) {
        _tapAddCityHandler();
    }
}
- (BOOL)gridView:(M2SimpleGridView *)gridView shouldDeleteCellAtIndex:(NSInteger)index{
    if ([[CityManager sharedInstance].cities count] <= 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请至少保留一个城市"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}
- (void)gridView:(M2SimpleGridView *)gridView wantsDeleteCellAtIndex:(NSInteger)index{
    if ([_delegate respondsToSelector:@selector(cityManageView:deleteCityAtIndex:)]) {
        [_delegate cityManageView:self deleteCityAtIndex:index];
    }
}
- (void)gridView:(M2SimpleGridView *)gridView wantsMoveCellFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    if ([_delegate respondsToSelector:@selector(cityManageView:moveCityFromIndex:toIndex:)]) {
        [_delegate cityManageView:self moveCityFromIndex:fromIndex toIndex:toIndex];
    }
}
- (void)gridView:(M2SimpleGridView *)gridView didSelectedCellAtIndex:(NSInteger)index{
    if (_delegate && [_delegate respondsToSelector:@selector(cityManageView:didSelectedCellAtIndex:)]) {
        [_delegate cityManageView:self didSelectedCellAtIndex:index];
    }
}

#pragma mark -
- (void)refreshUI{
    [_cityGridView reloadData];
}

#pragma mark - dealloc
- (void)dealloc{
    [_cityGridView removeObserver:self forKeyPath:@"isEditing"];
}

@end
