//
//  HYRCalendarDateCell.m
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import "HYRCalendarDateCell.h"
#import "UIColor+HYRExtension.h"

#define animation_Duration 0.25

@interface HYRCalendarDateCell()

@property (nonatomic, strong) UILabel *dateLabel;  //日期的Label
@property (nonatomic, strong) UILabel *descLabel; //描述的Label
@property (nonatomic, assign) CGFloat dateLableHeight;
@property (nonatomic, assign) CGFloat descLabelHeiht;
@end

@implementation HYRCalendarDateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderWidth = .5;
        self.contentView.layer.borderColor = [[UIColor colorWithHexString:@"#F8F8F8" alpha:1.0] CGColor];
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if(self.dateLableHeight > 0)
    {
      
#pragma mark - 如果需要修改日期和会议个数描述的位置就来这里

        //self.dateLabel.frame = CGRectMake(20, 16, width, self.descLabelHeiht);
        
        self.dateLabel.center = CGPointMake(width*0.5, height*0.5 - self.dateLableHeight*0.5-self.style.dateTitleDescOffset.vertical * 0.5);
        self.dateLabel.bounds = CGRectMake(0, 0, width, self.dateLableHeight);
        
    }
    
    if(self.descLabelHeiht > 0)
    {
        //self.descLabel.frame = CGRectMake(32, height*0.5 +self.style.dateTitleDescOffset.vertical * 0.5, width, self.descLabelHeiht);
        
        self.descLabel.center = CGPointMake(width*0.5, height*0.5 + self.descLabelHeiht*0.5+self.style.dateTitleDescOffset.vertical * 0.5);
        self.descLabel.bounds = CGRectMake(0, 0, width, self.descLabelHeiht);
    }
    
}



#pragma mark- API
- (void)setStyle:(HYRCalendarAppearStyle *)style
{
    _style = style;
    self.dateLableHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName : style.dateTittleFont}].height;
    self.descLabelHeiht = [@"1" sizeWithAttributes:@{NSFontAttributeName : style.dateDescFont}].height;
    self.dateLabel.font = style.dateTittleFont;
    self.dateLabel.textColor = self.isSelected?style.dateTittleSelectColor:style.dateTittleUnselectColor;
    self.descLabel.font = style.dateDescFont;
    self.descLabel.textColor = self.isSelected?style.dateDescSelectColor:style.dateDescUnselectColor;
    
}

- (void)reloadCellDataWithTitle:(NSString *)title
{
    self.dateLabel.text = title.length > 0 ? title : @"";
}

- (void)reloadCellDataWithSubtitle:(NSString *)subtitle
{
    self.descLabel.text = subtitle.length > 0 ? subtitle : @"";
}

- (void)reloadCellDataWithTitle :(NSString *)title  subTitle:(NSString *)subtitle
{
    [self reloadCellDataWithTitle:title];
    [self reloadCellDataWithSubtitle:subtitle];
}

- (void)updateCellSelectBackgroundColor
{
    self.contentView.backgroundColor = self.isSelected?self.style.dateBackSelectColor:self.style.dateBackUnselectColor;
}
- (void)updateCellSelectTitleColor
{
    self.dateLabel.textColor = self.isSelected?self.style.dateTittleSelectColor:self.style.dateTittleUnselectColor;
}
- (void)updateCellSelectSubtitleColor
{
    self.descLabel.textColor = self.isSelected?self.style.dateDescSelectColor:self.style.dateDescUnselectColor;
}
- (void)updateCellSelectCellColor
{
    [self updateCellSelectCellColorWithAnimation:NO];
}

- (void)updateCellSelectCellColorWithAnimation:(BOOL)animation
{
    if(animation)
    {
        [self addAnimationToView:self];
    }
    [self updateCellSelectTitleColor];
    [self updateCellSelectSubtitleColor];
    [self updateCellSelectBackgroundColor];
    
}




#pragma mark - handle

- (void)addAnimationToView:(UIView *)animationView
{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values = @[@0.8,@1.0,@1.2,@1.1,@1.0];
    keyAnimation.duration = animation_Duration;
    [animationView.layer addAnimation:keyAnimation forKey:@"scale"];
}
- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date
{
    NSDateComponents *component = [[NSCalendar currentCalendar] components:
                                   (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return component;
}

#pragma mark - lazy 懒加载
#pragma mark - 某天日期的Label
- (UILabel *)dateLabel
{
    if(_dateLabel == nil)
    {
        _dateLabel = [UILabel new];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        //_dateLabel.backgroundColor = [UIColor cyanColor];
    }
    return _dateLabel;
}

#pragma mark - 描述的Label 主要显示有多少个会议
- (UILabel *)descLabel
{
    if(_descLabel == nil)
    {
        _descLabel = [UILabel new];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

@end
