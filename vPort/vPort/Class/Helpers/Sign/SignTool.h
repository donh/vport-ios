//
//  SignTool.h
//  VPort
//
//  Created by MengFanJun on 2017/6/12.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTHDAccountCold.h"

@interface SignTool : NSObject

+ (instancetype)shareSignTool;

@property (nonatomic, copy) NSString *passWordStr;
@property (nonatomic, strong) BTHDAccountCold *secretKey;
@property (nonatomic,copy) void(^SignedBlock)(NSString *signedTx);
@property (nonatomic,copy) void(^SignedErrorBlock)();

- (void)creatSecretKey;
- (NSString *)getAddress;
- (NSString *)getPublicKey;

//使用秘钥对字符串进行签名
- (void)singWithTxStr:(NSString *)txStr;

//将JWT字符串转换为json对象
- (void)decodeTokenWithJWTStr:(NSString *)JWTStr;
@property (nonatomic,copy) void(^DecodeTokenBlock)(NSDictionary *resultDic);

//对json对象进行JWT签名
- (void)signTokenWithJWTDic:(NSMutableDictionary *)dic;
@property (nonatomic,copy) void(^SignTokenBlock)(NSString *JWTStr);

//对JWT字符串进行验签
- (void)verifyTokenWithJWTStr:(NSString *)JWTStr andPublicKey:(NSString *)publicKey;
@property (nonatomic,copy) void(^VerifyTokenBlock)(BOOL resultBool);


@end
