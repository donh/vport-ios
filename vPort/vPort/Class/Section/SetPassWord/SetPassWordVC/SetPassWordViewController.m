//
//  SetPassWordViewController.m
//  VPort
//
//  Created by MengFanJun on 2017/6/8.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "SetPassWordViewController.h"
#import "BaseNavigationView.h"
#import "PassWordViewController.h"

@interface SetPassWordViewController ()

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) BaseLabel *importantReminderLabel;
@property (nonatomic, strong) BaseLabel *reminderLabel;
@property (nonatomic, strong) UIButton *goSetBtn;;

@end

@implementation SetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self creatSubViews];
    [self creatNavigation];

}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    [self.customNaviView.leftBtn setImage:[UIImage imageNamed:@"backImage-1"] forState:UIControlStateNormal];
    [self.customNaviView.leftBtn setTitle:@"  注册" forState:UIControlStateNormal];
    self.customNaviView.leftBtn.titleLabel.font = TitleFont;
    [self.customNaviView.leftBtn setTitleColor:BaseBlueCOLOR forState:UIControlStateNormal];
    self.customNaviView.leftBtn.frame = CGRectMake(self.customNaviView.leftBtn.frame.origin.x, self.customNaviView.leftBtn.frame.origin.y, 70, self.customNaviView.leftBtn.frame.size.height);
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.customNaviView.backgroundColor = [UIColor clearColor];
    self.customNaviView.statusView.backgroundColor = [UIColor clearColor];
    self.customNaviView.backgroundView.backgroundColor = [UIColor clearColor];
    
}

//返回按钮
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatSubViews
{
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 82 * HEIGHT / 667, 112, 112)];
    [self.view addSubview:self.logoImage];
    self.logoImage.center = CGPointMake(self.view.center.x, self.logoImage.center.y);
    self.logoImage.image = [UIImage imageNamed:@"logoImage"];
    
    self.importantReminderLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(0, self.logoImage.frame.size.height + self.logoImage.frame.origin.y + 90 * HEIGHT / 667, self.view.frame.size.width, 14)];
    [self.view addSubview:self.importantReminderLabel];
    self.importantReminderLabel.text = @"请设置4位数字作为交易码";
    self.importantReminderLabel.font = [UIFont systemFontOfSize:13];
    self.importantReminderLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
    self.importantReminderLabel.textAlignment = NSTextAlignmentCenter;
    
    self.reminderLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(0, self.importantReminderLabel.frame.origin.y + self.importantReminderLabel.frame.size.height + 10, self.view.frame.size.width, 14)];
    [self.view addSubview:self.reminderLabel];
    self.reminderLabel.text = @"这将用于您在APP中确认交易信息";
    self.reminderLabel.font = [UIFont systemFontOfSize:13];
    self.reminderLabel.textAlignment = NSTextAlignmentCenter;
    self.reminderLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];
    
    self.goSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.goSetBtn];
    self.goSetBtn.frame = CGRectMake(15, self.view.frame.size.height - 80 * HEIGHT / 667, self.view.frame.size.width - 30, 40);
    self.goSetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.goSetBtn setTitle:@"去设置" forState:UIControlStateNormal];
    [self.goSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.goSetBtn addTarget:self action:@selector(goSetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.goSetBtn.layer.cornerRadius = 4;
    self.goSetBtn.layer.masksToBounds = YES;
    self.goSetBtn.backgroundColor = BaseBlueCOLOR;
    
}

- (void)goSetBtnClicked
{
    PassWordViewController *passWordViewController = [[PassWordViewController alloc] init];
    [self.navigationController pushViewController:passWordViewController animated:YES];
}

#pragma  mark —— 修改状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
//    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
