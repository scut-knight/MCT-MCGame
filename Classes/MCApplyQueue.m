//
//  MCApplyQueue.m
//  MagicCubeModel
//
//  Created by Aha on 13-4-11.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCApplyQueue.h"
#import "MCTransformUtil.h"
#import "MCCompositeRotationUtil.h"

@implementation MCApplyQueue

@synthesize rotationQueue;
@synthesize extraRotations;
@synthesize currentRotationQueuePosition;
@synthesize previousRotation;
@synthesize previousResult;
@synthesize queueCompleteDelegate;

/**
 *	对旋转动作进行排队
 *
 *	@param	action	经过处理后，构造的旋转动作的抽象语法树
 *	@param	mc	魔方
 *
 *	@return	MCApplyQueue的一个实例
 */
+ (MCApplyQueue *)applyQueueWithRotationAction:(MCTreeNode *)action withMagicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc{
    return [[[MCApplyQueue alloc] initWithRotationAction:action withMagicCube:mc] autorelease];
}

/**
 *	使用一棵构造成的动作语法树，和一个符合<MCMagicCubeDataSourceDelegate>的类构造MCApplyQueue实例
 *
 *  队列的初始容量为10个，另外还有一个extraRotations数组一开始可以容纳3个
 *
 *  在该函数中根据action的不同向rotationQueue加入一个或多个代表SingmasterNotation的NSNumber
 *  加入节点后currentRotationQueuePosition依旧为零
 */
- (id)initWithRotationAction:(MCTreeNode *)action withMagicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc{
    if (self = [super init]) {
        self.currentRotationQueuePosition = 0;
        self.previousResult = NoneResult;
        self.previousRotation = NoneNotation;
        self.rotationQueue = [NSMutableArray arrayWithCapacity:10];
        self.extraRotations = [NSMutableArray arrayWithCapacity:3];
        switch (action.value) {
            case Rotate:
            {
                // 只有Rotate类型需要遍历加入子节点
                for (MCTreeNode *child in action.children) {
                    if (child.value == Fw2 || child.value == Bw2 || child.value == Rw2 || child.value == Lw2 ||
                        child.value == Uw2 || child.value == Dw2 ) {
                        // 注意以上的旋转动作是由两个动作合起来的(它们的后缀都有2)
                        // 所以拆分成两个再加入队列中
                        [self.rotationQueue addObject:[NSNumber numberWithInteger:(child.value-2)]];
                        [self.rotationQueue addObject:[NSNumber numberWithInteger:(child.value-2)]];
                    }
                    else{
                        [self.rotationQueue addObject:[NSNumber numberWithInteger:child.value]];
                    }
                }
            }
                break;
            case FaceToOrientation:
            {
                MCTreeNode *elementNode;
                elementNode = [action.children objectAtIndex:0];
                ColorCombinationType targetCombination = (ColorCombinationType)elementNode.value;
                // 根据色块组合获取坐标
                struct Point3i targetCoor = [mc coordinateValueOfCubieWithColorCombination:targetCombination];
                elementNode = [action.children objectAtIndex:1];
                // 获取朝向
                FaceOrientationType targetOrientation = (FaceOrientationType)elementNode.value;
                [rotationQueue addObject:[NSNumber numberWithInteger:
                                          [MCTransformUtil getPathToMakeCenterCubieAtPosition:targetCoor inOrientation:targetOrientation]]];
            }
                break;
            default:
                break;
        }
    }
    return self;
}


/// reset the current position
- (void)reset{
    currentRotationQueuePosition = 0;
}

/// return the queue length
- (long)count{
    return [self.rotationQueue count];
}

/**
 *	应用旋转动作，并且改变currentRotationQueuePosition
 *
 *  apply rotation and return result，the position will move to next position
 */
- (void)applyRotation:(SingmasterNotation)currentRotation{
    //detect the rotation result
    //if the queue is exist, continue
    //else, return finished
    if (self.rotationQueue == nil) {
        previousResult = Finished;
    }
    else{
        //if they are same, accord
        SingmasterNotation targetRotation = (SingmasterNotation)[[self.rotationQueue objectAtIndex:currentRotationQueuePosition] integerValue];
        
        if (previousResult == StayForATime) {
            // 如果不需要执行旋转
            if ([MCCompositeRotationUtil isSingmasterNotation:previousRotation andSingmasterNotation:currentRotation equalTo:targetRotation]) {
                previousResult = Accord;
                currentRotationQueuePosition++;
            }
            else{
                previousResult = Disaccord;
                //extra queue
                [self.extraRotations removeAllObjects];
                //注意在extraRotations中，previousRotation在currentRotation之后
                [self.extraRotations addObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]]];
                [self.extraRotations addObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:previousRotation]]];
                //self queue
                [self.rotationQueue insertObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]] atIndex:currentRotationQueuePosition];
                [self.rotationQueue insertObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:previousRotation]] atIndex:currentRotationQueuePosition];
            }
            
        } else { // else 0
            if (targetRotation == currentRotation) {
                previousResult = Accord;
                currentRotationQueuePosition++;
                if ([self isFinished]) previousResult = Finished;
            }
            else{ // else 1
                if ([MCCompositeRotationUtil isSingmasterNotation:currentRotation PossiblePartOfSingmasterNotation:targetRotation]) {
                    previousResult = StayForATime;
                }
                else{ //else 2
                    previousResult = Disaccord;
                    //extra queue
                    [self.extraRotations removeAllObjects];
                    [self.extraRotations addObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]]];
                    //self queue
                    [self.rotationQueue insertObject:[NSNumber numberWithInteger:[MCTransformUtil getContrarySingmasterNotation:currentRotation]] atIndex:currentRotationQueuePosition];
                }// else 2
            }// else 1
        }// else 0
        
        if (currentRotationQueuePosition == [self.rotationQueue count]) {
            self.rotationQueue = nil;
            previousResult = Finished;
            // 调用onQueueComplete结束对queue的处理
            [self.queueCompleteDelegate onQueueComplete];
        }
    }
    previousRotation = currentRotation;
}

/**
 *	通过比较currentRotationQueuePosition和self.count,确定队列中所有的动作是否处理完毕
 */
- (BOOL)isFinished{
    return currentRotationQueuePosition == [self count];
}

/**
 *	以RotationTag的形式返回当前的队列
 *  如果传递一个空的NSMutableArray作为参数，就可以避免将Queue里的内容复制两遍
 *	@return	包括RotationTag的NSArray
 */
- (NSArray *)getQueueWithStringFormat{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSNumber *rotation in self.rotationQueue) {
        [mArray addObject:[MCTransformUtil getRotationTagFromSingmasterNotation:(SingmasterNotation)[rotation integerValue]]];
    }
    return [NSArray arrayWithArray:mArray];
}

/**
 *	以RotationTag的形式返回临时队列
 *
 *	@return	包括RotationTag的NSArray
 */
- (NSArray *)getExtraQueueWithStringFormat{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[self.extraRotations count]];
    for (NSNumber *rotation in self.extraRotations) {
        [mArray addObject:[MCTransformUtil getRotationTagFromSingmasterNotation:(SingmasterNotation)[rotation integerValue]]];
    }
    return [NSArray arrayWithArray:mArray];
}

/**
 *	返回当前的动作类型
 */
- (SingmasterNotation)currentRotation{
    return (SingmasterNotation)[[self.rotationQueue objectAtIndex:currentRotationQueuePosition] integerValue];
}

- (void)dealloc{
    [rotationQueue release];
    [extraRotations release];
    [queueCompleteDelegate release];
    
    [super dealloc];
}


@end
