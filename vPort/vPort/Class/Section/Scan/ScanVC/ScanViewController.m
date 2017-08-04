//
//  ScanViewController.m
//  VPort
//
//  Created by MengFanJun on 2017/6/14.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "ScanViewController.h"
#import "BaseNavigationView.h"
#import <AVFoundation/AVFoundation.h>
#import "ConfirmLoginView.h"
#import "AuthorizedView.h"
#import "SignTool.h"
#import "DataBaseTool.h"
#import "OperateRecordModel.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, ConfirmLoginViewDelegate, AuthorizedViewDelegate>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
/** 捕捉会话 */
@property (nonatomic, weak) AVCaptureSession *session;
/** 预览图层 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) BaseLabel *reminderLabel;
//@property (nonatomic, strong) UIButton *myQRCodeBtn;
@property (nonatomic, copy) NSString *scanJWTStr;
@property (nonatomic, strong) NSMutableDictionary *scanResultDic;
@property (nonatomic, strong) IdentityInformationModel *identityInformationModel;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanResultDic = [NSMutableDictionary dictionary];
    
    // 扫描二维码
    [self scanCIQRCode];
    
    [self creatNavigation];
    [self creatSubViews];
    
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    self.customNaviView.titleLabel.text = @"扫一扫";
    [self.customNaviView.leftBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

//返回按钮
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatSubViews
{
    
    UIView *blackViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.centerImageView.frame.origin.y - 64)];
    [self.view addSubview:blackViewOne];
    blackViewOne.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    UIView *blackViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, self.centerImageView.frame.origin.y, self.centerImageView.frame.origin.x, self.centerImageView.frame.size.height)];
    [self.view addSubview:blackViewTwo];
    blackViewTwo.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    UIView *blackViewThree = [[UIView alloc] initWithFrame:CGRectMake(self.centerImageView.frame.origin.x + self.centerImageView.frame.size.width, self.centerImageView.frame.origin.y, self.view.frame.size.width - (self.centerImageView.frame.origin.x + self.centerImageView.frame.size.width), self.centerImageView.frame.size.height)];
    [self.view addSubview:blackViewThree];
    blackViewThree.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    UIView *blackViewFour = [[UIView alloc] initWithFrame:CGRectMake(0, self.centerImageView.frame.size.height + self.centerImageView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (self.centerImageView.frame.origin.y + self.centerImageView.frame.size.height))];
    [self.view addSubview:blackViewFour];
    blackViewFour.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    self.reminderLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(0, self.centerImageView.frame.origin.y + self.centerImageView.frame.size.height + 45, self.view.frame.size.width, 13)];
    [self.view addSubview:self.reminderLabel];
    self.reminderLabel.textColor = [UIColor colorWithHexString:@"cccccc" alpha:1];
    self.reminderLabel.font = [UIFont systemFontOfSize:12];
    self.reminderLabel.text = @"将二维码放入框中，即可自动扫描";
    self.reminderLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.myQRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:self.myQRCodeBtn];
//    self.myQRCodeBtn.frame = CGRectMake(0, self.view.frame.size.height - 90, 100, 30);
//    self.myQRCodeBtn.center = CGPointMake(self.view.center.x, self.myQRCodeBtn.center.y);
//    self.myQRCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//    [self.myQRCodeBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
//    [self.myQRCodeBtn setTitleColor:[UIColor colorWithHexString:@"cccccc" alpha:1] forState:UIControlStateNormal];
//    self.myQRCodeBtn.layer.borderWidth = 0.5;
//    self.myQRCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"cccccc" alpha:1].CGColor;
//    self.myQRCodeBtn.layer.cornerRadius = 4;
//    self.myQRCodeBtn.layer.masksToBounds = YES;
//    [self.myQRCodeBtn addTarget:self action:@selector(myQRCodeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  扫描二维码
 */
- (void)scanCIQRCode
{
    // 1. 创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    // 2. 添加输入设备(数据从摄像头输入)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    // 3. 添加输出数据接口
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置输出接口代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    // 3.1 设置输入元数据的类型(类型是二维码数据)
    // 注意，这里必须设置在addOutput后面，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 4.添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.64 * self.view.frame.size.width, 0.64 * self.view.frame.size.width)];
    self.centerImageView.image = [UIImage imageNamed:@"contact_scanframe"];
    self.centerImageView.center = self.view.center;
    [self.view addSubview:self.centerImageView];
    
    // 1.获取屏幕的frame
    CGRect viewRect = self.view.frame;
    // 2.获取扫描容器的frame
    CGRect containerRect = self.centerImageView.frame;
    CGFloat x = containerRect.origin.y / viewRect.size.height;
    CGFloat y = containerRect.origin.x / viewRect.size.width;
    CGFloat width = containerRect.size.height / viewRect.size.height;
    CGFloat height = containerRect.size.width / viewRect.size.width;
    output.rectOfInterest = CGRectMake(x, y, width, height);
    
    // 5. 开始扫描
    [session startRunning];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count) {// 扫描到了数据
        // 停止扫描
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects lastObject];
        NSString *stringValue = metadataObject.stringValue;
        NSLog(@"%@",stringValue);
        self.scanJWTStr = stringValue;
        [self decodeToken];
        
    }else{
        NSLog(@"没有扫描到数据");
    }
}

//将扫描得到的JWT字符串转换为json对象
- (void)decodeToken
{
    __weak ScanViewController *weakSelf = self;
    __block int errorNumber = 0;//签名有时会报错，有时重新签名会正确，当重新签名次数超过5次，停止
    [SignTool shareSignTool].SignedErrorBlock = ^{
        if (errorNumber < 5) {
            errorNumber++;
            [[SignTool shareSignTool] singWithTxStr:weakSelf.scanJWTStr];
        }
        else{
            [weakSelf showQRCodeError];
        }
    };
    [SignTool shareSignTool].DecodeTokenBlock = ^(NSDictionary *resultDic) {
        NSLog(@"resultDic:%@",resultDic);
        weakSelf.scanResultDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        [weakSelf verifyToken];
    };
    
    [[SignTool shareSignTool] decodeTokenWithJWTStr:self.scanJWTStr];
    
}

//对扫描得到的JWT字符串进行验签
- (void)verifyToken
{
    NSString *publicKey = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"serverPublicKey"]];
    __weak ScanViewController *weakSelf = self;
    __weak NSString *weakPublicKey = publicKey;
    __block int errorNumber = 0;//签名有时会报错，有时重新签名会正确，当重新签名次数超过5次，停止
    [SignTool shareSignTool].SignedErrorBlock = ^{
        if (errorNumber < 5) {
            errorNumber++;
            [[SignTool shareSignTool] verifyTokenWithJWTStr:weakSelf.scanJWTStr andPublicKey:weakPublicKey];
        }
        else{
            [weakSelf showQRCodeError];
        }
    };
    [SignTool shareSignTool].VerifyTokenBlock = ^(BOOL resultBool) {
        NSLog(@"resultBool:%d",resultBool);
        if (resultBool) {
            [weakSelf verifyTokenSuccess];
        }
        else
        {
            [weakSelf showQRCodeError];
        }
    };
    
    [[SignTool shareSignTool] verifyTokenWithJWTStr:self.scanJWTStr andPublicKey:publicKey];
    
}

//对json对象进行JWT签名
- (void)signTokenWithJWTDic:(NSMutableDictionary *)dic;
{
    __weak ScanViewController *weakSelf = self;
    __weak NSMutableDictionary *weakDic = dic;
    __block int errorNumber = 0;//签名有时会报错，有时重新签名会正确，当重新签名次数超过5次，停止
    [SignTool shareSignTool].SignedErrorBlock = ^{
        if (errorNumber < 5) {
            errorNumber++;
            [weakSelf signTokenWithJWTDic:weakDic];
        }
        else{
            [weakSelf showQRCodeError];
        }
    };
    [SignTool shareSignTool].SignTokenBlock = ^(NSString *JWTStr) {
        NSLog(@"result:%@",JWTStr);
        [weakSelf signTokenSuccessWithJWTStr:JWTStr];
    };
    
    [[SignTool shareSignTool] signTokenWithJWTDic:dic];
    
}

//验签成功后，根据sub判断执行动作
- (void)verifyTokenSuccess
{
    NSString *subStr = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"sub"]];
    if ([subStr isEqualToString:@"login token"]) {
        //登录
        ConfirmLoginView *confirmLoginView = [[ConfirmLoginView alloc] initWithDelegate:self];
        confirmLoginView.contentStr = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"clientName"]];
        [confirmLoginView show];
    }
    else if ([subStr isEqualToString:@"claim token"]) {
        //声明、认证
        self.identityInformationModel = [self getIdentityInformation];
        if (self.identityInformationModel) {
            if ([self.identityInformationModel.identityInformationStatus isEqualToString:@"2"] || [self.identityInformationModel.identityInformationStatus isEqualToString:@"3"]) {
                [MBProgressHUD showError:@"请勿重复声明身份证"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([self.identityInformationModel.identityInformationStatus isEqualToString:@"4"])
            {
                [MBProgressHUD showError:@"认证失败，请检查身份证信息"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                AuthorizedView *authorizedView = [[AuthorizedView alloc] initWithDelegate:self];
                authorizedView.typeStr = @"声明";
                authorizedView.webNameStr = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"clientName"]];
                [authorizedView show];
            }
        }
        else
        {
            [MBProgressHUD showError:@"暂无声明信息"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([subStr isEqualToString:@"authorization request"]) {
        self.identityInformationModel = [self getIdentityInformation];
        if (self.identityInformationModel && [self.identityInformationModel.identityInformationStatus isEqualToString:@"2"])
        {
            //存在身份证，并且认证成功
            AuthorizedView *authorizedView = [[AuthorizedView alloc] initWithDelegate:self];
            authorizedView.typeStr = @"授权";
            authorizedView.webNameStr = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"requesterName"]];
            [authorizedView show];
        }
        else
        {
            [MBProgressHUD showError:@"暂无授权信息"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//生成新的JWT成功后，根据sub判断执行动作
- (void)signTokenSuccessWithJWTStr:(NSString *)JWTStr
{
    NSString *subStr = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"sub"]];
    if ([subStr isEqualToString:@"login token"]) {
        //登录
        NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
        parametersDic[@"userJWT"] = JWTStr;
        [NetworkFactory postRequestWithVPortMethod:LoginUrl parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"][@"valid"] boolValue]) {
                [MBProgressHUD showSuccess:@"登录成功"];
                //登录成功后，存入操作记录
                [self addOperateRecordWithOperateRecordeType:@"1" andOperateRecordeStatus:@"1" andOperateRecordeInfo:self.scanResultDic[@"payload"][@"context"][@"clientName"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [MBProgressHUD showError:@"登录失败"];
                //登录失败后，存入操作记录
                [self addOperateRecordWithOperateRecordeType:@"1" andOperateRecordeStatus:@"2" andOperateRecordeInfo:self.scanResultDic[@"payload"][@"context"][@"clientName"]];
                [self.session startRunning];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@""];
        } message:@"正在登录..."];
    }
    else if ([subStr isEqualToString:@"claim token"])
    {
        //声明
        NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
        parametersDic[@"claimJWT"] = JWTStr;
        [NetworkFactory postRequestWithVPortMethod:ClaimUrl parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"][@"valid"] boolValue]) {
                [MBProgressHUD showSuccess:@"声明成功"];
                //声明成功后，存入操作记录
                [self addOperateRecordWithOperateRecordeType:@"4" andOperateRecordeStatus:@"1" andOperateRecordeInfo:@"身份证"];
                self.identityInformationModel.identityInformationStatus = @"3";
                [[DataBaseTool shareDataBaseTool] updateIdentityInformationWithModel:self.identityInformationModel];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD showError:@"声明失败"];
                //声明失败后，存入操作记录
                [self addOperateRecordWithOperateRecordeType:@"4" andOperateRecordeStatus:@"2" andOperateRecordeInfo:@"身份证"];
                [self.session startRunning];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@""];
        } message:@"正在声明..."];
    }
    else if ([subStr isEqualToString:@"authorization request"])
    {
        //授权
        NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
        parametersDic[@"authorizationJWT"] = JWTStr;
        [NetworkFactory postRequestWithVPortMethod:AuthorizedUrl parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"][@"valid"] boolValue]) {
                [MBProgressHUD showSuccess:@"授权成功"];
                //授权成功后，存入操作记录
                [self addOperateRecordWithOperateRecordeType:@"2" andOperateRecordeStatus:@"1" andOperateRecordeInfo:@"身份证"];
                [[DataBaseTool shareDataBaseTool] updateIdentityInformationWithModel:self.identityInformationModel];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD showError:@"授权失败"];
                //授权失败后，存入操作记录
                [self addOperateRecordWithOperateRecordeType:@"2" andOperateRecordeStatus:@"2" andOperateRecordeInfo:@"身份证"];
                [self.session startRunning];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@""];
        } message:@"正在授权..."];
    }

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
    NSString *webUrl = @"";
    NSString *webName = self.scanResultDic[@"payload"][@"context"][@"clientName"];
    if ([operateRecordeType isEqualToString:@"1"]) {
        webUrl = LoginUrl;
    }
    else if ([operateRecordeType isEqualToString:@"2"]) {
        webUrl = AuthorizedUrl;
        webName = self.scanResultDic[@"payload"][@"context"][@"requesterName"];
    }
    else if ([operateRecordeType isEqualToString:@"4"]) {
        webUrl = ClaimUrl;
    }
    NSMutableDictionary *dic = @{@"userName":userName,
                                 @"userImageUrl":headImageUrl,
                                 @"operateRecordeType":operateRecordeType,
                                 @"operateRecordeStatus":operateRecordeStatus,
                                 @"operateRecordeInfo":operateRecordeInfo,
                                 @"webImageUrl":@"",
                                 @"webUrl":webUrl,
                                 @"webName":webName
                                 }.mutableCopy;
    
    OperateRecordModel *operateRecordModel = [[OperateRecordModel alloc] initWithDict:dic];
    [[DataBaseTool shareDataBaseTool] insertOperateRecordWithModel:operateRecordModel];
    
}

#pragma mark ** 登录
- (void)confirmLoginView:(ConfirmLoginView *)confirmLoginView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addOperateRecordWithOperateRecordeType:@"1" andOperateRecordeStatus:@"3" andOperateRecordeInfo:self.scanResultDic[@"payload"][@"context"][@"clientName"]];
        [self.session startRunning];
    }
    else if (buttonIndex == 1)
    {
        NSMutableDictionary *contextDic = [NSMutableDictionary dictionary];
        [contextDic setObject:@"name,publicKey,proxy" forKey:@"scope"];
        [contextDic setObject:[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"token"]] forKey:@"token"];
        [contextDic setObject:[UserDefaults objectForKey:@"proxy"] forKey:@"userProxy"];
        [contextDic setObject:[[SignTool shareSignTool] getPublicKey] forKey:@"userPublicKey"];
        [self creatSignTokenDicWithContextDic:contextDic andSubStr:@"login token signed"];
    }
}

#pragma mark ** 声明、授权
- (void)authorizedView:(AuthorizedView *)authorizedView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *subStr = [NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"sub"]];
    if ([subStr isEqualToString:@"claim token"])
    {
        //声明
        if (buttonIndex == 0) {
            [self addOperateRecordWithOperateRecordeType:@"4" andOperateRecordeStatus:@"3" andOperateRecordeInfo:@"身份证"];
            [self.session startRunning];
        }
        else if (buttonIndex == 1)
        {
            NSMutableDictionary *contextDic = [NSMutableDictionary dictionary];
            
            [contextDic setObject:self.identityInformationModel.name forKey:@"name"];
            [contextDic setObject:self.identityInformationModel.gender forKey:@"gender"];
            [contextDic setObject:self.identityInformationModel.identityInformationNumber forKey:@"ID"];
            [contextDic setObject:self.identityInformationModel.identityInformationBeginDate forKey:@"issueDate"];
            [contextDic setObject:self.identityInformationModel.identityInformationFinishDate forKey:@"expiryDate"];
            [contextDic setObject:self.identityInformationModel.issuingAuthority forKey:@"authority"];
            
            [contextDic setObject:[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"token"]] forKey:@"token"];
            [contextDic setObject:[UserDefaults objectForKey:@"proxy"] forKey:@"userProxy"];
            [contextDic setObject:[[SignTool shareSignTool] getPublicKey] forKey:@"userPublicKey"];
            [self creatSignTokenDicWithContextDic:contextDic andSubStr:@"claim for ID"];
        }
    }
    else if ([subStr isEqualToString:@"authorization request"])
    {
        //授权
        if (buttonIndex == 0) {
            [self addOperateRecordWithOperateRecordeType:@"2" andOperateRecordeStatus:@"3" andOperateRecordeInfo:@"身份证"];
            [self.session startRunning];
        }
        else if (buttonIndex == 1)
        {
            NSMutableDictionary *contextDic = [NSMutableDictionary dictionary];
            
            [contextDic setObject:[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"scope"]] forKey:@"scope"];
            [contextDic setObject:[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"context"][@"token"]] forKey:@"token"];
            [contextDic setObject:[UserDefaults objectForKey:@"proxy"] forKey:@"userProxy"];
            [contextDic setObject:[[SignTool shareSignTool] getPublicKey] forKey:@"userPublicKey"];
            [self creatSignTokenDicWithContextDic:contextDic andSubStr:@"authorization"];
        }
    }
}

- (void)creatSignTokenDicWithContextDic:(NSMutableDictionary *)contextDic andSubStr:(NSString *)subStr
{
    NSMutableDictionary *payloadDic = [NSMutableDictionary dictionary];
    [payloadDic setObject:[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"aud"]] forKey:@"iss"];
    [payloadDic setObject:[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"iss"]] forKey:@"aud"];
    [payloadDic setObject:[NSNumber numberWithInteger:[[self getTimer] integerValue]] forKey:@"iat"];
    [payloadDic setObject:[NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@",self.scanResultDic[@"payload"][@"exp"]] integerValue]] forKey:@"exp"];
    [payloadDic setObject:subStr forKey:@"sub"];
    
    [payloadDic setObject:contextDic forKey:@"context"];

    [self signTokenWithJWTDic:payloadDic];

}

//二维码格式不正确
- (void)showQRCodeError
{
    [MBProgressHUD showError:@"二维码错误，请重新扫描"];
    [self.session startRunning];
}

//获取用户身份证信息
- (IdentityInformationModel *)getIdentityInformation
{
    NSString *querySQL = [NSString stringWithFormat:@"select * from identityInformationTable order by identityInformation_id asc"];
    NSMutableArray *array = [[DataBaseTool shareDataBaseTool] selectIdentityInformationModelWithQuerySQL:querySQL];
    if (array.count == 0) {
        return nil;
    }
    IdentityInformationModel *identityInformationModel = array[0];
    return identityInformationModel;
}

- (void)myQRCodeBtnClicked
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
