//
//  UIImage+HYRComponent.h
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYRComponent)

/**
 *    @brief    通过imageName和type获取图片
 *
 *    @param     imageName     图片文件的名字
 *    @param     type     图片文件的后缀名
 *
 *    @return    获取的图片独享
 */
+ (UIImage *)imageForName:(NSString *)imageName type:(NSString *)type;

/**
 *    @brief    通过bundleName获取当前工程中资源路径下名称为imageName图片
 *
 *    @param     imageName     图片名称
 *    @param     bundleName     包名称
 *
 *    @return    图片对象
 */
+ (UIImage *)imageNamed:(NSString *)imageName bundle:(NSString *)bundleName;

/**
 *    @brief    重新设置图片大小
 *
 *    @param     image     重置大小的图片对象
 *    @param     reSize     新的尺寸
 *
 *    @return    新尺寸的图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
@end
