//
//  PassWordViewController.m
//  VPort
//
//  Created by MengFanJun on 2017/6/9.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "PassWordViewController.h"
#import "BaseNavigationView.h"
#import "AppDelegate.h"
#import "PassWordView.h"
#import "XRandom.h"
#import "BTHDAccountCold.h"
#import "SignTool.h"

@interface PassWordViewController () <PassWordViewDelegate>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) BaseLabel *reminderLabel;
@property (nonatomic, strong) PassWordView *passWordView;
@property (nonatomic, strong) UITapGestureRecognizer *keyboardResignTap;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, copy) NSString *verifyPassWordStr;
@property (nonatomic, copy) NSString *passWordStr;
@property (nonatomic, copy) NSString *passWordStatus;

@property (nonatomic, copy) NSString *userInfoHash;

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.passWordStatus = @"请输入密码";
    [self creatSubViews];
    [self creatNavigation];
    [self handleKeyEvent];
    
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    [self.customNaviView.leftBtn setImage:[UIImage imageNamed:@"backImage-1"] forState:UIControlStateNormal];
    [self.customNaviView.leftBtn setTitle:@"  设置密码" forState:UIControlStateNormal];
    self.customNaviView.leftBtn.titleLabel.font = TitleFont;
    [self.customNaviView.leftBtn setTitleColor:BaseBlueCOLOR forState:UIControlStateNormal];
    self.customNaviView.leftBtn.frame = CGRectMake(self.customNaviView.leftBtn.frame.origin.x, self.customNaviView.leftBtn.frame.origin.y, 100, self.customNaviView.leftBtn.frame.size.height);
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.customNaviView.backgroundColor = [UIColor clearColor];
    self.customNaviView.statusView.backgroundColor = [UIColor clearColor];
    self.customNaviView.backgroundView.backgroundColor = [UIColor clearColor];
    
//    [self.customNaviView.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    [self.customNaviView.rightBtn setTitleColor:BaseBlueCOLOR forState:UIControlStateNormal];
//    self.customNaviView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    self.customNaviView.rightBtn.frame = CGRectMake(self.customNaviView.frame.size.width - 60 - 5, self.customNaviView.rightBtn.frame.origin.y, 60, 30);
//    self.customNaviView.rightBtn.hidden = NO;
//    [self.customNaviView.rightBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];

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
    
    self.reminderLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(0, self.logoImage.frame.size.height + self.logoImage.frame.origin.y + 50 * HEIGHT / 667, self.view.frame.size.width, 17)];
    [self.view addSubview:self.reminderLabel];
    self.reminderLabel.font = [UIFont systemFontOfSize:16];
    self.reminderLabel.textColor = [UIColor colorWithHexString:@"eb212e" alpha:1];
    self.reminderLabel.textAlignment = NSTextAlignmentCenter;
    self.reminderLabel.text = self.passWordStatus;
    
    self.passWordView = [[PassWordView alloc] initWithFrame:CGRectMake(0, self.reminderLabel.frame.size.height + self.reminderLabel.frame.origin.y + 50 * HEIGHT / 667, 45 * 4, 40)];
    [self.view addSubview:self.passWordView];
    self.passWordView.center = CGPointMake(self.view.frame.size.width / 2, self.passWordView.center.y);
    self.passWordView.delegate = self;
    
}

- (void)passWordCompleteInput:(PassWordView *)passWord
{
    if ([self.passWordStatus isEqualToString:@"请输入密码"]) {
        self.verifyPassWordStr = passWord.textStore;
        self.passWordStatus = @"请再输入一次密码";
        self.passWordStr = @"";
        [passWord clearText];
    }
    else if ([self.passWordStatus isEqualToString:@"请再输入一次密码"])
    {
        if ([self.verifyPassWordStr isEqualToString:passWord.textStore]) {
//            [MBProgressHUD showSuccess:@"密码正确"];
            self.passWordStr = passWord.textStore;
            [self creatSecretKey];
        }
        else
        {
            [MBProgressHUD showError:@"输入密码不一致，请重新设置"];
            self.passWordStatus = @"请输入密码";
            self.verifyPassWordStr = @"";
            [passWord clearText];
        }
    }
    self.reminderLabel.text = self.passWordStatus;
}

- (void)nextBtnClicked
{
    if (self.passWordView.textStore.length != 4) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",self.passWordStatus]];
    }
    else{
        [self creatSecretKey];
    }
}

- (void)creatSecretKey
{
    [MBProgressHUD showMessage:@"正在创建账户，请耐心等待..."];
    XRandom *xRandom = [[XRandom alloc] initWithDelegate:nil];
    BTHDAccountCold *accountCold = nil;
    while (!accountCold) {
        @try {
            NSData *seed = [xRandom randomWithSize:16];
            accountCold = [[BTHDAccountCold alloc] initWithMnemonicSeed:seed btBip39:[BTBIP39 sharedInstance] andPassword:self.passWordStr];
        }
        @catch (NSException *exception) {
            NSLog(@"generate HD Account error %@", exception.debugDescription);
        }
    }
    [self addUserWithKey:accountCold];
    
}

//请求服务器，帮忙注册
- (void)addUserWithKey:(BTHDAccountCold *)accountCold
{
    BTBIP32Key *key = [accountCold masterKey:self.passWordStr];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"name"] = [UserDefaults objectForKey:@"nickName"];
    parametersDic[@"phone"] = @"";
    parametersDic[@"privateKey"] = [key.key rawPrivateKey];
    parametersDic[@"publicKey"] = [self getPublicKey:key.pubKey];
    parametersDic[@"address"] = key.address;
    
    [NetworkFactory postRequestWithVPortMethod:[NSString stringWithFormat:@"%@/api/v1/users/add", serverUrl] parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *nameStr = responseObject[@"result"][@"user"][@"name"];
        
        //记录name、proxy、recovery，及创建密钥
        [UserDefaults setObject:nameStr forKey:@"nickName"];
        [UserDefaults setObject:responseObject[@"result"][@"user"][@"proxy"] forKey:@"proxy"];
        [UserDefaults setObject:responseObject[@"result"][@"user"][@"recovery"] forKey:@"recovery"];
        [UserDefaults setObject:[NSString stringWithFormat:@"%ld",(long)accountCold.getHDAccountId] forKey:@"HDAccountId"];
        [UserDefaults synchronize];
        [[SignTool shareSignTool] creatSecretKey];
        [SignTool shareSignTool].passWordStr = self.passWordStr;
//        NSLog(@"HDAccountId:%ld",accountCold.getHDAccountId);

        //将信息上传到IPFS
        NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
        [valueDic setObject:@"http://schema.org" forKey:@"@context"];
        [valueDic setObject:@"Person" forKey:@"@type"];
        [valueDic setObject:@"HelloWorld" forKey:@"description"];
        [valueDic setObject:@"vChain" forKey:@"network"];
        [valueDic setObject:nameStr forKey:@"name"];
        [valueDic setObject:key.address forKey:@"address"];
        [valueDic setObject:[self getPublicKey:key.pubKey] forKey:@"publicKey"];
        [self uploadContentStrWithValueDic:valueDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"注册失败!"];
    } message:nil];
    
}

- (void)uploadContentStrWithValueDic:(NSMutableDictionary *)valueDic
{
    NSString *savePath = [NSString stringWithFormat:@"%@/tmp/contentStr.txt",NSHomeDirectory()];
    NSString *valueStr = [valueDic mj_JSONString];
    
    if (![valueStr writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"注册失败!"];
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
        [MBProgressHUD showError:@"注册失败!"];
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
        __weak PassWordViewController *weakSelf = self;
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
                [MBProgressHUD showError:@"注册失败!"];
            }
        };
        [SignTool shareSignTool].SignedBlock = ^(NSString *signedTx) {
            [weakSelf transactionSendWithTxStr:signedTx];
        };
        
        NSString *rawTx = responseObject[@"rawTx"];
        [[SignTool shareSignTool] singWithTxStr:rawTx];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"注册失败!"];
    } message:nil];
    
}

- (void)transactionSendWithTxStr:(NSString *)txStr
{
    //transaction/send接口
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"rawTxSigned"] = txStr;
    [NetworkFactory postRequestWithMethod:[NSString stringWithFormat:@"%@/vchain/transaction/send",vPortUrl] parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        [UserDefaults setBool:YES forKey:@"isLogin"];
        [UserDefaults setObject:self.userInfoHash forKey:@"userInfoHash"];
        [UserDefaults synchronize];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate setRootVC];
        [MBProgressHUD showSuccess:@"创建账户成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"注册失败!"];
    } message:nil];
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
}

-(void)keyWillHiden:(NSNotification *)noti
{
    [self.view removeGestureRecognizer:self.keyboardResignTap];
}

- (NSString *)getPublicKey:(NSData *)aData
{
    //Byte数组－>16进制数
    
    Byte *bytes = (Byte *)[aData bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[aData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
//    NSLog(@"publicKey bytes 的16进制数为:%@",hexStr);
    return hexStr;
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
