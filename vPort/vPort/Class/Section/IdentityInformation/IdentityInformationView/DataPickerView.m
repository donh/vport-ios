/*
 * Copyright (C) 2016-2016, The Little-Sparkle Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS-IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "DataPickerView.h"
#import "AppDelegate.h"

#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width

@interface DataPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerview;
@property (nonatomic, strong) UIToolbar *actionToolbar;

@end

@implementation DataPickerView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor=[UIColor whiteColor];
        
        self.dataArray = [NSMutableArray array];
        
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0;
        UITapGestureRecognizer *blackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewTap)];
        [self.blackView addGestureRecognizer:blackViewTap];
        
        self.pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0,44, SCREENWIDTH, 156)];
        //    指定Delegate
        self.pickerview.delegate=self;
        self.pickerview.dataSource=self;
        self.pickerview.backgroundColor = [UIColor whiteColor];
        //    显示选中框
        self.pickerview.showsSelectionIndicator=YES;
        [self addSubview:self.pickerview];
        
        self.actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        [self.actionToolbar sizeToFit];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"  取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"252525" alpha:1] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.frame = CGRectMake(0, 0, 45, 44);
        [cancelBtn addTarget:self action:@selector(pickerCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelButtonItem=[[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UILabel *flexLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, WIDTH - 90, 44)];
        flexLabel.text = @"";
        flexLabel.font = [UIFont systemFontOfSize:16];
        flexLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
        flexLabel.textAlignment = NSTextAlignmentCenter;
        flexSpace.customView = flexLabel;
        flexLabel.backgroundColor = [UIColor whiteColor];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setTitle:@"确认  " forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexString:@"252525" alpha:1] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        doneBtn.frame = CGRectMake(0, 0, 45, 44);
        [doneBtn addTarget:self action:@selector(pickerDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneButtonItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
        doneBtn.backgroundColor = [UIColor whiteColor];
        
        [self.actionToolbar setItems:[NSArray arrayWithObjects:cancelButtonItem,flexSpace,doneButtonItem, nil] animated:YES];
        self.actionToolbar.barTintColor = [UIColor whiteColor];
        [self addSubview:self.pickerview];
        [self addSubview:self.actionToolbar];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
}

- (void)setSelectedStr:(NSString *)selectedStr
{
    _selectedStr = [selectedStr copy];
    if (![selectedStr isEqualToString:@""]) {
        NSInteger index = [self.dataArray indexOfObject:selectedStr];
        [self.pickerview selectRow:index inComponent:0 animated:NO];
    }else
    {
        _selectedStr = self.dataArray[0];
    }
}

- (void)blackViewTap
{
    [UIView animateWithDuration:0.5 animations:^{
        //480 是屏幕尺寸
        self.blackView.alpha = 0;
        self.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)pickerCancelClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        //480 是屏幕尺寸
        self.blackView.alpha = 0;
        self.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)pickerDoneClicked
{
    if (self.selectData) {
        self.selectData(self.selectedStr);
    }
    [UIView animateWithDuration:0.5 animations:^{
        //480 是屏幕尺寸
        self.blackView.alpha = 0;
        self.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
    
//    if (component==0) {
//        return [self.firstData count];
//    }else if (component==1){
//        return [self.secondData count];
//    }else{
//        return [self.thirdData count];
//    }
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
//    if (component==0) {
//        return [self.firstData objectAtIndex:row];
//    }else if (component==1){
//        return [self.secondData objectAtIndex:row];
//    }else{
//        return [self.thirdData objectAtIndex:row];
//    }
}

-(void)pickerView:(UIPickerView *)pickerViewt didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedStr = self.dataArray[row];
}

//设置滚轮的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 100;
    }else if(component==1){
        return 100;
    }else{
        return 100;
    }
}

//设置滚轮的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//    }
//    // Setup label properties - frame, font, colors etc
//    //adjustsFontSizeToFitWidth property to YES
//    pickerLabel.frame = CGRectMake(0, 0, WIDTH, 100);
//    pickerLabel.adjustsFontSizeToFitWidth = YES;
//    pickerLabel.textAlignment = NSTextAlignmentCenter;
//    //        [pickerLabel setTextAlignment:UITextAlignmentCenter];
//    [pickerLabel setBackgroundColor:[UIColor clearColor]];
//    [pickerLabel setFont:[UIFont boldSystemFontOfSize:19]];
//    // Fill the label text here
//    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
