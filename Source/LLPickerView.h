//
//  SLPickerView.h
//  SLPickerView
//
//  Created by LvJianfeng on 2016/11/8.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CancelActionBlock)();
typedef void (^ConfirmActionBlock)(NSInteger row, id object);

@interface LLPickerView : UIView
// 参数
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *leftTitle;
@property (strong, nonatomic) NSString *rightTitle;

@property (strong, nonatomic) UIColor  *titleColor;
@property (strong, nonatomic, getter=leftTitleColor) UIColor  *leftTitleColor;
@property (strong, nonatomic) UIColor  *rightTitleColor;

// 标题
@property (weak, nonatomic)   UILabel *titleLabel;

// 开启标题根据选择内容变动
@property (assign, nonatomic,getter=canAllow) BOOL isAllow;

// 选择数据源
@property (strong, nonatomic) NSMutableArray *pickerData;
// 回调
@property (strong, nonatomic) CancelActionBlock cancelBlock;
@property (strong, nonatomic) ConfirmActionBlock confirmBlock;

- (instancetype)initWithData:(NSArray *)data;
- (instancetype)initWithData:(NSArray *)data title:(NSString *)title leftTitle:(NSString *)lTitle rightTitle:(NSString *)rTitle;
+ (void)dismissPickerView;
@end

@interface UIView (SLPFrame)

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat maxY;

@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat maxX;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@end

