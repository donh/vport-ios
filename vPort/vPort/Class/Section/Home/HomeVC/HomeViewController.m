//
//  HomeViewController.m
//  VPort
//
//  Created by MengFanJun on 2017/5/26.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseNavigationView.h"
#import "HomeMenuView.h"
#import "HomeScanView.h"
#import "SetUpViewController.h"

@interface HomeViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) HomeMenuView *homeMenuView;
@property (nonatomic, strong) HomeScanView *homeScanView;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self creatSubViews];
    [self creatNavigation];
    
}

- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    self.customNaviView.titleLabel.text = @"vPort";
    self.customNaviView.rightBtn.hidden = NO;
    self.customNaviView.leftBtn.hidden = YES;
    self.customNaviView.statusView.backgroundColor = [UIColor clearColor];
    self.customNaviView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.customNaviView.rightBtn setImage:[UIImage imageNamed:@"setUpImage"] forState:UIControlStateNormal];
    [self.customNaviView.rightBtn addTarget:self action:@selector(setUpClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpClicked
{
    SetUpViewController *setUpViewController = [[SetUpViewController alloc] init];
    [self.navigationController pushViewController:setUpViewController animated:YES];
    
}

- (void)creatSubViews
{
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.backgroundImage];
    self.backgroundImage.image = [UIImage imageNamed:@"homeBackgroundImage"];
    
    self.homeMenuView = [[HomeMenuView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 140 * HEIGHT / 667)];
    [self.view addSubview:self.homeMenuView];
    
    self.homeScanView = [[HomeScanView alloc] initWithFrame:CGRectMake(0, self.homeMenuView.frame.size.height + self.homeMenuView.frame.origin.y + 140 * HEIGHT / 667, 104, 130)];
    [self.view addSubview:self.homeScanView];
    self.homeScanView.center = CGPointMake(self.view.frame.size.width / 2, self.homeScanView.center.y);

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
