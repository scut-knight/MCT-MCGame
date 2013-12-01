//
//  MCUser.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *	用户身份
 */
@interface MCUser : NSObject

@property (nonatomic) NSInteger userID;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *sex;
@property (nonatomic) NSInteger totalMoves;
@property (nonatomic) double totalGameTime;     ///seconds
@property (nonatomic) double totalLearnTime;    ///seconds
@property (nonatomic) NSInteger totalFinish;

/**
 *	初始化用户资料
 *
 *	@param	_ID	ID号
 *	@param	_name	用户名
 *	@param	_sex	性别
 *	@param	_moves	总共步数
 *	@param	_gameTime	游戏时间
 *	@param	_learnTime	学习时间
 *	@param	_finish	完成次数
 */
- (id)initWithUserID:(NSInteger)_ID UserName:(NSString*)_name UserSex:(NSString*)_sex totalMoves:(NSInteger)_moves totalGameTime:(double)_gameTime totalLearnTime:(double)_learnTime totalFinish:(NSInteger)_finish;

@end
