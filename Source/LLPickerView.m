//
//  SLPickerView.m
//  SLPickerView
//
//  Created by LvJianfeng on 2016/11/8.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import "LLPickerView.h"
#define SLP_ColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SLP_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SLP_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SLP_LineColor SLP_ColorWithRGB(0xd4d4d4)
#define SLP_IsNullString(X)  (X==nil || X==(NSString *)[NSNull null] || [X length]==0)

@interface LLPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSInteger _row;
}
@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton *windowView;
@end

@implementation LLPickerView


/**
 初始化组装数据
 
 @param data    PickerView数据源
 @return self
 */
- (instancetype)initWithData:(NSArray *)data{
    self = [super initWithFrame:CGRectMake(0, 0, SLP_SCREEN_WIDTH, SLP_SCREEN_HEIGHT)];
    if (self) {
        self.pickerData = [NSMutableArray arrayWithArray:data];
        
        self.title = nil;
        self.leftTitle = nil;
        self.rightTitle = nil;
        
        [self popPickerView];
    }
    return self;
}

/**
 初始化组装数据

 @param data    PickerView数据源
 @param title   顶部显示标题
 @param lTitle  左边按钮标题
 @param rTitle  右边按钮标题
 @return self
 */
- (instancetype)initWithData:(NSArray *)data title:(NSString *)title leftTitle:(NSString *)lTitle rightTitle:(NSString *)rTitle{
    self = [super initWithFrame:CGRectMake(0, 0, SLP_SCREEN_WIDTH, SLP_SCREEN_HEIGHT)];
    if (self) {
        self.pickerData = [NSMutableArray arrayWithArray:data];
        
        self.title = title;
        self.leftTitle = lTitle;
        self.rightTitle = rTitle;
        
        [self popPickerView];
    }
    return self;
}


/**
 *  渲染布局
 */
- (void)popPickerView{
    if (self.windowView) {
        return;
    }
    // 索引
    _row = 0;
    // 背景
    self.windowView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SLP_SCREEN_WIDTH, SLP_SCREEN_HEIGHT)];
    self.windowView.backgroundColor = [SLP_ColorWithRGB(0x000000) colorWithAlphaComponent:0.4];
    [self.windowView addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.windowView];
    // 选择控制器高度
    CGFloat height = 200;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, SLP_SCREEN_HEIGHT, SLP_SCREEN_WIDTH, height)];
    containerView.backgroundColor = SLP_ColorWithRGB(0xffffff);
    [self.windowView addSubview:containerView];
    self.containerView = containerView;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SLP_SCREEN_WIDTH, (1.0 / [UIScreen mainScreen].scale))];
    line.backgroundColor = SLP_LineColor;
    [containerView addSubview:line];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, line.maxY, 80, 45)];
    [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:self.leftTitleColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelBtn addTarget:self action:@selector(tapCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cancelBtn.maxX, 0, SLP_SCREEN_WIDTH - 160, 45)];
    titleLabel.textColor = SLP_ColorWithRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.text = self.title;
    [containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SLP_SCREEN_WIDTH - 80, line.maxY, 80, 45)];
    [confirmBtn setTitle:self.rightTitle forState:UIControlStateNormal];
    [confirmBtn setTitleColor:SLP_ColorWithRGB(0x333333) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [confirmBtn addTarget:self action:@selector(tapConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:confirmBtn];
    
    UIView *pickerTLine = [[UIView alloc] initWithFrame:CGRectMake(0, confirmBtn.maxY, SLP_SCREEN_WIDTH, (1.0 / [UIScreen mainScreen].scale))];
    pickerTLine.backgroundColor = SLP_LineColor;
    [containerView addSubview:pickerTLine];
    
    UIImageView *jstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLP_SCREEN_WIDTH*0.5-4, pickerTLine.maxY+12, 8, 7)];
    jstImageView.image = [UIImage imageNamed:@"jts"];
    [containerView addSubview:jstImageView];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, jstImageView.centerY, SLP_SCREEN_WIDTH,130)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [containerView addSubview:pickerView];
    self.pickerView = pickerView;
    
    UIImageView *jsxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLP_SCREEN_WIDTH*0.5-4, pickerView.maxY-7, 8, 7)];
    jsxImageView.image = [UIImage imageNamed:@"jtx"];
    [containerView addSubview:jsxImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.containerView.frame;
        frame.origin.y -= frame.size.height;
        [self.containerView setFrame:frame];
    } completion:^(BOOL finished) {
    }];
}


/**
 *  确认
 */
- (void)tapConfirmAction{
    if (self.confirmBlcok) {
        self.confirmBlcok(_row, self.pickerData[_row]);
    }
    [self dismissPickerView];
}

/**
 *  取消或新建
 */
- (void)tapCancelAction{
    if (self.cancelBlcok) {
        self.cancelBlcok();
    }
    [self dismissPickerView];
}

/**
 *  关闭
 */
+ (void)dismissPickerView{
    [self dismissPickerView];
}
- (void)dismissPickerView{
    if (self.windowView) {
        // 回调
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.containerView.frame;
            frame.origin.y += frame.size.height;
            [self.containerView setFrame:frame];
            self.windowView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.windowView removeFromSuperview];
            self.windowView = nil;
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerData.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView *pickerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SLP_SCREEN_WIDTH, 35.f)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:pickerV.bounds];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = SLP_ColorWithRGB(0xe12000);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.pickerData[row];
    [pickerV addSubview:titleLabel];
    return pickerV;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35.f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _row = row;
    // 如果允许则所选行数据将显示在标题上，且只能为字符串类型
    if (self.isAllow) {
        if ([self.pickerData[_row] isKindOfClass:[NSString class]]) {
            self.titleLabel.text = self.pickerData[_row];
        }
    }
}

#pragma mark getter/setter
- (void)setTitle:(NSString *)title{
    if (title && title.length>0) {
        _title = title;
    }else{
        _title = @" ";
    }
}

- (void)setLeftTitle:(NSString *)leftTitle{
    if (leftTitle && leftTitle>0) {
        _leftTitle = leftTitle;
        _leftTitleColor = SLP_ColorWithRGB(0xff8400);
    }else{
        _leftTitle = @"取消";
        _leftTitleColor = SLP_ColorWithRGB(0x333333);
    }
}

- (void)setRightTitle:(NSString *)rightTitle{
    if (rightTitle && rightTitle.length>0) {
        _rightTitle = rightTitle;
    }else{
        _rightTitle = @"确定";
    }
}

- (UIColor *)leftTitleColor{
    if (_leftTitleColor) {
        return _leftTitleColor;
    }
    return SLP_ColorWithRGB(0x333333);
}

- (BOOL)canAllow{
    if (_isAllow) {
        return _isAllow;
    }
    return NO;
}
@end



/**
 *  frame
 */
@implementation UIView (SLPFrame)
#pragma mark - Shortcuts for the coords

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
}

#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)minY{
    return self.centerY-self.height*0.5;
}

- (CGFloat)maxY{
    return self.centerY+self.height*0.5;
}

- (CGFloat)minX{
    return self.centerX-self.width*0.5;
}

- (CGFloat)maxX{
    return self.centerX+self.width*0.5;
}

@end
