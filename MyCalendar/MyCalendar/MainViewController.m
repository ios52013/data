//
//  MainViewController.m
//  MyCalendar
//
//  Created by 钟文成(外包) on 2018/1/29.
//  Copyright © 2018年 钟文成(外包). All rights reserved.
//

#import "MainViewController.h"
#import "HYRCalendarViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 200, 150);
    button.center = self.view.center;
    
    [button setTitle:@"日程排期" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button addTarget:self action:@selector(calendarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)calendarButtonClick:(UIButton *)button{
    HYRCalendarViewController *calendarVC = [[HYRCalendarViewController alloc] init];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

@end
