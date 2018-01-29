//
//  HYRCalendarDateCell.h
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//
/**
 *
 *该类主要是控制日历中的每一天的视图样式
 *
 **/

#import <UIKit/UIKit.h>
#import "HYRCalendarAppearStyle.h"


@interface HYRCalendarDateCell : UICollectionViewCell

@property (nonatomic, strong) HYRCalendarAppearStyle *style;

- (void)reloadCellDataWithTitle:(NSString *)title;
- (void)reloadCellDataWithSubtitle:(NSString *)subtitle;
- (void)reloadCellDataWithTitle :(NSString *)title  subTitle:(NSString *)subtitle;
//选中颜色
- (void)updateCellSelectBackgroundColor;
- (void)updateCellSelectTitleColor;
- (void)updateCellSelectSubtitleColor;
- (void)updateCellSelectCellColor;
- (void)updateCellSelectCellColorWithAnimation:(BOOL)animation;
@end
