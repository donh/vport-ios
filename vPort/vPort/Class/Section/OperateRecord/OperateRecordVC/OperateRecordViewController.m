//
//  OperateRecordViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "OperateRecordViewController.h"
#import "BaseNavigationView.h"
#import "OperateRecordTableViewCell.h"
#import "OperateRecordDetailsViewController.h"
#import "DataBaseTool.h"
#import <MJRefresh.h>

@interface OperateRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger last_index;//最后一个下标，默认为0
@property (nonatomic, strong) NSMutableArray *informationArray;//标题数据源

@end

@implementation OperateRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.informationArray = [NSMutableArray array];
    
    [self creatNavigation];
    [self creatSubViews];
    [self selectOperateRecordWithType:@"1"];

}

//查询操作记录数据
- (void)selectOperateRecordWithType:(NSString *)type
{
    if ([type isEqualToString:@"1"]) {
        self.last_index = 0;
    }
    self.last_index += Count;
    
//    NSString *querySQL = [NSString stringWithFormat:@"select * from operateRecordTable order by operateRecord_id desc"];
//    NSString *querySQL = [NSString stringWithFormat:@"select * from operateRecordTable order by time desc LIMIT '%ld'",self.last_index];
    NSString *querySQL = [NSString stringWithFormat:@"select * from operateRecordTable order by operateRecord_id desc LIMIT '%ld'",self.last_index];
    
    NSMutableArray *array = [[DataBaseTool shareDataBaseTool] selectOperateRecordModelWithQuerySQL:querySQL];
    
    if ([type isEqualToString:@"1"]) {
        //刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if (array.count == 0)
        {
            self.tableView.mj_footer.hidden = YES;
            self.tableView.hidden = YES;
        }else
        {
            self.tableView.mj_footer.hidden = NO;
            self.tableView.hidden = NO;
        }
        [self.informationArray removeAllObjects];
        [self.informationArray addObjectsFromArray:array];
    }
    else
    {
        //加载
        if (array.count == self.informationArray.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.informationArray removeAllObjects];
        [self.informationArray addObjectsFromArray:array];
    }
    
    [self.tableView reloadData];
    
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    self.customNaviView.titleLabel.text = @"操作记录";
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
    [_tableView registerClass:[OperateRecordTableViewCell class] forCellReuseIdentifier:@"reuse1"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

}

- (void)refreshData
{
    [self selectOperateRecordWithType:@"1"];
}

- (void)loadData
{
    [self selectOperateRecordWithType:@"2"];
}

#pragma  mark ** tableView协议方法
//分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每个分区cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.informationArray.count;
    }
    return 0;
}

//重用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OperateRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.operateRecordModel = self.informationArray[indexPath.row];
        if (indexPath.row == self.informationArray.count - 1) {
            cell.line.hidden = YES;
        }
        else
        {
            cell.line.hidden = NO;
        }
        return cell;
    }
    return nil;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 0.01;
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
    OperateRecordDetailsViewController *operateRecordDetailsViewController = [[OperateRecordDetailsViewController alloc] init];
    operateRecordDetailsViewController.operateRecordModel = self.informationArray[indexPath.row];
    [self.navigationController pushViewController:operateRecordDetailsViewController animated:YES];
    
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
