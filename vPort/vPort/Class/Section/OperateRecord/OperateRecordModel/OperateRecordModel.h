//
//  OperateRecordModel.h
//  vPort
//
//  Created by MengFanJun on 2017/6/29.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "BaseModel.h"

@interface OperateRecordModel : BaseModel

/*
 唯一标识
 */
@property (nonatomic, copy) NSString *operateRecord_id;
/*
 用户当时昵称
 */
@property (nonatomic, copy) NSString *userName;

/*
 用户当时头像
 */
@property (nonatomic, copy) NSString *userImageUrl;

/*
 操作类型
 1:登录
 2:授权
 3:认证
 4:声明
 */
@property (nonatomic, copy) NSString *operateRecordeType;

/*
 操作状态
 1:成功
 2:失败
 3:取消
 */
@property (nonatomic, copy) NSString *operateRecordeStatus;

/*
 操作信息
 */
@property (nonatomic, copy) NSString *operateRecordeInfo;

/*
 目标网站图片
 */
@property (nonatomic, copy) NSString *webImageUrl;

/*
 目标网站地址
 */
@property (nonatomic, copy) NSString *webUrl;

/*
 目标网站名字
 */
@property (nonatomic, copy) NSString *webName;

/*
 时间
 */
@property (nonatomic, copy) NSString *time;

@end
