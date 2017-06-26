//
//  DBManager.h
//  KuaiYi_Doctor
//
//  Created by 刘国龙 on 16/3/15.
//  Copyright © 2016年 刘国龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface DBManager : NSObject

/**
 *  初始化Sqlite数据库
 */
+ (void)initSqlitePath;

/**
 *  获取Document目录
 *
 *	@return Document目录路径
 */
+ (NSString *)documentPath;

/**
 *  获取Sqlite数据库位置
 *
 *	@return Sqlite数据库位置
 */
+ (NSString *)databaseFile;

/**
 *  删除指定位置文件
 *
 *  @param filePath 文件路径
 */
+ (void)removePathWithFile:(NSString *)filePath;

/**
 *  执行增删改SQL
 *
 *  @param sql SQL语句
 *	@param arguments SQL语句执行参数
 *
 *	@return 执行成功返回YES，失败返回NO
 */
+ (BOOL)modifyWithSql:(NSString *)sql arguments:(NSArray *)arguments;

/**
 *  执行查询操作
 *
 *  @param sql 添加的CGPoint
 *	@param arguments SQL语句执行参数
 *
 *	@return 返回数据
 */
+ (NSMutableArray *)queryWithSql:(NSString *)sql arguments:(NSArray *)arguments;

/**
 *  检查数据内是否存在tableName表，不存在执行SQL语句进行创建
 *
 *  @param tableName 数据表名
 *	@param sql 建表语句
 *
 *  @return 存在返回YES，否则执行完成SQL成功创建该表后返回YES
 */
+ (BOOL)createTableWithTableName:(NSString *)tableName withSql:(NSString *)sql;

/**
 *  检查tableName表里，是否存在columnName这一列，若不存在则执行sql以增加这一列
 *
 *  @param tableName 数据表名
 *	@param columnName 列名
 *	@param sql 建表语句
 *
 *  @return 存在返回YES，否则执行完成SQL成功创建该列后返回YES
 */
+ (BOOL)updateTableWithTableName:(NSString *)tableName withColumnName:(NSString *)columnName withSql:(NSString *)sql;

@end
