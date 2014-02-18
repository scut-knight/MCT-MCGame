//
//  MCDBController.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//
/**
 *  @file
 * sqlite3的接口函数简介：
 * @see http://liufei-fir.iteye.com/blog/1171175
 */
#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MCUser.h"
#import "MCScore.h"
#import "MCLearn.h"

#define DBName @"MCDatabase.sqlite3"
/**
 *	用户信息管理的数据库操作
 */
@interface MCDBController : NSObject
{
    /**
     *	database是私有的
     */
    @private sqlite3 *database;
}

+ (MCDBController*) sharedInstance;
- (void) insertUser:(MCUser*)_user;
- (MCUser*) queryUser:(NSString*)_name;
- (NSMutableArray*) queryAllUser;

- (void) insertScore:(MCScore*)_score;
- (NSMutableArray*) queryTopScore;
- (NSMutableArray*) queryMyScore:(NSInteger)_userID;

- (void) insertLearn:(MCLearn*)_learn;

- (void)insertScoreUpdateUser:(MCScore*)_score;
- (void)insertLearnUpdateUser:(MCLearn*)_learn;
@end
