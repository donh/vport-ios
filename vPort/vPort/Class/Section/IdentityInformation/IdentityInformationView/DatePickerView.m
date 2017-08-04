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

#import "DatePickerView.h"
#import "AppDelegate.h"

#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width

@interface DatePickerView ()

@property (nonatomic, strong) UIDatePicker *pickerview;
@property (nonatomic, strong) UIToolbar *actionToolbar;

@end


@implementation DatePickerView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor=[UIColor whiteColor];
                
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0;
        UITapGestureRecognizer *blackViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewTap)];
        [self.blackView addGestureRecognizer:blackViewTap];
        
        self.pickerview = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,44, SCREENWIDTH, 156)];
        NSString *minStr = @"1900-01-01";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [dateFormatter dateFromString:minStr];
        self.pickerview.minimumDate = minDate;//设置最小日期
//        self.pickerview.maximumDate = [NSDate date];//设置最大日期
        [self.pickerview setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
        self.pickerview.datePickerMode = UIDatePickerModeDate;
        self.pickerview.backgroundColor = [UIColor whiteColor];
        //    显示选中框
//        self.pickerview.showsSelectionIndicator=YES;
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

- (void)setSelectedStr:(NSString *)selectedStr
{
    _selectedStr = [selectedStr copy];
    if (![selectedStr isEqualToString:@""] && ![selectedStr isEqualToString:@"NONE"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [self.pickerview setDate:[dateFormatter dateFromString:selectedStr]];
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
    NSDate *date = self.pickerview.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr =  [dateFormatter stringFromDate:date];
    if (self.selectData) {
        self.selectData(dateStr);
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
