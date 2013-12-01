//
//  MCLearn.h
//  UserManagerSystemXib
//
//  Created by yellow Dai on 13-3-13.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *	学习系统
 */
@interface MCLearn : NSObject

@property (nonatomic) NSInteger learnID;
@property (nonatomic) NSInteger userID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic) NSInteger move;
@property (nonatomic) double time;
@property (retain, nonatomic) NSString *date;
/**
 *	初始化学习信息
 *
 *	@param	_lID	学习ID
 *	@param	_uID	用户ID
 *	@param	_name	用户名
 *	@param	_move	步数
 *	@param	_time	消耗时间
 *	@param	_date	日期
 */
- (id)initWithLearnID:(NSInteger)_lID userID:(NSInteger)_uID name:(NSString*)_name move:(NSInteger)_move time:(double)_time date:(NSString *)_date;

@end
