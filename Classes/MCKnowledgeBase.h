//
//  MCKnowledgeBase.h
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MCBasicElement.h"
#import "Global.h"

/**
 * 用于魔方专家系统的数据库操作 
 *
 * sqlite3的接口函数简介：
 * @see http://liufei-fir.iteye.com/blog/1171175
 */
@interface MCKnowledgeBase : NSObject

+ (MCKnowledgeBase *)getSharedKnowledgeBase;


/// return the path of the DB file
- (NSString *)knowledgeBaseFilePath;

/// insert the pattern
- (BOOL)insertPattern:(NSString *)pattern withKey:(NSString *)key withPreState:(NSString *)state inTable:(NSString *)table;

/// insert the rule
- (BOOL)insertRullOfMethod:(NSInteger)method withState:(NSString *)state ifContent:(NSString *)ifContent thenContent:(NSString *)thenContent inTable:(NSString *)table;

/// Insert the state
- (BOOL)insertStateOfMethod:(NSInteger)method withPattern:(NSString *)pattern preState:(NSString *)preState afterState:(NSString *)afterState;

/// Get the states based on method
- (NSMutableDictionary *)getStatesOfMethod:(NSInteger)method;

/// Get the pattern dictionary based on state of specified table
- (NSMutableDictionary *)getPatternsWithPreState:(NSString *)state inTable:(NSString *)tableName;

/// Get the rules based on method and state of specified table
- (NSMutableDictionary *)getRulesOfMethod:(NSInteger)method withState:(NSString *)state inTable:(NSString *)tableName;


@end
