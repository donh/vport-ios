//
//  NameCardViewController.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "NameCardViewController.h"
#import "BaseNavigationView.h"
#import "UserHeadImageTableViewCell.h"
#import "NameCardTableViewCell.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
#import "UIImage+ImageUpright.h"
#import "SignTool.h"
#import "EditNameCardViewController.h"

@interface NameCardViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) BaseNavigationView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *informationArray;//标题数据源
@property (nonatomic, strong) NSMutableDictionary *informationDic;//个人信息数据源
@property (nonatomic, strong) UIImage *selectedHeadImage;//ImagePicker选择的图片
@property (nonatomic, strong) NSMutableDictionary *valueDic;//个人信息数据源

@property (nonatomic, copy) NSString *userImageUrl;
@property (nonatomic, copy) NSString *userInfoHash;

@end

@implementation NameCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.informationArray = @[@"头像",@"昵称",@"vPortID",@"公钥"];
    self.informationDic = @{@"头像":@"",@"昵称":@"",@"vPortID":@"",@"公钥":@""}.mutableCopy;
    self.valueDic = [NSMutableDictionary dictionary];
    
    [self creatNavigation];
    [self creatSubViews];
    [self getUserInforData];
    
//    [self registryGet];
    
}

- (void)registryGet
{
    //registry/get接口
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"senderAddress"] = [[SignTool shareSignTool] getAddress];
    parametersDic[@"proxyAddress"] = [UserDefaults objectForKey:@"proxy"];
    parametersDic[@"registrationIdentifier"] = RegistrationIdentifier;
    [NetworkFactory postRequestWithMethod:@"http://58.83.219.133:9487/vport/registry/get" parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD showError:@""];
    } message:@"加载中..."];
    
}

- (void)getUserInforData
{
    NSString *hashStr = [UserDefaults objectForKey:@"userInfoHash"];
    NSString *contentUrlStr = [NSString stringWithFormat:@"%@%@",IPFSGetUrl,hashStr];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [NetworkFactory getRequestWithMethod:contentUrlStr parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.valueDic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *imageDicStr = self.valueDic[@"image"];
        NSString *headImageUrl = @"";
        if (imageDicStr) {
            NSDictionary *imageDic = [imageDicStr mj_JSONObject];
            headImageUrl = [NSString stringWithFormat:@"http://58.83.219.152:8080%@",imageDic[@"contentUrl"]];
        }
        [self.informationDic setObject:self.valueDic[@"name"] forKey:@"昵称"];
        [self.informationDic setObject:headImageUrl forKey:@"头像"];
        [self.informationDic setObject:self.valueDic[@"publicKey"] forKey:@"公钥"];
        [self.informationDic setObject:[UserDefaults objectForKey:@"proxy"] forKey:@"vPortID"];
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [MBProgressHUD showError:@""];
    } message:@"加载中..."];
}

//导航栏
- (void)creatNavigation
{
    self.customNaviView = [[BaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.customNaviView];
    self.customNaviView.titleLabel.text = @"名片";
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
    [_tableView registerClass:[UserHeadImageTableViewCell class] forCellReuseIdentifier:@"reuse1"];
    [_tableView registerClass:[NameCardTableViewCell class] forCellReuseIdentifier:@"reuse2"];
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
    if (indexPath.section == 0) {
        NSString *titleStr = self.informationArray[indexPath.row];
        if ([titleStr isEqualToString:@"头像"]) {
            UserHeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = titleStr;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.informationDic[titleStr]] placeholderImage:[UIImage imageNamed:@"userHeadImage"]];
//            if (self.selectedHeadImage == nil) {
//                //如果ImagePicker选择图片为空时
//            }
//            else
//            {
//                //如果ImagePicker选择图片不为空时
//                cell.headImage.image = self.selectedHeadImage;
//            }
            return cell;
        }
        else
        {
            NameCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = titleStr;
            cell.contentLabel.text = self.informationDic[titleStr];            
            if (indexPath.row == self.informationArray.count - 1) {
                cell.line.hidden = YES;
            }
            else
            {
                cell.line.hidden = NO;
            }
            if ([titleStr isEqualToString:@"昵称"]) {
                cell.moreImage.hidden = NO;
            }
            else
            {
                cell.moreImage.hidden = YES;
            }
            return cell;
        }
    }
    return nil;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 76;
        }
        return 56;
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
    
    NSString *titleStr = self.informationArray[indexPath.row];
    if ([titleStr isEqualToString:@"头像"]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择" ,nil];
        sheet.tag = 2000;
        [sheet showInView:self.view];
    }
    else if ([titleStr isEqualToString:@"昵称"])
    {
        EditNameCardViewController *editNameCardViewController = [[EditNameCardViewController alloc] init];
        editNameCardViewController.nameCardInfoDic = self.valueDic;
        __block NameCardViewController *weakSelf = self;
        editNameCardViewController.changeNameCardInfo = ^(NSString *nameCardInfoStr) {
            [weakSelf.informationDic setObject:nameCardInfoStr forKey:@"昵称"];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:editNameCardViewController animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
            
        case 2000:
            switch (buttonIndex) {
                case 0:
                    //弹出相册 从相机中选取
                    [self imagePickerShow:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:
                    //弹出相册 从相册中选取
                    [self imagePickerShow:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}

//弹出相机或相册
-(void)imagePickerShow:(UIImagePickerControllerSourceType )type;
{
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        picker.sourceType =type;
        [self presentViewController:picker animated:YES completion:nil];
        if (type == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
            [self photoLibraryStatus];
        }
        else if (type == UIImagePickerControllerSourceTypeCamera)
        {
            [self cameraStatus];
        }
    }else{
        [MBProgressHUD showError:@"设备相机不可用"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [image normalizedImage];
    UIImage *tempImage = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData.length/1000 > 3*1024) {
        [MBProgressHUD showError:@"所选图片过大，请重新选择"];
        return;
    }
    while (imageData.length/1000.0/1024.0 >= 1) {
        imageData = UIImageJPEGRepresentation(tempImage, 0.5);
        tempImage = [[UIImage alloc] initWithData:imageData];
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    NSString *savePath = [NSString stringWithFormat:@"%@/tmp/thumb_pic.jpeg",NSHomeDirectory()];
    NSLog(@"%@",savePath);
    
    if ([imageData writeToFile:savePath atomically:YES]) {
        self.selectedHeadImage = image;
        [self uploadHeadImageWithSavePath:savePath];
    }
    else
    {
        [MBProgressHUD showError:@"所选图片过大，请重新选择"];
    }
}

//判断相册权限
-(void)photoLibraryStatus
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    switch (author) {
        case ALAuthorizationStatusNotDetermined:{
            NSLog(@"系统还未知是否访问，第一次开启相册时");
            return;
            break;
        }
            
        case ALAuthorizationStatusRestricted:{
            NSLog(@"你的权限受限");
            NSString *tips = @"你的权限受限";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
            break;
        }
            
        case ALAuthorizationStatusDenied:{
            NSLog(@"相册不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限");
            NSString *tips = @"请授权VPort可以访问相册\n设置方式:手机设置->隐私->照片";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
            alert.tag = 100;
            return;
            break;
        }
            
        case ALAuthorizationStatusAuthorized:
            NSLog(@"相册允许状态");
            return;
            break;
            
        default:
            break;
    }
}


//判断相机权限
-(void)cameraStatus
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (author) {
        case ALAuthorizationStatusNotDetermined:{
            NSLog(@"系统还未知是否访问，第一次开启相机时");
            return;
            break;
        }
            
        case ALAuthorizationStatusRestricted:{
            NSLog(@"你的权限受限");
            NSString *tips = @"你的权限受限";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
            break;
        }
            
        case ALAuthorizationStatusDenied:{
            NSLog(@"相机不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限");
            NSString *tips = @"请授权VPort可以访问相机\n设置方式:手机设置->隐私->相机";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
            alert.tag = 100;
            return;
            break;
        }
            
        case ALAuthorizationStatusAuthorized:
            NSLog(@"相册允许状态");
            return;
            break;
            
        default:
            break;
    }
}

#pragma mark ** 图片上传
- (void)uploadHeadImageWithSavePath:(NSString *)savePath
{
    if (self.valueDic.count == 0) {
        [MBProgressHUD showError:@"上传头像失败"];
        return;
    }
    [MBProgressHUD showMessage:@"上传头像中..."];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/v0/add",IPFSAddUrl];
    
    [NetworkFactory uploadFielWithMethod:urlStr parameters:parametersDic andPath:savePath success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *Hash = responseObject[@"Hash"];
        NSString *contentUrl = [NSString stringWithFormat:@"/ipfs/%@",Hash];
        self.userImageUrl = contentUrl;
        NSDictionary *imageDic = @{@"@type":@"ImageObject",@"name":@"avatar",@"contentUrl":contentUrl};
        [self.valueDic setObject:[imageDic mj_JSONString] forKey:@"image"];
        [self uploadContentStrWithValueDic:self.valueDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"头像上传失败"];
    } message:nil];

}

- (void)uploadContentStrWithValueDic:(NSMutableDictionary *)valueDic
{
    NSString *savePath = [NSString stringWithFormat:@"%@/tmp/contentStr.txt",NSHomeDirectory()];
    NSString *valueStr = [valueDic mj_JSONString];
    
    if (![valueStr writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"上传头像失败!"];
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
        [MBProgressHUD showError:@"上传头像失败!"];
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
        __weak NameCardViewController *weakSelf = self;
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
                [MBProgressHUD showError:@"上传头像失败!"];
            }
        };
        [SignTool shareSignTool].SignedBlock = ^(NSString *signedTx) {
            [weakSelf transactionSendWithTxStr:signedTx];
        };
        
        NSString *rawTx = responseObject[@"rawTx"];
        [[SignTool shareSignTool] singWithTxStr:rawTx];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"上传头像失败!"];
    } message:nil];
    
}

- (void)transactionSendWithTxStr:(NSString *)txStr
{
    //transaction/send接口
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"rawTxSigned"] = txStr;
    [NetworkFactory postRequestWithMethod:[NSString stringWithFormat:@"%@/vchain/transaction/send",vPortUrl] parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"上传头像成功!"];
        
        [UserDefaults setObject:self.userImageUrl forKey:@"userImageUrl"];
        [UserDefaults setObject:self.userInfoHash forKey:@"userInfoHash"];
        [UserDefaults synchronize];
        NSString *headImageUrl = [NSString stringWithFormat:@"http://58.83.219.152:8080%@",self.userImageUrl];
        [self.informationDic setObject:headImageUrl forKey:@"头像"];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"上传头像失败!"];
    } message:nil];
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
