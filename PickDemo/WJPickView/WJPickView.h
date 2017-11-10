//
//  WJPickView.h
//  PickDemo
//
//  Created by Apple on 2017/11/6.
//  Copyright © 2017年 Cnadmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJPickViewDelegate <NSObject>
/// 返回pickerview的列数
///
/// - Returns: 列数
- (int)m_noOfSection;
/// 每一列的行数
///
/// - Parameter section: 列
/// - Returns: 行数
- (int)m_noOfRowsInSection:(int)section;
/// 行高
///
/// - Returns: 行高

- (CGFloat)m_rowHeight;
// 类似于tableView的cellForRow,返回每一行显示的view
///
/// - Parameters:
///   - row: view所在行
///   - inSection: view所在列
/// - Returns: UIView

-(UIView *)m_viewForRow:(int)row withSection:(int)section;
/// 中间分割线颜色
///
/// - Returns: UIColor
- (UIColor *)m_centerLineColor;

/// 选中行回调
///
/// - Parameters:
///   - row: 被选中的行
///   - section: 被选中的列
///   - itemArray: 被选中的[view]
-(void)m_selectRow:(int)row Section:(int)section itemArray:(NSArray *)array;

@end

@interface WJPickView : UIView


@property (weak,nonatomic) id <WJPickViewDelegate> delegate;
- (WJPickView *)myPickViewInitWithFrame:(CGRect)frame;
- (void)setUpView;
- (void)selectRowWithRow:(int)row inSection:(int)section;
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end
