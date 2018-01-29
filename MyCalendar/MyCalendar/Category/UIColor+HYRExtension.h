//
//  UIColor+HYRExtension.h
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/27.
//  Copyright © 2018年 黄永锐. All rights reserved.
//
/**
 *关于颜色UIColor的扩展
 */

#import <UIKit/UIKit.h>

@interface UIColor (HYRExtension)


/**
 根据十六进制字符串获取相应的颜色

 @param color 十六进制的字符串(支持@“#123456”、 @“0X123456”、 @“123456”三种格式)
 @param alpha 透明度
 @return 颜色UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
