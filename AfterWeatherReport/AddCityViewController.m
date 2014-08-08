//
//  AddCityViewController.m
//  pm25App
//
//  Created by Chen Meisong on 14-8-3.
//  Copyright (c) 2014年 WLCZTeam. All rights reserved.
//

#import "AddCityViewController.h"
#import "AddCityView.h"
#import "City.h"

@interface AddCityViewController ()

@end

@implementation AddCityViewController

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
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!isIOS7) {
        frame.size.height -= 20;
    }
    
    AddCityView *addCityView = [[AddCityView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    addCityView.tapBackHandler = self.tapBackHandler;
    addCityView.wantsAddCityHandler = ^(City *city){
        [[NSNotificationCenter defaultCenter] postNotificationName:kGlobal_NotificationName_WantsAddCity object:city];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:addCityView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
