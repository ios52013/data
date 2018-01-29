//
//  HYRCalendarHeaderView.h
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//
/**
 *
 *该类主要是控制日历的头部视图（最上面的当前年月、以及上下个月和星期几的视图展示）
 *
 **/


#import <UIKit/UIKit.h>
#import "HYRCalendarView.h"

//定义block
typedef void(^HYRCalendarHeaderViewBlock)(NSDate *date);
//定义枚举
typedef NS_ENUM(NSInteger,HYRCalendarHeaderViewType)
{
    LZBCalendarHeaderViewType_LeftDate,   //左边日期
    LZBCalendarHeaderViewType_CenterDate, //中间日期
};



@interface HYRCalendarHeaderView : UIView

/**
 声明属性
 */
@property (nonatomic, strong) NSDate *monthDate;
@property (nonatomic, copy)  HYRCalendarHeaderViewBlock previousMonthClick;
@property (nonatomic, copy)  HYRCalendarHeaderViewBlock nextMonthClick;

/**
 声明方法
 */
- (void)previousButtonClick;
- (void)nextButtonClick;

- (void)setPreviousMonthClick:(HYRCalendarHeaderViewBlock)previousMonthClick;
- (void)setNextMonthClick:(HYRCalendarHeaderViewBlock)nextMonthClick;
- (instancetype)initWithType:(HYRCalendarHeaderViewType)type style:(HYRCalendarAppearStyle *)style;


@end
