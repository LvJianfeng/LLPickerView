# LLPickerView 选择器
如果需要swift版的，可以issues一下。

## 演示
![](https://github.com/LvJianfeng/LLPickerView/blob/master/Demo.gif "") 

## 多种样式可以控制，风格可以修改
### 使用示例

点击弹出(变换标题)

    LLPickerView *pickerView = [[LLPickerView alloc] initWithData:@[@"疾风剑豪哇塞卡疾风剑豪哇塞卡",@"剑魔剑魔剑魔剑魔剑魔剑魔"] title:@"选择"    leftTitle:@"新建" rightTitle:@"确认"];
    // 控制标题是否为当前选择数据
    pickerView.isAllow = YES;
    // 确认的回调
    pickerView.confirmBlcok = ^(NSInteger row, id object){
        NSLog(@"%ld--%@",row,object);
    };
    // 取消的回调，不需要写特殊操作可以忽略
    pickerView.cancelBlcok = ^{
        NSLog(@"新建");
    };
    [self.view addSubview:pickerView];
