//
//  HYRCalendarView.h
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//
/**
 *
 *该类主要是控制日历的视图
 *
 **/

#import <UIKit/UIKit.h>
#import "HYRCalendarAppearStyle.h"
#import "HYRCalendarDateCell.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *定义数据源协议
 */
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@class HYRCalendarView;

@protocol HYRCalendarViewDataSource <NSObject>

@required
/**
 * Tells the dataSource a call back is the calendar of height.
 */
- (void)calendar:(HYRCalendarView *)calendar layoutCallBackHeight:(CGFloat)height;

@optional
/**
 * Asks the dataSource for a title for the specific date as a replacement of the day text
 */
- (NSString *)calendar:(HYRCalendarView *)calendar titleForDate:(NSDate *)date;

/**
 * Asks the dataSource for a subtitle for the specific date under the day text.
 */
- (NSString *)calendar:(HYRCalendarView *)calendar subtitleForDate:(NSDate *)date;

@end

/**
 *定义协议
 */
@protocol HYRCalendarViewDataDelegate <NSObject>

@optional

/**
 * Asks the delegate whether the specific date is allowed to be selected by tapping.
 */
- (BOOL)calendar:(HYRCalendarView *)calendar shouldSelectDate:(NSDate *)date;

/**
 * Tells the delegate a date in the calendar is selected by tapping.
 */
- (void)calendar:(HYRCalendarView *)calendar didSelectDate:(NSDate *)date andCurrentItem:(HYRCalendarDateCell *)item;



@end



@interface HYRCalendarView : UIView


@property (nonatomic, strong) UICollectionView *collectionView;

- (instancetype)initWithStyle:(HYRCalendarAppearStyle *)style;

/**
 * The object that acts as the data source of the calendar.
 */
@property (nonatomic, weak)  id<HYRCalendarViewDataSource> dataSource;

/**
 * The object that acts as the data source of the calendar.
 */
@property (nonatomic, weak)  id<HYRCalendarViewDataDelegate> delegate;

@end
