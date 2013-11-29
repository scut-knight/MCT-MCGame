//
//  MCWorkingMemory.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-3.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCWorkingMemory.h"


@implementation MCWorkingMemory

@synthesize magicCube = _magicCube;
@synthesize applyQueue = _applyQueue;
@synthesize residualActions = _residualActions;
@synthesize agendaPattern = _agendaPattern;
@synthesize magicCubeState = _magicCubeState;

/**
 *  返回当前魔方的一个MCWorkingMemory实例,注意不是单件
 */
+ (MCWorkingMemory *)workingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    return [[[MCWorkingMemory alloc] initWorkingMemoryWithMagicCube:mc] autorelease];
}

/**
 *	初始化
 *
 *	@param	mc	当前魔方
 *
 *	@return	self
 */
- (id)initWorkingMemoryWithMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    if (self = [super init]) {
        self.magicCube = mc;
        
        // Here allocate the array which store residual actions.
        // The residual actions contains all actions of the applied rule except rotation actions.
        self.residualActions = [NSMutableArray arrayWithCapacity:DEFAULT_RESIDUAL_ACTION_NUM];
        // 注意这里的函数并不用到applyQueue，所以不需要初始化applyQueue。applyQueue将由另外的类来处理
    }
    return self;
}


- (void)dealloc{
    [_applyQueue release];
    [_magicCube release];
    [_residualActions release];
    [_agendaPattern release];
    [_magicCubeState release];
    
    [super dealloc];
}


- (void)unlockAllCubies{
    for (int i = 0; i < CubieCouldBeLockMaxNum; i++) {
        lockedCubies[i] = nil;
    }
}

- (void)unlockCubieAtIndex:(NSInteger)index{
    lockedCubies[index] = nil;
}


- (void)unlockCubiesInRange:(NSRange)range{
    int i = 0;
    int position = range.location;
    // 上面两行可以合并到下面的for循环中
    for (; i < range.length; i++, position++) {
        lockedCubies[position] = nil;
    }
}

/**
 *	查明某个立方块上是否无锁
 *
 *	@param	index
 *
 *	@return	YES代表未锁住，NO代表已经锁住
 */
- (BOOL)lockerEmptyAtIndex:(NSInteger)index{
    return lockedCubies[index] == nil;
}


- (void)lockCubie:(NSObject<MCCubieDelegate> *)cubie atIndex:(NSInteger)index{
    lockedCubies[index] = cubie;
}


- (NSObject<MCCubieDelegate> *)cubieLockedInLockerAtIndex:(NSInteger)index{
    return lockedCubies[index];
}

/**
 *	清除额外的魔方数据，当魔方改变时(setMagicCube调用)，这些数据都已经无用了
 */
- (void)clearExceptMagicCubeData{
    self.applyQueue = nil;
    [self.residualActions removeAllObjects];
    self.agendaPattern = nil;
    self.magicCubeState = UNKNOWN_STATE;
    [self unlockAllCubies];
}

/**
 *	覆盖默认的magicCube的setter，在设值之前清除额外的魔方数据
 */
// The magic cube setter has been rewritten.
// Once you set the magic cube object, all other data will be clear.
- (void)setMagicCube:(NSObject<MCMagicCubeDelegate> *)mc{
    [mc retain];
    [_magicCube release];
    _magicCube = mc;
    
    [self clearExceptMagicCubeData];
    
}


@end
