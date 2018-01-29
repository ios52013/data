//
//  NSDate+HYRComponent.h
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HYRComponent)

/**
 Get the  date of day
 @return day
 */
- (NSInteger)getDateWithDay;

/**
 Get the  date of month
 @return month
 */
- (NSInteger)getDateWithMonth;

/**
 Get the  date of year
 @return year
 */
- (NSInteger)getDateWithYear;
@end
