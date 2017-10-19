//
//  DataBaseTool.h
//  vPort
//
//  Created by MengFanJun on 2017/6/29.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "OperateRecordModel.h"
#import "IdentityInformationModel.h"

@interface DataBaseTool : NSObject

+ (instancetype)shareDataBaseTool;

@property (nonatomic, strong) FMDatabase *dataBase;//数据库

//创建数据库

- (void)creatDataBase;

//删除数据库
- (void)deleteDataBase;

//打开数据库
- (void)openDataBase;

//关闭数据库
- (void)closeDataBase;

//创建操作记录表格
- (void)creatOperateRecordTable;

//插入操作记录数据
- (void)insertOperateRecordWithModel:(OperateRecordModel *)operateRecordModel;

//更新操作记录数据
- (void)updateOperateRecordWithModel:(OperateRecordModel *)operateRecordModel;

//删除操作记录数据
- (void)deleteOperateRecordWithModel:(OperateRecordModel *)operateRecordModel;

//查询操作记录数据
- (NSMutableArray *)selectOperateRecordModelWithQuerySQL:(NSString *)querySQL;

//创建身份证表格
- (void)creatIdentityInformationTable;

//插入身份证数据
- (void)insertIdentityInformationWithModel:(IdentityInformationModel *)identityInformationModel;

//更新身份证数据
- (void)updateIdentityInformationWithModel:(IdentityInformationModel *)identityInformationModel;

//删除身份证数据
- (void)deleteIdentityInformationWithModel:(IdentityInformationModel *)identityInformationModel;

//查询身份证数据
- (NSMutableArray *)selectIdentityInformationModelWithQuerySQL:(NSString *)querySQL;

@end
