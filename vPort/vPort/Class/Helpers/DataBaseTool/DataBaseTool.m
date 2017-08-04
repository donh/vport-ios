//
//  DataBaseTool.m
//  vPort
//
//  Created by MengFanJun on 2017/6/29.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "DataBaseTool.h"

@implementation DataBaseTool

+ (instancetype)shareDataBaseTool
{
    static DataBaseTool *dataBaseTool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseTool = [[DataBaseTool alloc] init];
        
    });
    return dataBaseTool;
}

//创建数据库
- (void)creatDataBase
{
    //    if (self.dataBase) {
    //        return;
    //    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    /* 数据库文件路径 */
    NSString *dataBasePath = [docPath stringByAppendingPathComponent:@"dataBase.sqlite"];
    //    NSLog(@"%@",dataBasePath);
    self.dataBase = [FMDatabase databaseWithPath:dataBasePath];
}

//删除数据库
- (void)deleteDataBase
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    /* 数据库文件路径 */
    NSString *dataBasePath = [docPath stringByAppendingPathComponent:@"dataBase.sqlite"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:dataBasePath error:nil];
    
}

//打开数据库
- (void)openDataBase
{
    [self.dataBase open];
}

//关闭数据库
- (void)closeDataBase
{
    [self.dataBase close];
}

#pragma mark 操作记录
//创建操作记录表格
- (void)creatOperateRecordTable
{
    NSString *creatSQL = @"create table if not exists operateRecordTable(operateRecord_id INTEGER PRIMARY KEY,userName varchar(32),userImageUrl TEXT,operateRecordeType varchar(32),operateRecordeStatus varchar(32),operateRecordeInfo varchar(32),webImageUrl TEXT,webUrl TEXT,webName varchar(32),time varchar(32));";
    BOOL result = [self.dataBase executeUpdate:creatSQL];
    if (!result) {
        //创建失败
    }

}

//插入操作记录数据
- (void)insertOperateRecordWithModel:(OperateRecordModel *)operateRecordModel
{
    [self creatDataBase];
    [self openDataBase];
    [self creatOperateRecordTable];
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO operateRecordTable(userName, userImageUrl, operateRecordeType, operateRecordeStatus, operateRecordeInfo, webImageUrl, webUrl, webName, time) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",operateRecordModel.userName,operateRecordModel.userImageUrl,operateRecordModel.operateRecordeType,operateRecordModel.operateRecordeStatus,operateRecordModel.operateRecordeInfo,operateRecordModel.webImageUrl,operateRecordModel.webUrl,operateRecordModel.webName,[self getTimer]];
    BOOL result = [self.dataBase executeUpdate:insertSQL];
    if (!result) {
        //插入失败
    }
    [self closeDataBase];

}

//更新操作记录数据
- (void)updateOperateRecordWithModel:(OperateRecordModel *)operateRecordModel
{
    
}

//删除操作记录数据
- (void)deleteOperateRecordWithModel:(OperateRecordModel *)operateRecordModel
{
    
}

//查询操作记录数据
- (NSMutableArray *)selectOperateRecordModelWithQuerySQL:(NSString *)querySQL
{
    [self creatDataBase];
    [self openDataBase];
    [self creatOperateRecordTable];
    FMResultSet *result = [self.dataBase executeQuery:querySQL];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableArray *operateRecordArray = [NSMutableArray array];
    
    //获取查询结果的下一个记录
    while ([result next]) {
        //根据字段名，获取记录的值，存储到字典中
        NSMutableDictionary *operateRecordDic = [NSMutableDictionary dictionary];
        
        NSString *operateRecord_id = [result stringForColumn:@"operateRecord_id"];
        NSString *userName = [result stringForColumn:@"userName"];
        NSString *userImageUrl = [result stringForColumn:@"userImageUrl"];
        NSString *operateRecordeType = [result stringForColumn:@"operateRecordeType"];
        NSString *operateRecordeStatus = [result stringForColumn:@"operateRecordeStatus"];
        NSString *operateRecordeInfo = [result stringForColumn:@"operateRecordeInfo"];
        NSString *webImageUrl = [result stringForColumn:@"webImageUrl"];
        NSString *webUrl = [result stringForColumn:@"webUrl"];
        NSString *webName = [result stringForColumn:@"webName"];
        NSString *time = [result stringForColumn:@"time"];
        
        
        operateRecordDic[@"operateRecord_id"] = operateRecord_id;
        operateRecordDic[@"userName"] = userName;
        operateRecordDic[@"userImageUrl"] = userImageUrl;
        operateRecordDic[@"operateRecordeType"] = operateRecordeType;
        operateRecordDic[@"operateRecordeStatus"] = operateRecordeStatus;
        operateRecordDic[@"operateRecordeInfo"] = operateRecordeInfo;
        operateRecordDic[@"webImageUrl"] = webImageUrl;
        operateRecordDic[@"webUrl"] = webUrl;
        operateRecordDic[@"webName"] = webName;
        operateRecordDic[@"time"] = time;
        
        //把字典添加进数组中
        [array addObject:operateRecordDic];
        
        OperateRecordModel *operateRecordModel = [[OperateRecordModel alloc] initWithDict:operateRecordDic];
        
        [operateRecordArray addObject:operateRecordModel];
    }
    NSLog(@"selectResults:%@",array);
    [self closeDataBase];

    return operateRecordArray;

}

#pragma mark 身份证
//创建身份证表格
- (void)creatIdentityInformationTable
{
    
//    NSString *creatSQL = @"create table if not exists identityInformationTable(identityInformation_id INTEGER PRIMARY KEY,name varchar(32),identityInformationNumber varchar(32),identityInformationBeginDate varchar(32),identityInformationFinishDate varchar(32),issuingAuthority TEXT,time varchar(32));";
    NSString *creatSQL = @"create table if not exists identityInformationTable(identityInformation_id INTEGER PRIMARY KEY,name varchar(32),gender varchar(32),identityInformationNumber varchar(32),identityInformationBeginDate varchar(32),identityInformationFinishDate varchar(32),issuingAuthority TEXT,identityInformationStatus varchar(32),claimToken varchar(32),attestationJWT varchar(32),time varchar(32));";
    BOOL result = [self.dataBase executeUpdate:creatSQL];
    if (!result) {
        //创建失败
    }

}

//插入身份证数据
- (void)insertIdentityInformationWithModel:(IdentityInformationModel *)identityInformationModel
{
    [self creatDataBase];
    [self openDataBase];
    [self creatIdentityInformationTable];
//    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO identityInformationTable(name,gender, identityInformationNumber, identityInformationBeginDate, identityInformationFinishDate, issuingAuthority,identityInformationStatus,claimToken,attestationJWT,time) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",identityInformationModel.name,identityInformationModel.gender,identityInformationModel.identityInformationNumber,identityInformationModel.identityInformationBeginDate,identityInformationModel.identityInformationFinishDate,identityInformationModel.issuingAuthority,identityInformationModel.identityInformationStatus,identityInformationModel.claimToken,identityInformationModel.attestationJWT,[self getTimer]];
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO identityInformationTable(name,gender, identityInformationNumber, identityInformationBeginDate, identityInformationFinishDate, issuingAuthority, identityInformationStatus, time) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",identityInformationModel.name,identityInformationModel.gender,identityInformationModel.identityInformationNumber,identityInformationModel.identityInformationBeginDate,identityInformationModel.identityInformationFinishDate,identityInformationModel.issuingAuthority,identityInformationModel.identityInformationStatus,[self getTimer]];
    BOOL result = [self.dataBase executeUpdate:insertSQL];
    if (!result) {
        //插入失败
    }
    [self closeDataBase];
}

//更新身份证数据
- (void)updateIdentityInformationWithModel:(IdentityInformationModel *)identityInformationModel
{
    
    [self creatDataBase];
    [self openDataBase];
    [self creatIdentityInformationTable];
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE identityInformationTable SET identityInformation_id = '%@',name = '%@',gender = '%@',identityInformationNumber = '%@',identityInformationBeginDate = '%@',identityInformationFinishDate = '%@',issuingAuthority = '%@',identityInformationStatus = '%@',claimToken = '%@',attestationJWT = '%@',time = '%@' WHERE identityInformation_id = '%@'",identityInformationModel.identityInformation_id,identityInformationModel.name,identityInformationModel.gender,identityInformationModel.identityInformationNumber,identityInformationModel.identityInformationBeginDate,identityInformationModel.identityInformationFinishDate,identityInformationModel.issuingAuthority,identityInformationModel.identityInformationStatus,identityInformationModel.claimToken,identityInformationModel.attestationJWT,identityInformationModel.time,identityInformationModel.identityInformation_id];
    BOOL result = [self.dataBase executeUpdate:updateSQL];
    if (!result) {
        //插入失败
    }
    [self closeDataBase];
}

//删除身份证数据
- (void)deleteIdentityInformationWithModel:(IdentityInformationModel *)identityInformationModel
{
    
}

//查询身份证数据
- (NSMutableArray *)selectIdentityInformationModelWithQuerySQL:(NSString *)querySQL
{
    [self creatDataBase];
    [self openDataBase];
    [self creatIdentityInformationTable];
    FMResultSet *result = [self.dataBase executeQuery:querySQL];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableArray *identityInformationArray = [NSMutableArray array];
    
    //获取查询结果的下一个记录
    while ([result next]) {
        //根据字段名，获取记录的值，存储到字典中
        NSMutableDictionary *identityInformationDic = [NSMutableDictionary dictionary];
        
        NSString *identityInformation_id = [result stringForColumn:@"identityInformation_id"];
        NSString *name = [result stringForColumn:@"name"];
        NSString *gender = [result stringForColumn:@"gender"];
        NSString *identityInformationNumber = [result stringForColumn:@"identityInformationNumber"];
        NSString *identityInformationBeginDate = [result stringForColumn:@"identityInformationBeginDate"];
        NSString *identityInformationFinishDate = [result stringForColumn:@"identityInformationFinishDate"];
        NSString *issuingAuthority = [result stringForColumn:@"issuingAuthority"];
        NSString *identityInformationStatus = [result stringForColumn:@"identityInformationStatus"];
        NSString *claimToken = [result stringForColumn:@"claimToken"];
        NSString *attestationJWT = [result stringForColumn:@"attestationJWT"];
        NSString *time = [result stringForColumn:@"time"];
        
        identityInformationDic[@"identityInformation_id"] = identityInformation_id;
        identityInformationDic[@"name"] = name;
        identityInformationDic[@"gender"] = gender;
        identityInformationDic[@"identityInformationNumber"] = identityInformationNumber;
        identityInformationDic[@"identityInformationBeginDate"] = identityInformationBeginDate;
        identityInformationDic[@"identityInformationFinishDate"] = identityInformationFinishDate;
        identityInformationDic[@"issuingAuthority"] = issuingAuthority;
        identityInformationDic[@"identityInformationStatus"] = identityInformationStatus;
        identityInformationDic[@"claimToken"] = claimToken;
        identityInformationDic[@"attestationJWT"] = attestationJWT;
        identityInformationDic[@"time"] = time;
        
        //把字典添加进数组中
        [array addObject:identityInformationDic];
        
        IdentityInformationModel *identityInformationModel = [[IdentityInformationModel alloc] initWithDict:identityInformationDic];
        
        [identityInformationArray addObject:identityInformationModel];
    }
    NSLog(@"selectResults:%@",array);
    [self closeDataBase];
    
    return identityInformationArray;
}

//获取时刻时间戳
- (NSString *)getTimer
{
    NSString *userCarDateStr;
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateStr = [formater stringFromDate:nowDate];
    NSDate *date1 = [formater dateFromString:dateStr];
    userCarDateStr = [NSString stringWithFormat:@"%.0ld",(long)[date1 timeIntervalSince1970]];
    return userCarDateStr;
}

@end
