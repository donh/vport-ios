//
//  EditNameCardViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/7/10.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "EditNameCardViewController.h"
#import "BaseNavigationView.h"
#import "SignTool.h"

@interface EditNameCardViewController ()

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UITextField *userInfoTextField;//用户昵称视图

@property (nonatomic, copy) NSString *userInfoHash;

@end

@implementation EditNameCardViewController

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
    self.customNaviView.titleLabel.text = @"修改昵称";
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviView.rightBtn setTitle:@"    完成" forState:UIControlStateNormal];
    [self.customNaviView.rightBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.customNaviView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.customNaviView.rightBtn.frame = CGRectMake(self.customNaviView.frame.size.width - 60 - 5, self.customNaviView.rightBtn.frame.origin.y, 60, 30);
    self.customNaviView.rightBtn.hidden = NO;
    [self.customNaviView.rightBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];

}

//返回按钮
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存
- (void)saveBtnClicked
{
    
    if (self.userInfoTextField.text.length == 0) {
        [MBProgressHUD showError:@"昵称不能为空"];
        return;
    }
    [self.nameCardInfoDic setObject:self.userInfoTextField.text forKey:@"name"];
    [self uploadContentStrWithValueDic:self.nameCardInfoDic];
}


- (void)uploadContentStrWithValueDic:(NSMutableDictionary *)valueDic
{
    [MBProgressHUD showMessage:@"正在修改昵称..."];
    NSString *savePath = [NSString stringWithFormat:@"%@/tmp/contentStr.txt",NSHomeDirectory()];
    NSString *valueStr = [valueDic mj_JSONString];
    
    if (![valueStr writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改昵称失败"];
        return;
    }
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/v0/add",IPFSAddUrl];
    
    [NetworkFactory uploadFielWithMethod:urlStr parameters:parametersDic andPath:savePath success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *Hash = responseObject[@"Hash"];
        NSString *IPFSUrlStr = [NSString stringWithFormat:@"/ipfs/%@",Hash];
//        NSLog(@"contentUrlStr:%@",IPFSUrlStr);
        self.userInfoHash = IPFSUrlStr;
        //将信息上传到区块链
        [self registrySetWithValueDic:valueDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改昵称失败"];
    } message:nil];
    
}


- (void)registrySetWithValueDic:(NSMutableDictionary *)valueDic
{
    //registry/set接口
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"senderAddress"] = [[SignTool shareSignTool] getAddress];
    parametersDic[@"proxyAddress"] = [UserDefaults objectForKey:@"proxy"];
    parametersDic[@"registrationIdentifier"] = RegistrationIdentifier;
    parametersDic[@"value"] = [valueDic mj_JSONString];
    
    [NetworkFactory postRequestWithMethod:[NSString stringWithFormat:@"%@/vport/registry/set",vPortUrl] parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak EditNameCardViewController *weakSelf = self;
        __weak NSString *weakRawTx = responseObject[@"rawTx"];
        __block int errorNumber = 0;//签名有时会报错，有时重新签名会正确，当重新签名次数超过5次，停止
        [SignTool shareSignTool].SignedErrorBlock = ^{
            if (errorNumber < 5) {
                errorNumber++;
                [[SignTool shareSignTool] singWithTxStr:weakRawTx];
            }
            else
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"修改昵称失败"];
            }
        };
        [SignTool shareSignTool].SignedBlock = ^(NSString *signedTx) {
            [weakSelf transactionSendWithTxStr:signedTx];
        };
        
        NSString *rawTx = responseObject[@"rawTx"];
        [[SignTool shareSignTool] singWithTxStr:rawTx];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改昵称失败"];
    } message:nil];
    
}

- (void)transactionSendWithTxStr:(NSString *)txStr
{
    //transaction/send接口
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"rawTxSigned"] = txStr;
    [NetworkFactory postRequestWithMethod:[NSString stringWithFormat:@"%@/vchain/transaction/send",vPortUrl] parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功"];
        [UserDefaults setObject:self.userInfoHash forKey:@"userInfoHash"];
        [UserDefaults setObject:self.userInfoTextField.text forKey:@"nickName"];
        [UserDefaults synchronize];
        if (self.changeNameCardInfo) {
            self.changeNameCardInfo(self.userInfoTextField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改昵称失败"];
    } message:nil];
}

- (void)creatSubViews
{
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.customNaviView.frame.origin.y + self.customNaviView.frame.size.height + 15, WIDTH, 40)];
    [self.view  addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    self.userInfoTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 40)];
    [whiteView addSubview:self.userInfoTextField];
    self.userInfoTextField.font = [UIFont systemFontOfSize:15];
    self.userInfoTextField.text = self.nameCardInfoDic[@"name"];
    self.userInfoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

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
    
}

-(void)keyWillHiden:(NSNotification *)noti
{
    
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
