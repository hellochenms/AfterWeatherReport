//
//  CollectionViewStyleCityManageViewController.m
//  AfterWeatherReport
//
//  Created by Chen Meisong on 14-8-8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CollectionViewStyleCityManageViewController.h"
#import "CollectionViewStyleCityManageView.h"
#import "CityManager.h"
#import "AddCityViewController.h"

@interface CollectionViewStyleCityManageViewController ()<CityManageViewDelegate>
@end

@implementation CollectionViewStyleCityManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    if (isIOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
        frame.size.height -= 20;
    }
    
    CollectionViewStyleCityManageView *cityManageView = [[CollectionViewStyleCityManageView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    cityManageView.tapBackHandler = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    cityManageView.tapAddCityHandler = ^{
        AddCityViewController *addCityViewController = [AddCityViewController new];
        __weak AddCityViewController *weakAddCityViewController = addCityViewController;
        addCityViewController.tapBackHandler = ^{
            [weakAddCityViewController dismissViewControllerAnimated:YES completion:nil];
        };
        [weakSelf presentViewController:addCityViewController animated:YES completion:nil];
    };
    [self.view addSubview:cityManageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCity:)
                                                 name:kGlobal_NotificationName_WantsAddCity
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CityManageViewDelegate
// 删除城市
- (void)cityManageView:(CollectionViewStyleCityManageView *)cityManageView deleteCityAtIndex:(NSInteger)index{
    [[CityManager sharedInstance] removeCity:[[CityManager sharedInstance].cities objectAtIndex:index]];
}
// 移动城市
- (void)cityManageView:(CollectionViewStyleCityManageView *)cityManageView moveCityFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    [[CityManager sharedInstance] moveCityFromIndex:fromIndex toIndex:toIndex];
}
// 选中城市
- (void)cityManageView:(CollectionViewStyleCityManageView *)cityManageView didSelectedCellAtIndex:(NSInteger)index{
//    WeatherCity *selectedWeatherCity = [[WeatherCityManager sharedManager].weatherCities objectAtIndex:index];
//    if (selectedWeatherCity != [WeatherCityManager sharedManager].defaultWeatherCity) {
//        [WeatherCityManager sharedManager].defaultWeatherCity = selectedWeatherCity;
//        [_weatherView changeDefaultCity];
//    }
//    [self hideAddCityView];
}
// 添加城市
- (void)addCity:(NSNotification *)notification{
    City *city = notification.object;
    [[CityManager sharedInstance] addCity:city];
    [CityManager sharedInstance].defaultCity = city;
//    [[CityManager sharedInstance] updatePM25WithCompletionHandler:nil failHandler:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
