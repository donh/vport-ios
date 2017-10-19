//
//  SignTool.m
//  VPort
//
//  Created by MengFanJun on 2017/6/12.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "SignTool.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SignTool () <UIWebViewDelegate>

@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SignTool


+ (instancetype)shareSignTool
{
    static SignTool *signTool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signTool = [[SignTool alloc] init];
        [signTool creatWebView];
        [signTool creatSecretKey];
    });
    return signTool;
}

- (void)creatWebView
{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        self.webView.delegate = self;
    }
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)creatSecretKey
{
    NSString *HDAccountId = [UserDefaults objectForKey:@"HDAccountId"];
    if (HDAccountId.length != 0) {
        self.secretKey = [[BTHDAccountCold alloc] initWithSeedId:HDAccountId.intValue];
    }
//    NSArray *seedWords = [accountCold seedWords:self.passWordStr];
//    NSLog(@"words:%@",seedWords);
//    NSLog(@"privateKey:%@",btkey.key.privateKey);
//    NSLog(@"publicKey:%@",[self getPublicKey:btkey.pubKey]);
//    NSLog(@"address:%@",btkey.address);
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    __weak SignTool *weakSelf = self;
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息:%@", exceptionValue);
        if (weakSelf.SignedErrorBlock) {
            weakSelf.SignedErrorBlock();
        }
    };
    self.jsContext[@"jsError"] = ^{
        NSArray *arg = [JSContext currentArguments];
        for (JSValue *obj in arg) {
            NSLog(@"异常信息:%@", obj);
        }
        if (weakSelf.SignedErrorBlock) {
            weakSelf.SignedErrorBlock();
        }
    };
    self.jsContext[@"passValue"] = ^{
        NSArray *arg = [JSContext currentArguments];
        for (JSValue *obj in arg) {
            NSLog(@"passValue:%@", obj);
            if (weakSelf.SignedBlock) {
                weakSelf.SignedBlock(obj.toString);
            }
        }
    };
    self.jsContext[@"passSignTokenValue"] = ^{
        NSArray *arg = [JSContext currentArguments];
        for (JSValue *obj in arg) {
            NSLog(@"passSignTokenValue:%@", obj);
            if (weakSelf.SignTokenBlock) {
                weakSelf.SignTokenBlock(obj.toString);
            }
        }
    };
    self.jsContext[@"passDecodeTokenValue"] = ^{
        NSArray *arg = [JSContext currentArguments];
        for (JSValue *obj in arg) {
            NSLog(@"passDecodeTokenValue:%@", obj);
            if (weakSelf.DecodeTokenBlock) {
                weakSelf.DecodeTokenBlock(obj.toDictionary);
            }
        }
    };
    self.jsContext[@"passVerifyTokenValue"] = ^{
        NSArray *arg = [JSContext currentArguments];
        for (JSValue *obj in arg) {
            NSLog(@"passVerifyTokenValue:%@", obj);
            if (weakSelf.VerifyTokenBlock) {
                weakSelf.VerifyTokenBlock(obj.toBool);
            }
        }
    };
//    [self test];
}

//使用秘钥对字符串进行签名
- (void)singWithTxStr:(NSString *)txStr
{
    if (!self.secretKey) {
        return;
    }
    //第一个参数、第二个参数都加引号''
    NSString *jsStr = [NSString stringWithFormat:@"sign('%@','%@')",[self getPrivateKey],txStr];
    NSLog(@"jsStr:%@",jsStr);
    [self.jsContext evaluateScript:jsStr];

}

//将JWT字符串转换为json对象
- (void)decodeTokenWithJWTStr:(NSString *)JWTStr
{
    //参数加引号''
    NSString *jsStr = [NSString stringWithFormat:@"decodeToken('%@')",JWTStr];
    NSLog(@"jsStr:%@",jsStr);
    [self.jsContext evaluateScript:jsStr];
}

//对json对象进行JWT签名
- (void)signTokenWithJWTDic:(NSMutableDictionary *)dic
{
    //第一个参数加引号''，第二个参数不加引号''
    NSString *jsStr = [NSString stringWithFormat:@"signToken('%@',%@)",[self getRawPrivateKey],[dic mj_JSONString]];
    NSLog(@"jsStr:%@",jsStr);
    [self.jsContext evaluateScript:jsStr];
}

//对JWT字符串进行验签
- (void)verifyTokenWithJWTStr:(NSString *)JWTStr andPublicKey:(NSString *)publicKey
{
    //第一个参数、第二个参数都加引号''
    NSString *jsStr = [NSString stringWithFormat:@"verifyToken('%@','%@')",publicKey,JWTStr];
    NSLog(@"jsStr:%@",jsStr);
    [self.jsContext evaluateScript:jsStr];
}

- (NSString *)getPublicKey
{
    //Byte数组－>16进制数
    NSData *pubData = [self.secretKey masterKey:self.passWordStr].pubKey;
    Byte *bytes = (Byte *)[pubData bytes];
    NSString *publicKey=@"";
    for(int i=0;i<[pubData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            publicKey = [NSString stringWithFormat:@"%@0%@",publicKey,newHexStr];
        else
            publicKey = [NSString stringWithFormat:@"%@%@",publicKey,newHexStr];
    }
    return publicKey;
}

- (NSString *)getAddress
{
    return [self.secretKey masterKey:self.passWordStr].address;
}

- (NSString *)getPrivateKey
{
    return [self.secretKey masterKey:self.passWordStr].key.privateKey;
}

- (NSString *)getRawPrivateKey
{
    return [[self.secretKey masterKey:self.passWordStr].key rawPrivateKey];
}

- (void)test
{
    NSMutableDictionary *dic = @{
                                 @"iss": @"vport.chancheng.server",
                                 @"aud": @"vport.chancheng.user",
                                 @"iat": @1499839270,
                                 @"exp": @1499839570,
                                 @"sub": @"authorization request",
                                 @"context": @{
                                         @"requesterName": @"Citi",
                                         @"scope": @"ID,name,proxy",
                                         @"token": @"fca8d0adafaf4741b4f25cd9e8282b1f",
                                         @"serverPublicKey": [self getPublicKey]
                                     }
                                 }.mutableCopy;
    [self signTokenWithJWTDic:dic];
}

@end
