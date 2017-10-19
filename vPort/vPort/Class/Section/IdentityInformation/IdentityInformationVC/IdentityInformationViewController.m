//
//  IdentityInformationViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "IdentityInformationViewController.h"
#import "BaseNavigationView.h"
#import "IdentityInformationHeadView.h"
#import "IdentityInformationTableViewCell.h"
#import "EditIdentityInformationViewController.h"
#import "DataBaseTool.h"
#import <MJRefresh.h>
#import "SignTool.h"

@interface IdentityInformationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IdentityInformationHeadView *headView;
@property (nonatomic, strong) BaseLabel *footerView;
//@property (nonatomic, strong) NSMutableArray *informationArray;//标题数据源
@property (nonatomic, strong) IdentityInformationModel *identityInformationModel;

@end

@implementation IdentityInformationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectIdentityInformation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.informationArray = [NSMutableArray array];
    [self creatSubViews];
    [self creatNavigation];
    
}

//查询身份证数据
- (void)selectIdentityInformation
{
    NSString *querySQL = [NSString stringWithFormat:@"select * from identityInformationTable order by identityInformation_id asc"];
    NSMutableArray *array = [[DataBaseTool shareDataBaseTool] selectIdentityInformationModelWithQuerySQL:querySQL];
    if (array.count > 0) {
        self.identityInformationModel = array[0];
        [self creatAttestationJWT];
    }
    else
    {
//        [self.informationArray removeAllObjects];
//        [self.informationArray addObjectsFromArray:array];
        self.identityInformationModel = nil;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }
}

//创建身份证jwt
- (void)creatAttestationJWT
{
    //如果身份证状态为认证中
    if ([self.identityInformationModel.identityInformationStatus isEqualToString:@"3"]) {
        //声明
        NSMutableDictionary *payloadDic = [NSMutableDictionary dictionary];
        [payloadDic setObject:@"vport.chancheng.user" forKey:@"iss"];
        [payloadDic setObject:@"vport.chancheng.server" forKey:@"aud"];

        NSString *iatStr = [self getTimer];
        [payloadDic setObject:[NSNumber numberWithInteger:[iatStr integerValue]] forKey:@"iat"];
        //exp为当前时间后15分钟
        [payloadDic setObject:[NSNumber numberWithInteger:[iatStr integerValue] + 900] forKey:@"exp"];
        [payloadDic setObject:@"attestation retrieval for ID" forKey:@"sub"];

        NSMutableDictionary *contextDic = [NSMutableDictionary dictionary];
        [contextDic setObject:[UserDefaults objectForKey:@"proxy"] forKey:@"userProxy"];
        [contextDic setObject:[[SignTool shareSignTool] getPublicKey] forKey:@"userPublicKey"];
        [payloadDic setObject:contextDic forKey:@"context"];
        
        [self signTokenWithJWTDic:payloadDic];
    }
    else
    {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }
}

//对json对象进行JWT签名
- (void)signTokenWithJWTDic:(NSMutableDictionary *)dic;
{
    __weak IdentityInformationViewController *weakSelf = self;
    __weak NSMutableDictionary *weakDic = dic;
    __block int errorNumber = 0;//签名有时会报错，有时重新签名会正确，当重新签名次数超过5次，停止
    [SignTool shareSignTool].SignedErrorBlock = ^{
        if (errorNumber < 5) {
            errorNumber++;
            [[SignTool shareSignTool] signTokenWithJWTDic:weakDic];
        }
        else{
            [weakSelf.tableView.mj_header endRefreshing];
        }
    };
    [SignTool shareSignTool].SignTokenBlock = ^(NSString *JWTStr) {
        NSLog(@"result:%@",JWTStr);
        [weakSelf getIdentityInformationStatusWithAttestationJWT:JWTStr];
    };
    
    [[SignTool shareSignTool] signTokenWithJWTDic:dic];
    
}

//获取身份证状态
- (void)getIdentityInformationStatusWithAttestationJWT:(NSString *)attestationJWT
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"attestationJWT"] = attestationJWT;
    [NetworkFactory postRequestWithVPortMethod:AttestationUrl parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"status"]];
        if ([status isEqualToString:@"APPROVED"]) {
//            [MBProgressHUD showSuccess:@"认证成功"];
            //认证成功后，存入操作记录
            self.identityInformationModel.identityInformationStatus = @"2";
            self.identityInformationModel.attestationJWT = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"attestation"]];
            [[DataBaseTool shareDataBaseTool] updateIdentityInformationWithModel:self.identityInformationModel];
            [self addOperateRecordWithOperateRecordeType:@"3" andOperateRecordeStatus:@"1" andOperateRecordeInfo:@"身份证"];
        }
        else if ([status isEqualToString:@"REJECTED"]) {
//            [MBProgressHUD showError:@"认证失败"];
            //认证失败后，存入操作记录
            self.identityInformationModel.identityInformationStatus = @"4";
            [[DataBaseTool shareDataBaseTool] updateIdentityInformationWithModel:self.identityInformationModel];
            [self addOperateRecordWithOperateRecordeType:@"3" andOperateRecordeStatus:@"2" andOperateRecordeInfo:@"身份证"];
        }
        else if ([status isEqualToString:@"PENDING"]) {
            //处理中，不做变化
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD showError:@""];
    } message:nil];

}


- (void)addOperateRecordWithOperateRecordeType:(NSString *)operateRecordeType andOperateRecordeStatus:(NSString *)operateRecordeStatus andOperateRecordeInfo:(NSString *)operateRecordeInfo
{
    //登录、成功
    NSString *headImageUrl = [UserDefaults objectForKey:@"userImageUrl"];
    if (!headImageUrl) {
        headImageUrl = @"";
    }
    NSString *userName = [UserDefaults objectForKey:@"nickName"];
    if (!userName) {
        userName = @"";
    }
    NSString *webUrl = AttestationUrl;
    NSMutableDictionary *dic = @{@"userName":userName,
                                 @"userImageUrl":headImageUrl,
                                 @"operateRecordeType":operateRecordeType,
                                 @"operateRecordeStatus":operateRecordeStatus,
                                 @"operateRecordeInfo":operateRecordeInfo,
                                 @"webImageUrl":@"",
                                 @"webUrl":webUrl,
                                 @"webName":@"智信禅城"
                                 }.mutableCopy;
    
    OperateRecordModel *operateRecordModel = [[OperateRecordModel alloc] initWithDict:dic];
    [[DataBaseTool shareDataBaseTool] insertOperateRecordWithModel:operateRecordModel];
    
}

- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
//    self.customNaviView.rightBtn.hidden = NO;
    self.customNaviView.statusView.backgroundColor = [UIColor clearColor];
    self.customNaviView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.customNaviView.rightBtn setImage:[UIImage imageNamed:@"addIdentityInformationImage"] forState:UIControlStateNormal];
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviView.rightBtn addTarget:self action:@selector(addIdentityInformationClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

//返回按钮
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addIdentityInformationClicked
{
    
}

- (void)creatSubViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.bounces = NO;
    [_tableView registerClass:[IdentityInformationTableViewCell class] forCellReuseIdentifier:@"reuse1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];

    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    self.headView = [[IdentityInformationHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 3 * 2 + 5)];
    self.tableView.tableHeaderView = self.headView;
    
    self.footerView = [[BaseLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    self.footerView.text = @"注：请携带本人身份证到窗口办理认证";
    self.footerView.font = [UIFont systemFontOfSize:13];
    self.footerView.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
    self.footerView.textAlignment = NSTextAlignmentCenter;
//    self.tableView.tableFooterView = self.footerView;
    
}

- (void)refreshData
{
    [self selectIdentityInformation];
}

#pragma  mark ** tableView协议方法
//分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每个分区cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
//        if (self.informationArray.count == 0) {
//            return 1;
//        }
//        else
//        {
//            return 1;
//        }
    }
    return 0;
}

//重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.identityInformationModel == nil) {
        IdentityInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.statusStr = @"";
        }
        return cell;
    }
    else
    {
        IdentityInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.identityInformationModel = self.identityInformationModel;
        return cell;
    }
    return nil;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95;
    }
    return 0.01;
}

//分区header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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
    if (section == 0) {
        if (![self.identityInformationModel.identityInformationStatus isEqualToString:@"2"])
        {
            return 66;
        }
    }
    return 0.01;
}

//分区footView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (![self.identityInformationModel.identityInformationStatus isEqualToString:@"2"])
        {
            return self.footerView;
        }
    }
    return nil;
}

//点击cell跳转至详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditIdentityInformationViewController *editIdentityInformationViewController = [[EditIdentityInformationViewController alloc] init];
    if (self.identityInformationModel != nil) {
        editIdentityInformationViewController.identityInformationModel = self.identityInformationModel;
    }
    [self.navigationController pushViewController:editIdentityInformationViewController animated:YES];
    
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
