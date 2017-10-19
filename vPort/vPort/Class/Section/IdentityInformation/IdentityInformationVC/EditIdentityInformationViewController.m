//
//  EditIdentityInformationViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/6/20.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "EditIdentityInformationViewController.h"
#import "BaseNavigationView.h"
#import "EditIdentityInformationTableViewCell.h"
#import "IdentityInformationDateTableViewCell.h"
#import "IdentityInformationGenderTableViewCell.h"
#import "DatePickerView.h"
#import "IdentityInformationModel.h"
#import "DataPickerView.h"
#import "DataBaseTool.h"

@interface EditIdentityInformationViewController ()  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *informationArray;//标题数据源
@property (nonatomic, assign) CGFloat textFieldHeight;
@property (nonatomic, strong) UITapGestureRecognizer *keyboardResignTap;
@property (nonatomic, strong) NSMutableDictionary *identityInformationDic;

@end

@implementation EditIdentityInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.informationArray = @[@"姓名",@"身份证号",@"性别",@"有效期开始日期",@"有效期结束日期",@"签发机关"];
    self.identityInformationDic = @{@"姓名":@"",@"身份证号":@"",@"性别":@"",@"有效期开始日期":@"",@"有效期结束日期":@"",@"签发机关":@""}.mutableCopy;
    NSLog(@"%@",self.identityInformationModel.identityInformation_id);
    if (self.identityInformationModel.identityInformation_id.length != 0) {
        [self.identityInformationDic setObject:self.identityInformationModel.name forKey:@"姓名"];
        [self.identityInformationDic setObject:self.identityInformationModel.gender forKey:@"性别"];
        [self.identityInformationDic setObject:self.identityInformationModel.identityInformationNumber forKey:@"身份证号"];
        [self.identityInformationDic setObject:self.identityInformationModel.identityInformationBeginDate forKey:@"有效期开始日期"];
        [self.identityInformationDic setObject:self.identityInformationModel.identityInformationFinishDate forKey:@"有效期结束日期"];
        [self.identityInformationDic setObject:self.identityInformationModel.issuingAuthority forKey:@"签发机关"];
    }
    
    [self creatSubViews];
    [self creatNavigation];
    [self handleKeyEvent];
    
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    self.customNaviView.titleLabel.text = @"身份信息";
    [self.customNaviView.rightBtn setTitle:@"    保存" forState:UIControlStateNormal];
    [self.customNaviView.rightBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.customNaviView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.customNaviView.rightBtn.frame = CGRectMake(self.customNaviView.frame.size.width - 60 - 5, self.customNaviView.rightBtn.frame.origin.y, 60, 30);
    self.customNaviView.rightBtn.hidden = NO;
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
    [self resignKeyTap];
    if (!self.identityInformationModel) {
        self.identityInformationModel = [[IdentityInformationModel alloc] init];
    }
    self.identityInformationModel.name = self.identityInformationDic[@"姓名"];
    self.identityInformationModel.identityInformationNumber = self.identityInformationDic[@"身份证号"];
    self.identityInformationModel.gender = self.identityInformationDic[@"性别"];
    self.identityInformationModel.identityInformationBeginDate = self.identityInformationDic[@"有效期开始日期"];
    self.identityInformationModel.identityInformationFinishDate = self.identityInformationDic[@"有效期结束日期"];
    self.identityInformationModel.issuingAuthority = self.identityInformationDic[@"签发机关"];
    if (self.identityInformationModel.name.length == 0) {
        [MBProgressHUD showError:@"姓名不能为空"];
        return;
    }
    else if (self.identityInformationModel.identityInformationNumber.length == 0)
    {
        [MBProgressHUD showError:@"身份证号不能为空"];
        return;
    }
    else if (![self CheckIsIdentityCard:self.identityInformationModel.identityInformationNumber])
    {
        [MBProgressHUD showError:@"身份证号不正确"];
        return;
    }
    else if (self.identityInformationModel.gender.length == 0)
    {
        [MBProgressHUD showError:@"性别不能为空"];
        return;
    }
    else if (self.identityInformationModel.identityInformationBeginDate.length == 0)
    {
        [MBProgressHUD showError:@"有效期开始日期不能为空"];
        return;
    }
    else if (self.identityInformationModel.identityInformationFinishDate.length == 0)
    {
        [MBProgressHUD showError:@"有效期结束日期不能为空"];
        return;
    }
    else if (self.identityInformationModel.issuingAuthority.length == 0)
    {
        [MBProgressHUD showError:@"签发机关不能为空"];
        return;
    }
    if (self.identityInformationModel.identityInformationStatus.length == 0 || [self.identityInformationModel.identityInformationStatus isEqualToString:@"1"] || [self.identityInformationModel.identityInformationStatus isEqualToString:@"4"]) {
        //当身份证状态为空、1（待认证）或者4（认证失败）时，可以编辑身份证信息
        self.identityInformationModel.identityInformationStatus = @"1";
        if (self.identityInformationModel.identityInformation_id.length == 0) {
            [[DataBaseTool shareDataBaseTool] insertIdentityInformationWithModel:self.identityInformationModel];
            [MBProgressHUD showSuccess:@"身份证添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[DataBaseTool shareDataBaseTool] updateIdentityInformationWithModel:self.identityInformationModel];
            [MBProgressHUD showSuccess:@"身份证更新成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [MBProgressHUD showError:@"当前状态不可编辑身份证信息"];
    }
}

- (void)creatSubViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView registerClass:[EditIdentityInformationTableViewCell class] forCellReuseIdentifier:@"reuse1"];
    [_tableView registerClass:[IdentityInformationGenderTableViewCell class] forCellReuseIdentifier:@"reuse2"];
    [_tableView registerClass:[IdentityInformationDateTableViewCell class] forCellReuseIdentifier:@"reuse3"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
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
    NSString *titleStr = self.informationArray[indexPath.row];
    
    if ([titleStr isEqualToString:@"性别"])
    {
        IdentityInformationGenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = titleStr;
        cell.valueLabel.text = self.identityInformationDic[titleStr];
        return cell;
    }
    else if ([titleStr isEqualToString:@"有效期开始日期"] || [titleStr isEqualToString:@"有效期结束日期"]) {
        IdentityInformationDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = titleStr;
        cell.valueLabel.text = self.identityInformationDic[titleStr];
        if ([cell.valueLabel.text isEqualToString:@"NONE"]) {
            cell.valueLabel.text = @"长期";
        }
        return cell;
    }
    else{
        EditIdentityInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.valueTextField.delegate = self;
        cell.valueTextField.tag = 100 + indexPath.row;
        cell.titleStr = titleStr;
        cell.valueTextField.text = self.identityInformationDic[titleStr];
        return cell;
    }
    return nil;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 58;
    }
    return 0.01;
}

//分区header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
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
    if ([titleStr isEqualToString:@"性别"])
    {
        [self showGenderPickerView];
    }
    else if ([titleStr isEqualToString:@"有效期开始日期"]) {
        [self showBeginDatePickerView];
    }
    else if ([titleStr isEqualToString:@"有效期结束日期"]) {
        [self showFinishDatePickerView];
    }
}

//推出性别选择器
- (void)showGenderPickerView
{
    DataPickerView *genderPickerView=[[DataPickerView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 230)];
    genderPickerView.dataArray = @[@"男",@"女"].mutableCopy;
    genderPickerView.selectedStr = self.identityInformationDic[@"性别"];
    __block EditIdentityInformationViewController *weakSelf = self;
    genderPickerView.selectData = ^(NSString *selectedStr)
    {
        [weakSelf.identityInformationDic setObject:selectedStr forKey:@"性别"];
        [weakSelf.tableView reloadData];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:genderPickerView];
    [UIView animateWithDuration:0.4 animations:^{
        genderPickerView.blackView.alpha = 0.6;
        genderPickerView.frame=CGRectMake(0, HEIGHT - 200, WIDTH, 200);
    }];
}

//推出开始日期选择器
- (void)showBeginDatePickerView
{
    DatePickerView *datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 230)];
    datePickerView.selectedStr = self.identityInformationDic[@"有效期开始日期"];
    __block EditIdentityInformationViewController *weakSelf = self;
    datePickerView.selectData = ^(NSString *selectedStr)
    {
        [weakSelf.identityInformationDic setObject:selectedStr forKey:@"有效期开始日期"];
        [weakSelf.tableView reloadData];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
    [UIView animateWithDuration:0.4 animations:^{
        datePickerView.blackView.alpha = 0.6;
        datePickerView.frame=CGRectMake(0, HEIGHT - 200, WIDTH, 200);
    }];
    
}

//推出结束日期选择器
- (void)showFinishDatePickerView
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择日期", @"身份证长期有效" ,nil];
    sheet.tag = 2000;
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2000) {
        if (buttonIndex == 1) {
            [self.identityInformationDic setObject:@"NONE" forKey:@"有效期结束日期"];
            [self.tableView reloadData];
        }
        else if (buttonIndex == 0)
        {
            DatePickerView *datePickerView=[[DatePickerView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 230)];
            datePickerView.selectedStr = self.identityInformationDic[@"有效期结束日期"];
            __block EditIdentityInformationViewController *weakSelf = self;
            datePickerView.selectData = ^(NSString *selectedStr)
            {
                [weakSelf.identityInformationDic setObject:selectedStr forKey:@"有效期结束日期"];
                [weakSelf.tableView reloadData];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
            [UIView animateWithDuration:0.4 animations:^{
                datePickerView.blackView.alpha = 0.6;
                datePickerView.frame=CGRectMake(0, HEIGHT - 200, WIDTH, 200);
            }];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:window];
    self.textFieldHeight = rect.size.height + rect.origin.y;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *titleStr = self.informationArray[textField.tag - 100];
    [self.identityInformationDic setObject:textField.text forKey:titleStr];
}

//键盘处理
-(void)handleKeyEvent
{
    self.keyboardResignTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyTap)];
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
    [self.view addGestureRecognizer:self.keyboardResignTap];
    CGRect keyRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = self.textFieldHeight - keyRect.origin.y + 10;
    if (height > 0) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.tableView.frame = CGRectMake(0, 64 - height, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.tableView.frame = CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
    }
}

-(void)keyWillHiden:(NSNotification *)noti
{
    [self.view removeGestureRecognizer:self.keyboardResignTap];
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.tableView.frame = CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }];
}

//身份证号校验
- (BOOL)CheckIsIdentityCard:(NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
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
