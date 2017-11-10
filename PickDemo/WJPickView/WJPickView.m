

//
//  WJPickView.m
//  PickDemo
//
//  Created by Apple on 2017/11/6.
//  Copyright © 2017年 Cnadmart. All rights reserved.
//

#import "WJPickView.h"
#import "UIView+Extension.h"

@interface WJPickView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSMutableArray *scrollViewArray;
@property (nonatomic,strong) NSMutableArray *itemViewArray;
@property (nonatomic,assign) CGFloat    rowHeight;

@end

@implementation WJPickView

- (UIScrollView *)scrollView
{
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.height = self.height;
        int sectionNo = [self.delegate m_noOfSection];
        _scrollView.width = self.width/(CGFloat)sectionNo;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
        [_scrollView addGestureRecognizer:tapGes];
        _scrollView.decelerationRate = 0.8;
         return _scrollView;
}

- (UIView *)lineView
{
        _lineView =[[UIView alloc]initWithFrame:self.bounds];
        _lineView.height = self.rowHeight;
        _lineView.centerY = self.height/2;
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width,0.3)];
        topline.userInteractionEnabled = NO;
        topline.alpha = 0.4;
        topline.backgroundColor = [UIColor lightGrayColor];
        [_lineView addSubview:topline];
    
        UIView *bottonline = [[UIView alloc]initWithFrame:CGRectMake(0,_lineView.height, self.width, 0.3)];
        bottonline.alpha = 0.4;
        bottonline.userInteractionEnabled = NO;
        bottonline.backgroundColor =[UIColor lightGrayColor];
        [_lineView addSubview:bottonline];
        _lineView.userInteractionEnabled = NO;

    return _lineView;
}

- (NSMutableArray *)scrollViewArray
{
    if (_scrollView == nil) {
        
    }
    return _scrollViewArray;
}

- (NSMutableArray *)itemViewArray
{
    if (_itemViewArray == nil) {
        _itemViewArray = [[NSMutableArray alloc]init];
    }
    return _itemViewArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       _scrollViewArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)tapScrollView:(UITapGestureRecognizer *)tapGes
{
    UIScrollView *scrollView = (UIScrollView *)tapGes.view;
    NSInteger section = [self.scrollViewArray indexOfObject:scrollView];
    CGPoint tapPoint = [tapGes locationInView:scrollView];
    NSArray *itemsArray = self.itemViewArray[section];
    [itemsArray enumerateObjectsUsingBlock:^(UILabel *item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.userInteractionEnabled = YES;
        if (CGRectContainsPoint(item.frame, tapPoint) == YES) {
            [self selectRowWithRow:(int)idx inSection:(int)section];
        }
    }];
}
- (WJPickView *)myPickViewInitWithFrame:(CGRect)frame
{
    WJPickView *pickView = [[WJPickView alloc]initWithFrame:frame];
    [pickView setUpView];
    return pickView;
}

- (void)setUpView
{
    self.rowHeight = [self.delegate m_rowHeight];
    int sectionNo = [self.delegate m_noOfSection];
    CGFloat sectionWidth = self.width/(CGFloat)sectionNo;
    int addRows= (int)self.height/self.rowHeight-1;
    for (int section=0; section<sectionNo; section++) {
        UIScrollView *scrollView = [self scrollView];
        scrollView.x =(CGFloat)section*sectionWidth;
        int rows = [self.delegate m_noOfRowsInSection:section];
        CGFloat contentH = self.rowHeight*(CGFloat)(addRows+rows);
        scrollView.contentSize = CGSizeMake(0, contentH);
        
        NSMutableArray *itemArray = [[NSMutableArray alloc]init];
        for (int row =0; row<rows; row++) {
            UIView *itemView = [self.delegate m_viewForRow:row withSection:section];
            itemView.width = sectionWidth;
            itemView.height = self.rowHeight;
            itemView.y =(CGFloat)(row + addRows/2)*self.rowHeight;
            [scrollView addSubview:itemView];
            [itemArray addObject:itemView];
        }
        [self.itemViewArray addObject:itemArray];
        [self.scrollViewArray addObject:scrollView];
        [self addSubview:scrollView];
    }
    [self addSubview:self.lineView];
}
#pragma mark --------UIScrollViewDelegate -------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self fitContentOffSet:scrollView];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO ) {
        [self fitContentOffSet:scrollView];
    }
}
//MARK: function
- (void)fitContentOffSet:(UIScrollView *)scollView
{
    CGFloat contentOffSetY = scollView.contentOffset.y;
    int scrollToRow = (int)contentOffSetY/(int)self.rowHeight;
    int moreMove = (int)contentOffSetY%(int)self.rowHeight;
    if (moreMove>(int)self.rowHeight/2) {
        scrollToRow +=1;
        }
    NSInteger section = [self.scrollViewArray indexOfObject:scollView];
    [self selectRowWithRow:scrollToRow inSection:section];
    [self selectedRowInComponent:section];
}

- (void)selectRowWithRow:(int)row inSection:(int)section
{
    UIScrollView *scrollView = self.scrollViewArray[section];
    [scrollView setContentOffset:CGPointMake(0, (CGFloat)row * self.rowHeight) animated:YES];
    [self.delegate m_selectRow:row Section:section itemArray:self.itemViewArray[section]];
}
- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    UIScrollView *scrollView = self.scrollViewArray[component];
    CGFloat contentOffSetY = scrollView.contentOffset.y;
    int scrollToRow = (int)contentOffSetY/(int)self.rowHeight;
    return scrollToRow;
}
@end
