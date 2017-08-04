//
//  OperateRecordDetailsViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/6/28.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "OperateRecordDetailsViewController.h"
#import "BaseNavigationView.h"
#import "OperateRecordDetailsView.h"
#import "OperateRecordModel.h"

@interface OperateRecordDetailsViewController ()

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) OperateRecordDetailsView *operateRecordDetailsView;


@end

@implementation OperateRecordDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatNavigation];
    [self creatSubViews];
    
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if ([self.operateRecordModel.operateRecordeType isEqualToString:@"1"]) {
        //登录
        self.customNaviView.titleLabel.text = @"登录";
    }
    else if ([self.operateRecordModel.operateRecordeType isEqualToString:@"2"]) {
        //授权
        self.customNaviView.titleLabel.text = @"授权";
    }
    else if ([self.operateRecordModel.operateRecordeType isEqualToString:@"3"]) {
        //认证
        self.customNaviView.titleLabel.text = @"认证";
    }
    else if ([self.operateRecordModel.operateRecordeType isEqualToString:@"4"]) {
        //声明
        self.customNaviView.titleLabel.text = @"声明";
    }
}

//返回按钮
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatSubViews
{
    self.operateRecordDetailsView = [[OperateRecordDetailsView alloc] initWithFrame:CGRectMake(15, 64 + 15, self.view.frame.size.width - 30, self.view.frame.size.height - 64 - 30)];
    [self.view addSubview:self.operateRecordDetailsView];
    self.operateRecordDetailsView.operateRecordModel = self.operateRecordModel;
    
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
