//
//  AddCityView.m
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import "AddCityView.h"
#import "CityAddCollectionViewCell.h"
#import "CityManager.h"
#import "CityAddSearchResultCell.h"
#import "CitySearcher.h"

#define CAV_Cell_Identifier @"collectionCell"

@interface AddCityView()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic) UIView                *naviView;
@property (nonatomic) UIImageView           *searchIconImageView;
@property (nonatomic) UITextField           *searchTextFiled;
@property (nonatomic) UIButton              *backButton;
@property (nonatomic) UITableView           *searchResultsTableView;
@property (nonatomic) NSArray               *searchResults;
@property (nonatomic) UILabel               *hotCityTitleLabel;
@property (nonatomic) UICollectionView      *hotCitiesCollectionView;
@property (nonatomic) NSArray               *hotCities;
@property (nonatomic) UIControl             *coverView;
@property (nonatomic) NSMutableDictionary   *existHotCityIndexes;
@property (nonatomic) NSMutableDictionary   *existSearchCityIndexes;
@end

@implementation AddCityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        _hotCities = [CityManager sharedInstance].hotCities;
        _existHotCityIndexes = [NSMutableDictionary dictionary];
        [self filterItemsFromSrcArray:_hotCities toExistDictionary:_existHotCityIndexes];
        _existSearchCityIndexes = [NSMutableDictionary dictionary];
        
        self.backgroundColor = [UIColor colorWithRed:0xea/255.0 green:0xea/255.0 blue:0xea/255.0 alpha:1];
        
        float yModifierY = (isIOS7 ? 20 : 0);
        
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + yModifierY)];
        _naviView.backgroundColor = [UIColor colorWithRed:0x33 / 255.0 green:0x33 / 255.0 blue:0x33 / 255.0 alpha:1.0];
        [self addSubview:_naviView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, yModifierY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - yModifierY)];
        [self addSubview:contentView];
        
        // 搜索框
        _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 19, 19)];
        _searchIconImageView.image = [UIImage imageNamed:@"search_icon"];
        [contentView addSubview:_searchIconImageView];
        
        _searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, 230, 44)];
        _searchTextFiled.textColor = [UIColor whiteColor];
        _searchTextFiled.font = [UIFont systemFontOfSize:15];
//        _searchTextFiled.placeholder = @"输入城市地区的名称";
        _searchTextFiled.clearButtonMode = UITextFieldViewModeAlways;
        _searchTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searchTextFiled.delegate = self;
        [contentView addSubview:_searchTextFiled];
        
        // 返回按钮
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(270, 0, 50, 44);
        _backButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onTapBackButton) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:_backButton];
        
        // 热点城市
        _hotCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 44 + 15, 280, 40)];
        _hotCityTitleLabel.backgroundColor = [UIColor clearColor];
        _hotCityTitleLabel.font = [UIFont systemFontOfSize:20];
        _hotCityTitleLabel.textColor = [UIColor colorWithRed:0x55/255.0 green:0x55/255.0 blue:0x55/255.0 alpha:1.0];
        _hotCityTitleLabel.text = @"热点城市";
        [contentView addSubview:_hotCityTitleLabel];
        [contentView sendSubviewToBack:_hotCityTitleLabel];
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(100, 50);
        layout.minimumInteritemSpacing = 5;
        _hotCitiesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_hotCityTitleLabel.frame), 320, CGRectGetHeight(contentView.bounds) - CGRectGetMaxY(_hotCityTitleLabel.frame)) collectionViewLayout:layout];
        _hotCitiesCollectionView.backgroundColor = [UIColor clearColor];
        [_hotCitiesCollectionView registerClass:[CityAddCollectionViewCell class] forCellWithReuseIdentifier:CAV_Cell_Identifier];
        _hotCitiesCollectionView.dataSource = self;
        _hotCitiesCollectionView.delegate = self;
        [contentView addSubview:_hotCitiesCollectionView];
        
        // 遮罩
        _coverView = [[UIControl alloc] initWithFrame:CGRectMake(0, 44, 320, CGRectGetHeight(contentView.bounds) - 44)];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.382];
        [_coverView addTarget:self action:@selector(opTapCover) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:_coverView];
        _coverView.hidden = YES;
        
        // 搜索结果列表
        _searchResultsTableView = [[UITableView alloc] initWithFrame:_coverView.frame];
        _searchResultsTableView.backgroundColor = self.backgroundColor;
        _searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchResultsTableView.rowHeight = 64;
        _searchResultsTableView.dataSource = self;
        _searchResultsTableView.delegate = self;
        _searchResultsTableView.hidden = YES;
        [contentView addSubview:_searchResultsTableView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.hotCities count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityAddCollectionViewCell *cell = (CityAddCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CAV_Cell_Identifier forIndexPath:indexPath];
    City *city = [self.hotCities objectAtIndex:indexPath.row];
    [cell reloadData:city.name
            isExists:([self.existHotCityIndexes objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] != nil)];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    City *city = [_hotCities objectAtIndex:indexPath.row];
    [self didSelectCity:city];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _coverView.hidden = NO;
    _coverView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         weakSelf.coverView.alpha = 1;
                     }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *curText = [textField.text mutableCopy];
    [curText replaceCharactersInRange:range withString:string];
//    NSLog(@"textField(%@) string(%@) curText(%@) %s", textField.text, string, curText, __func__);
    if ([curText length] <= 0) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.15
                         animations:^{
                             weakSelf.searchResultsTableView.alpha = 0;
                         } completion:^(BOOL finished) {
                             weakSelf.searchResultsTableView.hidden = YES;
                             weakSelf.searchResultsTableView.alpha = 1;
                         }];
        return YES;
    }
    
    self.searchResultsTableView.hidden = NO;

    __weak typeof(self) weakSelf = self;
    
    NSArray *results = [[CitySearcher sharedInstance] searchForKeyword:curText];
    weakSelf.searchResults = results;
    [weakSelf filterItemsFromSrcArray:weakSelf.searchResults toExistDictionary:weakSelf.existSearchCityIndexes];
    [weakSelf.searchResultsTableView reloadData];
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         weakSelf.searchResultsTableView.alpha = 0;
                     } completion:^(BOOL finished) {
                         weakSelf.searchResultsTableView.hidden = YES;
                         weakSelf.searchResultsTableView.alpha = 1;
                     }];
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResults count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    CityAddSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CityAddSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    City *city = [self.searchResults objectAtIndex:indexPath.row];
    BOOL isExists = ([self.existSearchCityIndexes objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] != nil);
    [cell reloadData:city.name isExists:isExists];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    City *city = [self.searchResults objectAtIndex:indexPath.row];
    [self didSelectCity:city];
}

#pragma mark -
- (void)opTapCover{
    __weak typeof(self) weakSelf = self;
    [self.searchTextFiled resignFirstResponder];
    [UIView animateWithDuration:0.15
                     animations:^{
                         weakSelf.coverView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.coverView.hidden = YES;
                     }];
}

#pragma mark -
- (void)onTapBackButton{
    if ([[CityManager sharedInstance].cities count] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请至少添加一个城市"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.tapBackHandler) {
        self.tapBackHandler();
    }
}

- (void)didSelectCity:(City *)city{
    __block BOOL isExists = NO;
    [[CityManager sharedInstance].cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([city isEqual:obj]) {
            isExists = YES;
            *stop = YES;
        }
    }];
    
    if (isExists) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您已添加过这个城市"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        if (self.wantsAddCityHandler) {
            self.wantsAddCityHandler(city);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.searchResultsTableView) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.searchTextFiled resignFirstResponder];
        });
    }
}

#pragma mark - tools
- (void)filterItemsFromSrcArray:(NSArray *)srcArray toExistDictionary:(NSMutableDictionary *)existDictionary{
    [existDictionary removeAllObjects];
    [srcArray enumerateObjectsUsingBlock:^(City *srcObj, NSUInteger srcIdx, BOOL *srcStop) {
        [[CityManager sharedInstance].cities enumerateObjectsUsingBlock:^(City *city, NSUInteger idx, BOOL *stop) {
            if ([srcObj isEqual:city]){
                [existDictionary setObject:@(YES) forKey:[NSString stringWithFormat:@"%d", srcIdx]];
                *stop = YES;
            }
        }];
    }];
}

@end
