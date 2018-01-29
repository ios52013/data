//
//  HYRCalendarHeaderView.m
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import "HYRCalendarHeaderView.h"

#define default_Button_Width  130
#define kWeekdayLabelLeftSpace  0

@interface HYRCalendarHeaderView()

@property (nonatomic, assign)  HYRCalendarHeaderViewType headType;
@property (nonatomic, strong)  HYRCalendarAppearStyle *style;
@property (nonatomic, strong)  UIView *topView;
@property (nonatomic, strong)  UIView *bottomView;
@property (nonatomic, strong)  UIView *lineView;
//topView控件
@property (nonatomic, strong)  UIButton *previousButton;
@property (nonatomic, strong)  UIButton *nextButton;
@property (nonatomic, strong)  UILabel *dateLable;
//bottomView控件
@property (nonatomic, strong) NSMutableArray <UILabel *> *weekdayLabels;
@end



@implementation HYRCalendarHeaderView

- (instancetype)initWithType:(HYRCalendarHeaderViewType)type style:(HYRCalendarAppearStyle *)style;
{
    if(self = [super init])
    {
        self.headType = type;
        self.style = style;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.topView];
    [self addSubview:self.lineView];
    [self addSubview:self.bottomView];
    
    [self.topView addSubview:self.dateLable];
    switch (self.headType)
    {
        case LZBCalendarHeaderViewType_LeftDate:
            break;
        case LZBCalendarHeaderViewType_CenterDate:
        {
            [self.topView addSubview:self.previousButton];
            [self.topView addSubview:self.nextButton];
            self.previousButton.hidden = NO;
            self.nextButton.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    //创建星期几的label
    for (NSInteger i = 0; i< self.style.weekDateDays.count; i++)
    {
        UILabel  *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:label];
        [self.weekdayLabels addObject:label];
    }
    
    [self initValidSettingData];
}

#pragma mark - 布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    
    if(self.style.isNeedCustomHeihgt)
    {
        self.topView.frame = CGRectMake(0, 0, selfWidth, self.style.headerViewDateHeight);
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), selfWidth, self.style.headerViewLineHeight);
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), selfWidth, self.style.headerViewWeekHeight);
        
        NSLog(@"------%@------%@-----%@",NSStringFromCGRect(self.topView.frame),NSStringFromCGRect(self.lineView.frame),NSStringFromCGRect(self.bottomView.frame));
        
        switch (self.headType)
        {
            case LZBCalendarHeaderViewType_LeftDate:
            {
                self.dateLable.frame =CGRectMake(0, 0, selfWidth, self.topView.frame.size.height);
                self.dateLable.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case LZBCalendarHeaderViewType_CenterDate:
            {
                
                self.previousButton.frame = CGRectMake(0, 0, default_Button_Width, self.topView.frame.size.height);
                self.nextButton.frame = CGRectMake(selfWidth-default_Button_Width, 0, default_Button_Width, self.topView.frame.size.height);
                self.dateLable.center = self.topView.center;
                self.dateLable.bounds = CGRectMake(0, 0, selfWidth - 2*default_Button_Width, self.topView.frame.size.height);
                self.dateLable.textAlignment = NSTextAlignmentCenter;
            }
                break;
                
            default:
                break;
        }
        
        CGFloat weekdayWidth = self.bottomView.bounds.size.width / self.style.weekDateDays.count;
        CGFloat weekdayHeight =self.bottomView.bounds.size.height;
        [self.weekdayLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger index, BOOL * _Nonnull stop) {
            
#pragma mark -修改星期几的label的frame
            label.frame = CGRectMake(index * weekdayWidth + kWeekdayLabelLeftSpace,0, weekdayWidth - kWeekdayLabelLeftSpace, weekdayHeight);
        }];
        
    }
    else
    {
        //计算高度
    }
    
    
}


#pragma mark - API
- (void)previousButtonClick
{
    self.monthDate = [self lastMonthDate:self.monthDate];
    if(self.previousMonthClick)
        self.previousMonthClick(self.monthDate);
}

- (void)nextButtonClick
{
    self.monthDate = [self nextMonth:self.monthDate];
    if(self.nextMonthClick)
        self.nextMonthClick(self.monthDate);
}



 #pragma mark - 设置头部的年月
- (void)setMonthDate:(NSDate *)monthDate
{
    _monthDate = monthDate;
    [self.dateLable setText:[NSString stringWithFormat:@"%ld年%.2ld月",(long)[self year:monthDate],(long)[self month:monthDate]]];
    
    //设置上个月和下个月的标题
    NSDate *lastDate = [self lastMonthDate:monthDate];
    [self.previousButton setTitle:[NSString stringWithFormat:@"%ld年%.2ld月",(long)[self year:lastDate],(long)[self month:lastDate]] forState:UIControlStateNormal];
    
    NSDate *nextDate = [self nextMonth:monthDate];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld年%.2ld月",(long)[self year:nextDate],(long)[self month:nextDate]] forState:UIControlStateNormal];
}

- (void)initValidSettingData
{
    [self invalidateHeaderFont];
    [self invalidateWeekdayFont];
    [self invalidateWeekdayTextColor];
    [self invalidateHeaderTextColor];
    [self.weekdayLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger index, BOOL * _Nonnull stop) {
        if(index < self.style.weekDateDays.count)
            label.text = self.style.weekDateDays[index];
    }];
}

- (void)invalidateHeaderFont
{
    self.dateLable.font = self.style.headerViewDateFont;
}
- (void)invalidateHeaderTextColor
{
    self.dateLable.textColor = self.style.headerViewDateColor;
}
- (void)invalidateWeekdayFont
{
    [self.weekdayLabels makeObjectsPerformSelector:@selector(setFont:) withObject:self.style.headerViewWeekFont];
}
- (void)invalidateWeekdayTextColor
{
    [self.weekdayLabels makeObjectsPerformSelector:@selector(setTextColor:) withObject:self.style.headerViewWeekColor];
}

#pragma mark- private
- (NSInteger)month:(NSDate *)date
{
    return [self getDateComponentsFromDate:date].month;
}

- (NSInteger)year:(NSDate *)date
{
    return [self getDateComponentsFromDate:date].year;
}

#pragma mark - 得到上个月的日期
- (NSDate *)lastMonthDate:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger currentMonth = [self month:date];
    if(currentMonth == 1)
    {
        dateComponents.year = -1;
        dateComponents.month = +11;
    }
    else
        dateComponents.month = -1;
    
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:NSCalendarWrapComponents];
    return newDate;
}

#pragma mark - 得到下个月的日期
- (NSDate*)nextMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger currentMonth = [self month:date];
    if(currentMonth == 12)
    {
        dateComponents.year = +1;
        dateComponents.month = -11;
    }
    else
        dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:NSCalendarWrapComponents];
    return newDate;
}

- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date
{
    NSDateComponents *component = [[NSCalendar currentCalendar] components:
                                   (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return component;
}



#pragma mark - lazy懒加载
-(UIView *)topView
{
    if(_topView == nil)
    {
        _topView = [UIView new];
        //_topView.backgroundColor = [UIColor greenColor];
    }
    return _topView;
}

- (UILabel *)dateLable
{
    if(_dateLable == nil)
    {
        _dateLable = [UILabel new];
    }
    return _dateLable;
}



#pragma mark - 上个月的按钮
- (UIButton *)previousButton
{
    if(_previousButton == nil)
    {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_previousButton setTitle:@"上一月" forState:UIControlStateNormal];
        
        [_previousButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        [_previousButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previousButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}


#pragma mark - 下个月的按钮
- (UIButton *)nextButton
{
    if(_nextButton == nil)
    {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_nextButton setTitle:@"下一月" forState:UIControlStateNormal];
        [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        [_nextButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}



#pragma mark - 星期几的view

- (UIView *)bottomView
{
    if(_bottomView == nil)
    {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    }
    return _bottomView;
}

- (NSMutableArray<UILabel *> *)weekdayLabels
{
    if(_weekdayLabels == nil)
    {
        _weekdayLabels = [NSMutableArray array];
    }
    return _weekdayLabels;
}

- (UIView *)lineView
{
    if(_lineView == nil)
    {
        _lineView = [UIView new];
    }
    return _lineView;
}

@end
