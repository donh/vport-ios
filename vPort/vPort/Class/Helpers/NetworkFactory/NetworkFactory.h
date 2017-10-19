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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface NetworkFactory : NSObject

//请求POST网络请求
+(void)postRequestWithMethod:(NSString *)method  parameters:(NSMutableDictionary *)parameters success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message;

//请求GET网络请求
+(void)getRequestWithMethod:(NSString *)method  parameters:(NSMutableDictionary *)parameters success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message;

//vPort服务器json格式接口
+(void)postRequestWithVPortMethod:(NSString *)method  parameters:(NSMutableDictionary *)parameters success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message;

//上传文件
+(void)uploadFielWithMethod:(NSString *)method parameters:(NSMutableDictionary *)parameters andPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure :(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock message:(NSString *)message;

@end
