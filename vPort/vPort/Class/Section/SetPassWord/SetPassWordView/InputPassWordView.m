//
//  InputPassWordView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/21.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "InputPassWordView.h"
#import "PassWordView.h"
#import "SignTool.h"

@interface InputPassWordView () <PassWordViewDelegate>

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) PassWordView *passWordView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIButton *laterBtn;

@end

@implementation InputPassWordView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:self.blackView];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0;
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 135)];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.masksToBounds = YES;
        [self addSubview:self.backgroundView];
        self.backgroundView.center = self.center;
        
        self.passWordView = [[PassWordView alloc] initWithFrame:CGRectMake(0, 0, 45 * 4, 40)];
        [self.backgroundView addSubview:self.passWordView];
        self.passWordView.center = CGPointMake(self.backgroundView.frame.size.width / 2, self.backgroundView.frame.size.height / 2);
        self.passWordView.delegate = self;
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.backgroundView.frame.size.width - 20, self.passWordView.frame.origin.y - 20)];
        [self.backgroundView addSubview:self.contentLabel];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"464646" alpha:1];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.text = @"请输入密码";
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

//显示
- (void)show
{
    [UIView animateWithDuration:0.1 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.blackView.alpha = 0.5;
    }];
}

//隐藏
- (void)hide
{
    [UIView animateWithDuration:0.1 animations:^{
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)passWordCompleteInput:(PassWordView *)passWord
{
    NSString *passWordStr = passWord.textStore;
    BOOL status = [[SignTool shareSignTool].secretKey checkWithPassword:passWordStr];
    if (status) {
        [SignTool shareSignTool].passWordStr = passWordStr;
//        [[SignTool shareSignTool] signToken];
        [self hide];
    }
    else
    {
        [MBProgressHUD showError:@"密码错误"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
