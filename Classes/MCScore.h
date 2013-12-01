//
//  MCScore.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *	得分
 */
@interface MCScore : NSObject

@property (nonatomic) NSInteger scoreID;
@property (nonatomic) NSInteger userID;
@property (nonatomic ,retain) NSString* name; 
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger move;
@property (nonatomic) double time;
@property (nonatomic) double speed;
@property (retain, nonatomic) NSString *date;

/**
 *	初始化得分信息
 *
 *	@param	_sID	得分ID
 *	@param	_uID	用户ID
 *	@param	_name	用户名
 *	@param	_score	得分
 *	@param	_move	步数
 *	@param	_time	消耗时间
 *	@param	_speed	速度
 *	@param	_date	日期
 */
- (id) initWithScoreID:(NSInteger)_sID userID:(NSInteger)_uID name:(NSString*)_name score:(NSInteger)_score move:(NSInteger)_move time:(double)_time speed:(double)_speed date:(NSString*)_date;


@end
