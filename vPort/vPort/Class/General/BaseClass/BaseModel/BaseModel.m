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

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未识别key...%@",key);
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        NSArray *keyArray = dict.allKeys;
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        for (NSString *keyStr in keyArray) {
            NSString *valueStr = [NSString stringWithFormat:@"%@",dict[keyStr]];
            if ([valueStr isEqualToString:@"(null)"]) {
                valueStr = @"";
            }
            [newDic setObject:valueStr forKey:keyStr];
        }
        [self setValuesForKeysWithDictionary:newDic];
    }
    return self;
}

@end
