//
//  MCWorkingMemory.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-3.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCubieDelegate.h"
#import "MCMagicCubeDelegate.h"
#import "MCApplyQueue.h"

/**
 *  locker max size
 */
#define CubieCouldBeLockMaxNum 26
/**
 *	默认可以记忆的剩余动作数
 */
#define DEFAULT_RESIDUAL_ACTION_NUM 3

/**
 *	魔方の记忆，记住当前魔方状态和额外三个剩余动作
 */
@interface MCWorkingMemory : NSObject {
    /**
     *  储存被锁住的魔方块的数组
     *  当某个魔方方块被锁住，对应的索引上的值为被锁住魔方方块；否则为nil
     */
    NSObject<MCCubieDelegate>* lockedCubies[CubieCouldBeLockMaxNum];
}

@property (nonatomic, retain) NSObject<MCMagicCubeDelegate> *magicCube;
/**
 *	这里的函数并不用到applyQueue，所以不需要初始化applyQueue。applyQueue将由另外的类来处理
 *  @see MCActionPerformer
 */
@property (nonatomic, retain) MCApplyQueue *applyQueue;
/**
 *	储存剩余动作
 */
@property (nonatomic, retain) NSMutableArray *residualActions;
/**
 *	被记忆的模式，
 *  注意这个类只是负责储存模式的值，对agendaPattern的赋值和使用由MCExplanationSystem进行
 *  @see MCExplanationSystem
 */
@property (nonatomic, retain) MCPattern *agendaPattern;
@property (nonatomic, copy) NSString *magicCubeState;


+ (MCWorkingMemory *)workingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc;

- (id)initWorkingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc;

// Clear all working memory data except magic cube data.
- (void)clearExceptMagicCubeData;

// This action will unlock all cubies.
// Just when re-check state from init, it should be invoked.
- (void)unlockAllCubies;


- (void)unlockCubieAtIndex:(NSInteger)index;


- (void)unlockCubiesInRange:(NSRange)range;


- (BOOL)lockerEmptyAtIndex:(NSInteger)index;


- (void)lockCubie:(NSObject<MCCubieDelegate> *)cubie atIndex:(NSInteger)index;


- (NSObject<MCCubieDelegate> *)cubieLockedInLockerAtIndex:(NSInteger)index;


@end
