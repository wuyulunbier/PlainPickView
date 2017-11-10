//
//  ViewController.m
//  PickDemo
//
//  Created by Apple on 2017/11/4.
//  Copyright © 2017年 Cnadmart. All rights reserved.
//

#import "ViewController.h"
#import "WJPickView.h"
#import "CustomPickView.h"

#define kScreenBounds [UIScreen mainScreen].bounds
#define rowHeight 40

@interface ViewController()<CustomPickViewDelegate,CustomPickViewDataSource>

@property (nonatomic,strong) CustomPickView * pickView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *titleLab;

@end

@implementation ViewController
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, 200, 30)];
        _titleLab.textColor = [UIColor blackColor];
        [self.view addSubview:_titleLab];
    }
    return _titleLab;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self createData];

}

- (void)createData
{
    for (int a=1; a<100; a++) {
        NSString *string = [NSString stringWithFormat:@"%d 元",a];
        [self.dataArray addObject:string];
    }
    [self.dataArray insertObject:@"不加了" atIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [[UIApplication sharedApplication].keyWindow addSubview:self.pickView];
    [self.pickView show];

}
- (CustomPickView *)pickView
{
    if (!_pickView) {
        _pickView = [[CustomPickView alloc]initWithFrame:kScreenBounds title:@"选择小费金额"];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [_pickView setupChildViews];
    }
    return _pickView;
}

#pragma mark -----  CustomPickViewDelegate
- (void)pickView:(CustomPickView *)pickerView confirmButtonClick:(UIButton *)button
{
    NSInteger left = [pickerView selectedRowInComponent:0];
    self.titleLab.text = left==0?@"不想打赏了":[NSString stringWithFormat:@"我打赏了%@小费",[self.dataArray objectAtIndex:left]];
}

- (NSInteger)numberOfComponentsInPickerView:(CustomPickView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(CustomPickView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (CGFloat)heightForRowPickerView:(CustomPickView *)pickView
{
    return rowHeight;
}

- (NSString *)pickerView:(CustomPickView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataArray[row];
    
}

- (UIColor *)centerLineColorPickerView:(CustomPickView *)pickerView
{
    return [UIColor blackColor];
}
- (void)pickerView:(CustomPickView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     //选中了某一行
}
@end

