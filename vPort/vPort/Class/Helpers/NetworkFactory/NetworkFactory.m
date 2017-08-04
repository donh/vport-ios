/*
 * Copyright (C) 2016-2016, The Little-Sparkle Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS-IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "NetworkFactory.h"
#import "AppDelegate.h"

@implementation NetworkFactory

+(void)postRequestWithMethod:(NSString *)method  parameters:(NSMutableDictionary *)parameters success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message
{
    void (^excuteBlock)() = ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) ? ^{
        [MBProgressHUD showError:@"请检查网络连接"];
    } : ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIWindow *window = delegate.window;
        if (message != nil) {
            [MBProgressHUD showMessage:message toView:window];
        }
        
        //创建请求 并设置Content-Type 字符集
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
        reqSerializer.timeoutInterval = NetworkTimeOut;
        [reqSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = reqSerializer;
        NSMutableSet *acceptSet= [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [acceptSet addObject:@"text/plain"];
        [acceptSet addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = acceptSet;
        
        //请求URL
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,method];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@接口result:%@",method,responseObject);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (successBlock) {
                successBlock(operation,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (error.code == -1001) {
                [MBProgressHUD showError:@"请求超时"];
            }else if (error.code == -1004) {
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }else if (error.code == 3840) {
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }else if (error.code == -1009)
            {
                [MBProgressHUD showError:@"请检查网络连接"];
            }else{
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }
            if (failureBlock) {
                failureBlock(operation,error);
            }
        }];
    };
    if (excuteBlock) {
        excuteBlock();
    }
}

+(void)getRequestWithMethod:(NSString *)method  parameters:(NSMutableDictionary *)parameters success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message
{
    void (^excuteBlock)() = ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) ? ^{
        [MBProgressHUD showError:@"请检查网络连接"];
    } : ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIWindow *window = delegate.window;
        if (message != nil) {
            [MBProgressHUD showMessage:message toView:window];
        }
        
        //创建请求 并设置Content-Type 字符集
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *reqSerializer = [AFHTTPRequestSerializer serializer];
        reqSerializer.timeoutInterval = NetworkTimeOut;
        [reqSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = reqSerializer;
        NSMutableSet *acceptSet= [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [acceptSet addObject:@"text/plain"];
        [acceptSet addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = acceptSet;

        //请求URL
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,method];
        
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@接口result:%@",method,responseObject);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (successBlock) {
                successBlock(operation,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (error.code == -1001) {
                [MBProgressHUD showError:@"请求超时"];
            }else if (error.code == -1004) {
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }else if (error.code == 3840) {
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }else if (error.code == -1009)
            {
                [MBProgressHUD showError:@"请检查网络连接"];
            }else{
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }
            if (failureBlock) {
                failureBlock(operation,error);
            }
        }];
    };
    if (excuteBlock) {
        excuteBlock();
    }
}

+(void)postRequestWithVPortMethod:(NSString *)method  parameters:(NSMutableDictionary *)parameters success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message
{
    void (^excuteBlock)() = ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) ? ^{
        [MBProgressHUD showError:@"请检查网络连接"];
    } : ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIWindow *window = delegate.window;
        if (message != nil) {
            [MBProgressHUD showMessage:message toView:window];
        }
        
        //创建请求 并设置Content-Type 字符集
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer= [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = NetworkTimeOut;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        //请求URL
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,method];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@接口result:%@",method,responseObject);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (successBlock) {
                successBlock(operation,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (error.code == -1001) {
                [MBProgressHUD showError:@"请求超时"];
            }else if (error.code == -1004) {
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }else if (error.code == 3840) {
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }else if (error.code == -1009)
            {
                [MBProgressHUD showError:@"请检查网络连接"];
            }else{
                [MBProgressHUD showError:@"服务器开小差了o(>﹏<)o"];
            }
            if (failureBlock) {
                failureBlock(operation,error);
            }
        }];
    };
    if (excuteBlock) {
        excuteBlock();
    }
}

+(void)uploadFielWithMethod:(NSString *)method parameters:(NSMutableDictionary *)parameters andPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message
{
    void (^excuteBlock)() = ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) ? ^{
        [MBProgressHUD showError:@"请检查网络连接"];
    } : ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIWindow *window = delegate.window;
        if (message != nil) {
            [MBProgressHUD showMessage:message toView:window];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //添加可以接受的返回类型
        NSMutableSet *acceptSet= [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [acceptSet addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = acceptSet;
        [manager POST:method parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@接口result:%@",method,responseObject);
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (successBlock) {
                successBlock(operation,responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:window animated:NO];
            if (failureBlock) {
                failureBlock(operation,error);
            }
        }];
    };
    
    if (excuteBlock) {
        excuteBlock();
    }

}

@end
