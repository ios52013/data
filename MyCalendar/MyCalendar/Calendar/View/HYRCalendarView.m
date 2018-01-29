//
//  HYRCalendarView.m
//  PACM_ipad
//
//  Created by 黄永锐 on 2018/1/26.
//  Copyright © 2018年 黄永锐. All rights reserved.
//

#import "HYRCalendarView.h"
#import "HYRCalendarHeaderView.h"



#define limitation_Low  28
#define limitation_Medium  35
#define limitation_High  42

#define kCollectionW self.bounds.size.width/1024.0
#define kCollectionH self.bounds.size.height/768.0

static NSString *HYRCalendarDateCellID = @"HYRCalendarDateCellID";

@interface HYRCalendarView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) HYRCalendarAppearStyle *style;
@property (nonatomic, strong) HYRCalendarHeaderView *headerView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectFlowLayout;
@property (nonatomic, strong) HYRCalendarDateCell *currentSelctCell;
@end


@implementation HYRCalendarView

- (instancetype)initWithStyle:(HYRCalendarAppearStyle *)style {
    if(self = [super init]) {
        self.style = style;
        [self setupUI];
    }
    return self;
}


/**
 初始化UI界面
 */
- (void)setupUI {
    __weak typeof(self) weakSelf = self;
    [self addSubview:self.headerView];
    self.headerView.monthDate = self.style.today;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    //注册cell
    [self.collectionView registerClass:[HYRCalendarDateCell class] forCellWithReuseIdentifier:HYRCalendarDateCellID];
    
    //处理
    [self.headerView setPreviousMonthClick:^(NSDate *date) {
        weakSelf.style.today = date;
        [weakSelf setNeedsLayout];
        [weakSelf.collectionView reloadData];
    }];
    
    [self.headerView setNextMonthClick:^(NSDate *date) {
        weakSelf.style.today = date;
        [weakSelf setNeedsLayout];
        [weakSelf.collectionView reloadData];
    }];
    
#pragma mark -添加手势左右滑动加载上下个月的日历
    //创建滑动手势
    UISwipeGestureRecognizer *LeftSwipeGestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    UISwipeGestureRecognizer *RightSwipeGestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    //设置方向
    LeftSwipeGestureR.direction = UISwipeGestureRecognizerDirectionLeft;
    RightSwipeGestureR.direction = UISwipeGestureRecognizerDirectionRight;
    //添加手势
    [self.collectionView addGestureRecognizer:LeftSwipeGestureR];
    [self.collectionView addGestureRecognizer:RightSwipeGestureR];
}

/******************手势控制操作*****************/

#pragma mark - 滑动事件 控制上下个月的日程显示

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    //向左滑动 查看下个月的日程
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        //NSLog(@"锐哥真帅");
        [self.headerView nextButtonClick];
    }else{
        //NSLog(@"做人要诚实你要说真话哦");
        [self.headerView previousButtonClick];
    }
}


#pragma mark - 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    self.headerView.frame = CGRectMake(0, 0, width, self.style.headerViewHeihgt);//
    [self layoutCollectionView];
    
}

- (void)layoutCollectionView {
    
    NSLog(@"-----%lf---%ld",self.bounds.size.width,self.style.weekDateDays.count);
    CGFloat itemWidth = 146 * kCollectionW;//((self.bounds.size.width - 40)/self.style.weekDateDays.count)
    CGFloat itemHeight = 94 * kCollectionH;
    
    if(self.style.isNeedCustomHeihgt && self.style.itemHeight > 0)
    {
        itemHeight = self.style.itemHeight;
    }
    else
    {
        //itemHeight = 94;//itemWidth;
    }
    self.itemHeight = itemHeight;
    self.collectFlowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //collectinView高度
    NSInteger marginDays = [self firstDayInFirstWeekThisMonth:self.style.today];
    NSInteger itemCount = marginDays + [self totalDaysThisMonth:self.style.today];
    CGFloat collectionViewHeight = 0;
    
    if(itemCount <= limitation_Low)
        collectionViewHeight = limitation_Low/self.style.weekDateDays.count *self.itemHeight;
    else if(itemCount > limitation_Low && itemCount <=limitation_Medium)
        collectionViewHeight = limitation_Medium/self.style.weekDateDays.count *self.itemHeight;
    else
        collectionViewHeight = limitation_High/self.style.weekDateDays.count *self.itemHeight;
    
    self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, collectionViewHeight);
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.bounds.size.width, collectionViewHeight);
    [self.collectionView setCollectionViewLayout:self.collectFlowLayout];
    
#warning TODO - 这一行其实不起作用了
    [self callBackHeight:collectionViewHeight+self.style.headerViewHeihgt];
}


#pragma mark - collectCell-dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        NSInteger marginDays = [self firstDayInFirstWeekThisMonth:self.style.today];
        NSInteger itemCount = marginDays + [self totalDaysThisMonth:self.style.today];
        if(itemCount>=limitation_High) return 0;
        
        if(itemCount >limitation_Medium && itemCount<=limitation_High)
            return limitation_High;
        else if(itemCount >limitation_Low && itemCount <=limitation_Medium)
            return limitation_Medium;
        else
            return limitation_Low;
        
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYRCalendarDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HYRCalendarDateCellID forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor cyanColor];
    cell.selected = NO;
    [cell  updateCellSelectCellColor];
    cell.style = self.style;
    NSInteger marginDays = [self firstDayInFirstWeekThisMonth:self.style.today];
    NSInteger daysThisMonth = [self totalDaysThisMonth:self.style.today];
    
    //空白cell
    if(indexPath.row < marginDays)
        [cell reloadCellDataWithTitle:@"" subTitle:@""];
    else if(indexPath.row > marginDays + daysThisMonth - 1)
        [cell reloadCellDataWithTitle:@"" subTitle:@""];
    else
    {
        NSInteger day = 0;
        day = indexPath.row - marginDays +1;
        NSDate *date = [self dateByday:day toDate:self.style.today];
        if([self titleForDate:date].length > 0)
            [cell reloadCellDataWithTitle:[self titleForDate:date]];
        else
            [cell reloadCellDataWithTitle:[NSString stringWithFormat:@"%ld",day]];
        
        if([self subtitleForDate:date].length > 0)
            [cell reloadCellDataWithSubtitle:[self subtitleForDate:date]];
        else
            [cell reloadCellDataWithSubtitle:@""];
        
    }
    
    
    return cell;
}




#pragma mark -- collectCell- Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger marginDays = [self firstDayInFirstWeekThisMonth:self.style.today];
    NSInteger daysThisMonth = [self totalDaysThisMonth:self.style.today];
    if(indexPath.row >=marginDays && indexPath.row <=marginDays + daysThisMonth - 1)
    {
        NSInteger day = 0;
        day = indexPath.row - marginDays +1;
        NSDate *date = [self dateByday:day toDate:self.style.today];
        return [self shouldSelectDate:date];
    }
    else
        return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSInteger marginDays = [self firstDayInFirstWeekThisMonth:self.style.today];
    NSInteger daysThisMonth = [self totalDaysThisMonth:self.style.today];
    if(indexPath.row >=marginDays && indexPath.row <=marginDays + daysThisMonth - 1)
    {
        NSInteger day = 0;
        day = indexPath.row - marginDays +1;
        NSDate *date = [self dateByday:day toDate:self.style.today];
        
        HYRCalendarDateCell *cell = (HYRCalendarDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(self.style.isSupportMoreSelect)
        {
            [self didSelectDate:date andCurrentItem:cell];
            [cell updateCellSelectCellColor];
        }
        else
        {
            if([self.currentSelctCell isEqual:cell])
                return;
            self.currentSelctCell.selected = NO;
            [self.currentSelctCell  updateCellSelectCellColor];
            cell.selected = YES;
            self.currentSelctCell = cell;
            [self didSelectDate:date andCurrentItem:cell];
            [cell updateCellSelectCellColorWithAnimation:YES];
            
            
        }
    }
    else
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
}


#pragma mark- private
- (NSInteger)totalDaysThisMonth:(NSDate *)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

- (NSInteger)firstDayInFirstWeekThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comp.day = 1;
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday-1;
}

- (NSDate *)dateByday:(NSInteger)day toDate:(NSDate *)date {
    if (!date) return nil;
    NSDateComponents *oldCompoents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSDateComponents *newComponents = [[NSDateComponents alloc]init];
    newComponents.day = day;
    newComponents.year = oldCompoents.year;
    newComponents.month = oldCompoents.month;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *d = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",newComponents.year,newComponents.month,newComponents.day]];
    return d;
}

#pragma mark - DataSource

- (NSString *)titleForDate:(NSDate *)date {
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:titleForDate:)]) {
        return [_dataSource calendar:self titleForDate:date];
    }
    return nil;
}

- (NSString *)subtitleForDate:(NSDate *)date {
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:subtitleForDate:)]) {
        return [_dataSource calendar:self subtitleForDate:date];
    }
    return nil;
}

- (void)callBackHeight:(CGFloat)height {
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:layoutCallBackHeight:)]) {
        [_dataSource calendar:self layoutCallBackHeight:height];
    }
}
#pragma mark - Delegate

- (BOOL)shouldSelectDate:(NSDate *)date{
    if (_delegate && [_delegate respondsToSelector:@selector(calendar:shouldSelectDate:)]) {
        return [_delegate calendar:self shouldSelectDate:date];
    }
    return YES;
}

- (void)didSelectDate:(NSDate *)date andCurrentItem:(HYRCalendarDateCell *)item {
    if (_delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDate:andCurrentItem:)]) {
        [_delegate calendar:self didSelectDate:date andCurrentItem:item];
    }
}




#pragma mark - lazy
- (HYRCalendarHeaderView *)headerView {
    if(_headerView == nil) {
        _headerView = [[HYRCalendarHeaderView alloc]initWithType:LZBCalendarHeaderViewType_CenterDate style:self.style];
    }
    return _headerView;
}

- (UIView *)contentView {
    if(_contentView == nil) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}

#pragma mark - 整个UICollectionView
- (UICollectionView *)collectionView {
    if(_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:self.collectFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectFlowLayout {
    if(_collectFlowLayout == nil) {
        _collectFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectFlowLayout.minimumLineSpacing = 0.0;
        _collectFlowLayout.minimumInteritemSpacing = 0.0;
        _collectFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //
        //_collectFlowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40)/self.style.weekDateDays.count, ([UIScreen mainScreen].bounds.size.height-self.style.headerViewHeihgt)/5);
    }
    return _collectFlowLayout;
}

#pragma mark - 定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%s",__func__);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%s",__func__);
}
@end
