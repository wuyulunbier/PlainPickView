//
//  CustomPickView.h
//  PickDemo
//
//  Created by Apple on 2017/11/7.
//  Copyright © 2017年 Cnadmart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPickView.h"
@class CustomPickView;

@protocol CustomPickViewDataSource <NSObject>

@required
 
- (NSInteger)numberOfComponentsInPickerView:(CustomPickView *)pickerView;

- (NSInteger)pickerView:(CustomPickView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end


@protocol CustomPickViewDelegate <NSObject>

- (void)pickView:(CustomPickView *)pickerView confirmButtonClick:(UIButton *)button;
- (NSString *)pickerView:(CustomPickView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (CGFloat)heightForRowPickerView:(CustomPickView *)pickView;
@optional

- (UIColor *)centerLineColorPickerView:(CustomPickView *)pickerView;

//- (NSAttributedString *)pickerView:(CustomPickView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)componen;

- (void)pickerView:(CustomPickView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


@interface CustomPickView : UIView

@property (nonatomic, weak) id<CustomPickViewDelegate> delegate;
@property (nonatomic, weak) id<CustomPickViewDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)show;

- (void)dismiss;

- (void)setupChildViews;
// 选中某一行
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
// 获取当前选中的row
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end
