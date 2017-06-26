//
//  DBManager.m
//  KuaiYi_Doctor
//
//  Created by 刘国龙 on 16/3/15.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import "DBManager.h"

#define DBNAME @"CoreCategory"

@implementation DBManager

/**
 *  初始化Sqlite数据库
 */
+ (void)initSqlitePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[DBManager databaseFile]]) {
        //数据库存在
    } else {
        //数据库不存在
        
        //复制数据到用户目录
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:DBNAME ofType:@"sqlite"];
        [fileManager copyItemAtPath:dbPath toPath:[DBManager databaseFile] error:nil];
    }
}

/**
 *  获取Document目录
 *
 *	@return Document目录路径
 */
+ (NSString *)documentPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

/**
 *  获取Sqlite数据库位置
 *
 *	@return Sqlite数据库位置
 */
+ (NSString *)databaseFile {
    return [[DBManager documentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", DBNAME]];
}

/**
 *  删除指定位置文件
 *
 *  @param filePath 文件路径
 */
+ (void)removePathWithFile:(NSString *)filePath{
    if (filePath && filePath.length > 0) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

/**
 *  获得数据库操作对象
 *
 *	@return FMDatabase对象
 */
+ (FMDatabase *)getDataBase {
    return [FMDatabase databaseWithPath:[DBManager databaseFile]];
}

/**
 *  执行增删改SQL
 *
 *  @param sql SQL语句
 *	@param arguments SQL语句执行参数
 *
 *	@return 执行成功返回YES，失败返回NO
 */
+ (BOOL)modifyWithSql:(NSString *)sql arguments:(NSArray *)arguments {
    FMDatabase *fmdb = [DBManager getDataBase];
    BOOL ist = [fmdb open];
    if (ist) {
        ist = [fmdb executeUpdate:sql withArgumentsInArray:arguments];
        [fmdb close];
        if (!ist) {
            
        }
    } else {
        
    }
    return ist;
}

/**
 *  执行查询操作
 *
 *  @param sql 添加的CGPoint
 *	@param arguments SQL语句执行参数
 *
 *	@return 返回数据
 */
+ (NSMutableArray *)queryWithSql:(NSString *)sql arguments:(NSArray *)arguments {
    NSMutableArray *resultArray = [NSMutableArray array];
    FMDatabase *fmdb = [DBManager getDataBase];
    if (![fmdb open]) {
        return resultArray;
    }
    FMResultSet *rs = [fmdb executeQuery:sql withArgumentsInArray:arguments];
    NSInteger colunmCount = [rs columnCount];
    while ([rs next]) {
        NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < colunmCount; i++) {
            NSString *columnName = [rs columnNameForIndex:i];
            NSObject *columnValue = [rs objectForColumnIndex:i];
            [modelDic setObject:columnValue forKey:columnName];
        }
        [resultArray addObject:modelDic];
    }
    [rs close];
    [fmdb close];
    return resultArray;
}

/**
 *  检查数据内是否存在tableName表，不存在执行SQL语句进行创建
 *
 *  @param tableName 数据表名
 *	@param sql 建表语句
 *
 *  @return 存在返回YES，否则执行完成SQL成功创建该表后返回YES
 */
+ (BOOL)createTableWithTableName:(NSString *)tableName withSql:(NSString *)sql {
    if (tableName == nil || tableName.length == 0)
        return NO;
    NSArray *tableArray = [DBManager queryWithSql:@"SELECT COUNT(rowid) as tabCount FROM sqlite_master where type = 'table' and name = ?" arguments:[NSArray arrayWithObject:tableName]];
    NSDictionary *tableDic = [tableArray objectAtIndex:0];
    NSNumber *tabCount = [tableDic objectForKey:@"tabCount"];
    if (tabCount.intValue > 0)
        return YES;
    else
        return [DBManager modifyWithSql:sql arguments:nil];
    return YES;
}

/**
 *  检查tableName表里，是否存在columnName这一列，若不存在则执行sql以增加这一列
 *
 *  @param tableName 数据表名
 *	@param columnName 列名
 *	@param sql 建表语句
 *
 *  @return 存在返回YES，否则执行完成SQL成功创建该列后返回YES
 */
+ (BOOL)updateTableWithTableName:(NSString *)tableName withColumnName:(NSString *)columnName withSql:(NSString *)sql {
    if (tableName == nil || tableName.length == 0 || columnName == nil || columnName.length == 0)
        return NO;
    BOOL isNotColumn = YES;//默认YES,即表内没有columnName这一列
    NSArray *tableColumnArray = [DBManager queryWithSql:@"pragma table_info(?)" arguments:[NSArray arrayWithObject:tableName]];//查询表结构
    for (NSDictionary *columnDic in tableColumnArray) {
        NSString *tmpColumnName = [columnDic objectForKey:@"name"];//获取列名
        if ([columnName isEqualToString:tmpColumnName]) {
            isNotColumn = NO;//找到这一列,存在
            break;
        }
    }
    if (isNotColumn) {
        //增加列
        return [DBManager modifyWithSql:sql arguments:nil];
    }
    return YES;
}

@end
