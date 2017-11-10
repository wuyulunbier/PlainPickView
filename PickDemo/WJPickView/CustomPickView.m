
//
//  CustomPickView.m
//  PickDemo
//
//  Created by Apple on 2017/11/7.
//  Copyright © 2017年 Cnadmart. All rights reserved.
//

#import "CustomPickView.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define XZColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]

@interface CustomPickView ()<WJPickViewDelegate>

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *naviContainView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) WJPickView *pickView;

@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) UIView *mainView;

@end

@implementation CustomPickView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.text = title;
    }
    return self;
}
- (void)setupChildViews {
    
    [self addSubview:self.bgBtn];
    [self addSubview:self.mainView];
    
    [self.mainView addSubview:self.naviContainView];
    [self.naviContainView addSubview:self.cancelBtn];
    [self.naviContainView addSubview:self.titleLabel];
    [self.naviContainView addSubview:self.confirmBtn];
    
    [self.mainView addSubview:self.pickView];
    
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.mainView setFrame:CGRectMake(0, kScreenH, kScreenW, 244)];
    
    [self.naviContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.mainView);
        make.height.mas_equalTo(44);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.naviContainView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.naviContainView);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.naviContainView);
    }];
}

#pragma mark - private methods

- (void)cancelAction:(UIButton *)btn {
    [self dismiss];
}

- (void)confirmAction:(UIButton *)btn {
    
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(pickView:confirmButtonClick:)]) {
        [self.delegate pickView:self confirmButtonClick:btn];
    }
}

#pragma mark - public methods

- (void)show {
    self.bgBtn.alpha = 0.4;
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.y = kScreenH - 244;
    }];
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.y = kScreenH;
        self.bgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter methods

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:XZColor(8, 193, 255) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:XZColor(8, 193, 255) forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn sizeToFit];
        
    }
    return _confirmBtn;
}

- (UIView *)naviContainView {
    if (!_naviContainView) {
        _naviContainView = [[UIView alloc] init];
        _naviContainView.backgroundColor = [UIColor whiteColor];
    }
    return _naviContainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"title";
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (WJPickView *)pickView {
    if (!_pickView) {
        _pickView = [[WJPickView alloc] initWithFrame:CGRectMake(0, 44, kScreenW, 200)];
        _pickView.delegate = self;
        [_pickView setUpView];
    }
    return _pickView;
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor blackColor];
        _bgBtn.alpha = 0.3;
        [_bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = XZColor(247, 247, 247);
    }
    return _mainView;
}
#pragma mark - WJPickViewDelegate,

- (int)m_noOfSection
{
    
     return (int)[self.dataSource numberOfComponentsInPickerView:self];
    
}
- (int)m_noOfRowsInSection:(int)section
{
    return (int)[self.dataSource pickerView:self numberOfRowsInComponent:section];
}

#pragma mark --- WJPickViewDelegate
- (CGFloat)m_rowHeight
{
    return [self.delegate heightForRowPickerView:self];
}
- (UIView *)m_viewForRow:(int)row withSection:(int)section
{
    NSString *str = @"";
    if ([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        str = [self.delegate pickerView:self titleForRow:row forComponent:section];
    }else{
       str = @"";
    }
    UILabel *lable = [[UILabel alloc]init];
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = str;
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}

- (void)m_selectRow:(int)row Section:(int)section itemArray:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([item isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)item;
            if (idx == row) {
                lab.textColor = [UIColor redColor];
            }else
            {
                
             lab.textColor = [UIColor blackColor];
            }
        }
    }];
    
    
}

- (UIColor *)m_centerLineColor
{
    if ([self.delegate respondsToSelector:@selector(centerLineColorPickerView:)]) {
        
        return  [self.delegate centerLineColorPickerView:self];
    }else{
         return [UIColor blackColor];
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
     [self.pickView  selectRowWithRow:(int)row inSection:(int)component];
    
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    
   return  [self.pickView selectedRowInComponent:component];
}
@end
