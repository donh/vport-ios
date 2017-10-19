//
//  RegsiterViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "RegsiterViewController.h"
#import "SetPassWordViewController.h"

@interface RegsiterViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UITextField *nickNameTextField;
@property (nonatomic, strong) UIButton *createBtn;

@end

@implementation RegsiterViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self creatSubViews];
    [self handleKeyEvent];
    
}

- (void)creatSubViews
{
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 82 * HEIGHT / 667, 112, 112)];
    [self.view addSubview:self.logoImage];
    self.logoImage.center = CGPointMake(self.view.center.x, self.logoImage.center.y);
    self.logoImage.image = [UIImage imageNamed:@"logoImage"];
    
    self.createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.createBtn];
    self.createBtn.frame = CGRectMake(15, self.view.frame.size.height - 80 * HEIGHT / 667, self.view.frame.size.width - 30, 40);
    self.createBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.createBtn setTitle:@"创建新账号" forState:UIControlStateNormal];
    [self.createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.createBtn addTarget:self action:@selector(createBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.createBtn.layer.cornerRadius = 4;
    self.createBtn.layer.masksToBounds = YES;
    self.createBtn.backgroundColor = BaseBlueCOLOR;
    
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, self.createBtn.frame.origin.y - 35 - 15, self.view.frame.size.width - 30, 35)];
    [self.view addSubview:self.nickNameTextField];
    self.nickNameTextField.textColor = [UIColor colorWithHexString:@"898989" alpha:1];
    self.nickNameTextField.font = [UIFont systemFontOfSize:13];
    self.nickNameTextField.placeholder = @"请输入昵称";
    [self.nickNameTextField setValue:[UIColor colorWithHexString:@"898989" alpha:1]forKeyPath:@"_placeholderLabel.textColor"];
    self.nickNameTextField.textAlignment = NSTextAlignmentCenter;
    self.nickNameTextField.delegate = self;
    self.nickNameTextField.layer.borderWidth = 0.5;
    self.nickNameTextField.layer.borderColor = [UIColor colorWithHexString:@"898989" alpha:1].CGColor;
    
}
- (void)createBtnClicked
{
    if (self.nickNameTextField.text.length == 0) {
        [MBProgressHUD showError:@"昵称不能为空"];
        return;
    }
    else
    {
        [UserDefaults setObject:self.nickNameTextField.text forKey:@"nickName"];
        SetPassWordViewController *setPassWordViewController = [[SetPassWordViewController alloc] init];
        [self.navigationController pushViewController:setPassWordViewController animated:YES];
    }
}

//键盘处理
-(void)handleKeyEvent
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyTap)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)resignKeyTap
{
    [self.view endEditing:YES];
}

-(void)keyWillShow:(NSNotification *)noti
{
    CGRect keyRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = self.nickNameTextField.frame.origin.y + self.nickNameTextField.frame.size.height - keyRect.origin.y + 10;
    if (height > 0) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.view.frame = CGRectMake(0, - height, self.view.frame.size.width, self.view.frame.size.height);
            self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 82 * HEIGHT / 667 + height, self.logoImage.frame.size.width, self.logoImage.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 82 * HEIGHT / 667, self.logoImage.frame.size.width, self.logoImage.frame.size.height);
        }];
    }
}

-(void)keyWillHiden:(NSNotification *)noti
{
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.logoImage.frame = CGRectMake(self.logoImage.frame.origin.x, 82 * HEIGHT / 667, self.logoImage.frame.size.width, self.logoImage.frame.size.height);
    }];
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
