//
//  ViewController.m
//  LLVideoDemo
//
//  Created by LvJianfeng on 2016/11/8.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import "ViewController.h"
#import "LLPickerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 点击弹出(双按钮样式)
- (IBAction)style1:(id)sender {
    LLPickerView *pickerView = [[LLPickerView alloc] initWithData:@[@"前天",@"昨天",@"今天"]];
    pickerView.confirmBlock = ^(NSInteger row, id object){
        NSLog(@"%ld--%@",row,object);
    };
    [self.view addSubview:pickerView];
}

// 点击弹出(其他按钮样式)
- (IBAction)style2:(id)sender {
    LLPickerView *pickerView = [[LLPickerView alloc] initWithData:@[@"前天",@"昨天",@"今天"] title:nil leftTitle:@"新建信息" rightTitle:@"确认"];
    pickerView.confirmBlock = ^(NSInteger row, id object){
        NSLog(@"%ld--%@",row,object);
    };
    pickerView.cancelBlock = ^{
        NSLog(@"新建");
    };
    [self.view addSubview:pickerView];
}

// 点击弹出(无标题)
- (IBAction)style3:(id)sender {
    LLPickerView *pickerView = [[LLPickerView alloc] initWithData:@[@"疾风剑豪卡",@"剑魔"] title:nil leftTitle:@"新建" rightTitle:@"确认"];
    pickerView.confirmBlock = ^(NSInteger row, id object){
        NSLog(@"%ld--%@",row,object);
    };
    pickerView.cancelBlcok = ^{
        NSLog(@"新建");
    };
    [self.view addSubview:pickerView];
}

// 点击弹出(有标题)
- (IBAction)style4:(id)sender {
    LLPickerView *pickerView = [[LLPickerView alloc] initWithData:@[@"疾风剑豪哇塞卡疾风剑豪哇塞卡",@"剑魔剑魔剑魔剑魔剑魔剑魔"] title:@"选择" leftTitle:nil rightTitle:@"确认"];
    pickerView.confirmBlock = ^(NSInteger row, id object){
        NSLog(@"%ld--%@",row,object);
    };
    pickerView.cancelBlock = ^{
        NSLog(@"新建");
    };
    [self.view addSubview:pickerView];
}

// 点击弹出(变换标题)
- (IBAction)style5:(id)sender {
    LLPickerView *pickerView = [[LLPickerView alloc] initWithData:@[@"疾风剑豪哇塞卡疾风剑豪哇塞卡",@"剑魔剑魔剑魔剑魔剑魔剑魔"] title:@"选择" leftTitle:@"新建" rightTitle:@"确认"];
    pickerView.isAllow = YES;
    
    pickerView.confirmBlock = ^(NSInteger row, id object){
        NSLog(@"%ld--%@",row,object);
    };
    pickerView.cancelBlock = ^{
        NSLog(@"新建");
    };
    [self.view addSubview:pickerView];
}

@end
