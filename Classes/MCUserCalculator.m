//
//  MCUserCalculator.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-30.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCUserCalculator.h"
/**
 *	满分，得分为满分扣去一定分数而定
 */
#define highestScore 99999
/**
 *	步数权重
 */
#define moveWeight 50
/**
 *	耗时权重
 */
#define timeWeight 50

@implementation MCUserCalculator
/**
 *  通过步数和消耗时间计算得分，耗时越多，步数越多，得分越低
 */
-(NSInteger)calculateScoreForMove:(NSInteger)move Time:(double)time
{
    //expression of calculating the total score for each time
    NSInteger score = highestScore - move*moveWeight - time*timeWeight;
    return score;
}
/**
 *  计算平均每一步耗时
 */
-(double)calculateSpeedForMove:(NSInteger)move Time:(double)time
{
    return (double)move/time;
}

@end
