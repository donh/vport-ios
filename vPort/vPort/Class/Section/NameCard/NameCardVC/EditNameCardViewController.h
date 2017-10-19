//
//  EditNameCardViewController.h
//  vPort
//
//  Created by MengFanJun on 2017/7/10.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseVC.h"

@interface EditNameCardViewController : BaseVC

@property (nonatomic, copy) NSString *nameCardInfoStr;//用户信息
@property (nonatomic, copy) void (^changeNameCardInfo)(NSString *nameCardInfoStr);
@property (nonatomic, strong) NSMutableDictionary *nameCardInfoDic;//个人信息数据源

@end
