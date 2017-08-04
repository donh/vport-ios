//
//  SetUpViewController.m
//  VPort
//
//  Created by MengFanJun on 2017/6/5.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "SetUpViewController.h"
#import "BaseNavigationView.h"
#import "SetUpTableViewCell.h"
#import "AppDelegate.h"
#import "DataBaseTool.h"

@interface SetUpViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *informationArray;//标题数据源
@property (nonatomic, strong) UIButton *exitBtn;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.informationArray = @[@"政策法规",@"版本信息",@"关于"];

    [self creatNavigation];
    [self creatSubViews];
    
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    self.customNaviView.titleLabel.text = @"设置";
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

//返回按钮
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatSubViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [_tableView registerClass:[SetUpTableViewCell class] forCellReuseIdentifier:@"reuse1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.exitBtn];
    self.exitBtn.frame = CGRectMake(20, self.view.frame.size.height - 60 * HEIGHT / 667, self.view.frame.size.width - 40, 40);
    self.exitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.exitBtn setTitle:@"登出" forState:UIControlStateNormal];
    [self.exitBtn setTitleColor:BaseBlueCOLOR forState:UIControlStateNormal];
    [self.exitBtn addTarget:self action:@selector(exitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.exitBtn.layer.cornerRadius = 4;
    self.exitBtn.layer.masksToBounds = YES;
    self.exitBtn.backgroundColor = [UIColor whiteColor];
}

- (void)exitBtnClicked
{
    [UserDefaults setBool:NO forKey:@"isLogin"];
//    [UserDefaults setBool:NO forKey:@"isNotFirstTimeUse"];
    [UserDefaults removeObjectForKey:@"proxy"];
    [UserDefaults removeObjectForKey:@"userImageUrl"];
    [UserDefaults removeObjectForKey:@"userInfoHash"];
    [UserDefaults removeObjectForKey:@"nickName"];
    [UserDefaults synchronize];
    
    [[DataBaseTool shareDataBaseTool] deleteDataBase];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate setRootVC];
}

#pragma  mark ** tableView协议方法
//分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每个分区cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.informationArray.count;
}

//重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.informationArray[indexPath.row];
    if (indexPath.row == self.informationArray.count - 1) {
        cell.line.hidden = YES;
    }
    else
    {
        cell.line.hidden = NO;
    }
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//分区header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 0.01;
}

//分区headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
    }
    return nil;
}

//分区footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//分区footView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

//点击cell跳转至详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = self.informationArray[indexPath.row];
    if ([titleStr isEqualToString:@"政策法规"]) {
    }
    else if ([titleStr isEqualToString:@"版本信息"]) {
    }
    else if ([titleStr isEqualToString:@"关于"]) {
    }
    
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
