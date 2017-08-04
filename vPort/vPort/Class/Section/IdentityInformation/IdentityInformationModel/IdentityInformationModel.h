//
//  IdentityInformationModel.h
//  vPort
//
//  Created by MengFanJun on 2017/7/3.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseModel.h"

@interface IdentityInformationModel : BaseModel

/*
 唯一标识
 */
@property (nonatomic, copy) NSString *identityInformation_id;

/*
 姓名
 */
@property (nonatomic, copy) NSString *name;

/*
 性别
 */
@property (nonatomic, copy) NSString *gender;

/*
 身份证号
 */
@property (nonatomic, copy) NSString *identityInformationNumber;

/*
 有效期开始日期
 */
@property (nonatomic, copy) NSString *identityInformationBeginDate;

/*
 有效期结束日期
 */
@property (nonatomic, copy) NSString *identityInformationFinishDate;

/*
 签发机关
 */
@property (nonatomic, copy) NSString *issuingAuthority;

/*
 身份证认证状态
 1、或者空:待认证
 2:认证成功
 3:认证中
 4:认证失败
 */
@property (nonatomic, copy) NSString *identityInformationStatus;

/*
 身份证声明后，发送给服务器的参数
 */
@property (nonatomic, copy) NSString *claimToken;

/*
 attestationJWT，授权时JWT
 */
@property (nonatomic, copy) NSString *attestationJWT;

/*
 时间
 */
@property (nonatomic, copy) NSString *time;


@end
