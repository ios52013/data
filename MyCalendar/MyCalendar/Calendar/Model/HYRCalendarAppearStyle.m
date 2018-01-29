//
//  HYRCalendarAppearStyle.m
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import "HYRCalendarAppearStyle.h"
#import "UIColor+HYRExtension.h"


@implementation HYRCalendarAppearStyle


/**
 模型的初始化方法
 @return 初始化好的模型
 */
- (instancetype)init {
    if(self = [super init]){
        self.isNeedCustomHeihgt = YES;
        self.today = [NSDate date];
        
        //顶部显示年月日期的视图高度
        self.headerViewDateHeight = 100;
        self.headerViewLineHeight = 1.0;
        //星期几 的视图高度
        self.headerViewWeekHeight = 60;
        self.weekDateDays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
        self.headerViewDateFont = [UIFont systemFontOfSize:30.0];
        self.headerViewWeekFont = [UIFont systemFontOfSize:14.0];
        //星期几的字体颜色
        self.headerViewWeekColor =  [UIColor colorWithHexString:@"#666666" alpha:1.0];
        //顶部年月的字体颜色
        self.headerViewDateColor =  [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];;
        
        self.itemHeight = 0;
        //某天日期的字体大小
        self.dateTittleFont = [UIFont systemFontOfSize:20.0];
        //描述有多少个会议的字体大小
        self.dateDescFont = [UIFont systemFontOfSize:14.0];
        
        self.dateTittleSelectColor = [UIColor colorWithHexString:@"#FF6B32" alpha:1.0];
        self.dateTittleUnselectColor = [UIColor colorWithHexString:@"#666666" alpha:1.0];
        self.dateDescSelectColor = [UIColor colorWithHexString:@"#FF6B32" alpha:1.0];
        self.dateDescUnselectColor = [UIColor purpleColor];
        //没有会议的日期背景颜色
        self.dateBackUnselectColor = [UIColor whiteColor];
        //有会议的日期背景颜色
        self.dateBackSelectColor = [UIColor colorWithHexString:@"#FF6B32" alpha:.1];
        
        self.isSupportMoreSelect = NO;
        self.dateTitleDescOffset = UIOffsetMake(0, 10);
        
    }
    return self;
}


/**
 @return   日历头部的高度：
 */
- (CGFloat)headerViewHeihgt {
    return self.headerViewDateHeight + self.headerViewLineHeight + self.headerViewWeekHeight;
}


@end
