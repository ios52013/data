//
//  HYRCalendarViewController.m
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import "HYRCalendarViewController.h"
#import "HYRCalendarView.h"
#import "HYRCalendarAppearStyle.h"
#import "NSDate+HYRComponent.h"
#import "UIImage+HYRComponent.h"
#import "HYRMeetingTableViewController.h"


@interface HYRCalendarViewController ()<HYRCalendarViewDataSource,HYRCalendarViewDataDelegate>

@property (nonatomic, strong) HYRCalendarView *calendar;
@property (nonatomic, strong) HYRCalendarAppearStyle *style;

@end

@implementation HYRCalendarViewController


/**
 程序的生命周期
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.navigationItem.title = @"日程";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加背景图
    [self setBackgroundImage];
    //添加日历对象
    [self.view addSubview:self.calendar];
    
}

#pragma mark - 设置背景图
- (void)setBackgroundImage {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    //bgImageView.image = [UIImage imageForName:@"bg-nav" type:@"png"];
    bgImageView.image = [UIImage imageNamed:@"bg-nav"];
    bgImageView.alpha = 0.7;
    [self.view addSubview:bgImageView];
}

#pragma mark - 屏幕翻转就会调用
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.calendar.frame = CGRectMake(40, 0, [UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.height);
}



#pragma mark - delegate
- (void)calendar:(HYRCalendarView *)calendar didSelectDate:(NSDate *)date andCurrentItem:(HYRCalendarDateCell *)item
{
    HYRMeetingTableViewController *meetingTVC = [[HYRMeetingTableViewController alloc] init];
    meetingTVC.modalPresentationStyle = UIModalPresentationPopover;
    meetingTVC.popoverPresentationController.sourceView = item;
    meetingTVC.popoverPresentationController.sourceRect = item.bounds;
    [self presentViewController:meetingTVC animated:YES completion:nil];
}


#pragma mark - dataSoure
- (NSString *)calendar:(HYRCalendarView *)calendar titleForDate:(NSDate *)date
{
    if([[NSDate date] getDateWithMonth] == [date getDateWithMonth])
    {
        NSInteger result =[[NSDate date] getDateWithDay] -[date getDateWithDay];
        switch (result) {
            case 0:
                return @"今天";
                break;
//            case 1:
//                return @"昨天";
//                break;
//            case -1:
//                return @"明天";
//                break;
                
            default:
                return nil;
                break;
        }
    }
    else
        return nil;
}


- (NSString *)calendar:(HYRCalendarView *)calendar subtitleForDate:(NSDate *)date
{
    NSInteger result = [date getDateWithDay];
    switch (result) {
        case 1:
            return @"3个会议";
            break;
        case 9:
            return @"5个会议";
            break;
        case 18:
            return @"2个会议";
            break;
        case 23:
            return @"8个会议";
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)calendar:(HYRCalendarView *)calendar layoutCallBackHeight:(CGFloat)height
{
    //self.calendar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
}


#pragma mark - lazy
- (HYRCalendarView *)calendar
{
    if(_calendar == nil)
    {
        _calendar = [[HYRCalendarView alloc]initWithStyle:self.style];
        _calendar.dataSource = self;
        _calendar.delegate = self;
    }
    return _calendar;
}

- (HYRCalendarAppearStyle *)style
{
    if(_style == nil)
    {
        _style = [[HYRCalendarAppearStyle alloc]init];
        _style.isNeedCustomHeihgt = YES;
        
    }
    return _style;
}


@end
