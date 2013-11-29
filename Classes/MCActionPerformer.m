//
//  MCActionPerformer.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCActionPerformer.h"

@implementation MCActionPerformer

@synthesize workingMemory;

/**
 *	返回一个MCActionPerformer实例
 *
 *	@param	wm	将要装饰的MCWorkingMemory
 */
+ (MCActionPerformer *)actionPerformerWithWorkingMemory:(MCWorkingMemory *)wm{
    return [[[MCActionPerformer alloc] initActionPerformerWithWorkingMemory:wm] autorelease];
}

/**
 *	MCActionPerformer构造函数，将定义好的onQueueComplete应用到MCWorkingMemory参数上
 *
 *	@param	wm	将要装饰的MCWorkingMemory
 *
 */
- (id)initActionPerformerWithWorkingMemory:(MCWorkingMemory *)wm{
    if (self = [super init]) {
        self.workingMemory = wm;
        self.workingMemory.applyQueue.queueCompleteDelegate = self;
    }
    return self;
}


- (void)dealloc{
    [super dealloc];
    [workingMemory release];
}

/**
 *	旋转，调用MCMagicCubeOperationDelegate中定义的- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction来进行旋转
 *	@return	BOOL	如果旋转失败，返回NO
 */
// Rotate operation with axis, layer, direction
- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction{
    NSObject<MCMagicCubeOperationDelegate> *magicCube = self.workingMemory.magicCube;
    if (magicCube != nil) {
        return [magicCube rotateOnAxis:axis onLayer:layer inDirection:direction];
    }
    return NO;
}

/**
 *	旋转。
 *  调用MCMagicCubeOperationDelegate中定义的- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation来进行旋转
 *	@return	BOOL	如果旋转失败，返回NO
 */
// Rotate operation with parameter SingmasterNotation
- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation{
    NSObject<MCMagicCubeOperationDelegate> *magicCube = self.workingMemory.magicCube;
    if (magicCube != nil) {
        return [magicCube rotateWithSingmasterNotation:notation];
    }
    return NO;
}

/**
 *	判断workingMemory.applyQueue是否为空
 */
- (BOOL)isQueueEmpty{
    return self.workingMemory.applyQueue == nil;
}

/**
 *	@return	描述workingMemory.applyQueue的字符串数组
 */
- (NSArray *)queueStrings{
    return [self.workingMemory.applyQueue getQueueWithStringFormat];
}

/**
 *	调用applyQueue里的applyNotation来处理
 *
 *	@param	currentRotation	当前所需的旋转动作
 */
- (void)applyRotationInQueue:(SingmasterNotation)currentRotation{
    [self.workingMemory.applyQueue applyRotation:currentRotation];
}

/**
 *	@return	返回之前队列中的旋转结果
 */
- (RotationResult)queueRotationResult{
    return self.workingMemory.applyQueue.previousResult;
}

/**
 *  根据抽象语法树的每个节点的类型应用旋转
 *  @see MCApplyQueue#- (id)initWithRotationAction:
 *	@param	root	抽象语法树的根节点
 *
 *	@return	(NSInteger)root.result or YES or NO
 *  返回值不重要，会被忽略
 *
 * @see MCExplanationSystem#treeNodesApply:
 * @see MCInferenceEngine#treeNodesApply:
 *
 * 这几个方法享有同样的命名，都是作用在语法树上的，只是层次不同，当然这个是作用在最底层的。
 */
- (NSInteger)treeNodesApply:(MCTreeNode *)root{
    NSObject<MCMagicCubeDelegate> *magicCube = self.workingMemory.magicCube;
    
    switch (root.type) {
        case ExpNode:
        {
            if (root.value == Sequence) {
                return [self sequenceNodeApply:root];
            }
        }
            break;
        // 动作
        case ActionNode:
        {
            switch (root.value) {
                case Rotate:
                    for (MCTreeNode *child in root.children) {
                        [magicCube rotateWithSingmasterNotation:(SingmasterNotation)child.value];
                    }
                    break;
                case FaceToOrientation:
                {
                    MCTreeNode *elementNode;
                    elementNode = [root.children objectAtIndex:0];
                    ColorCombinationType targetCombination = (ColorCombinationType)elementNode.value;
                    struct Point3i targetCoor = [magicCube coordinateValueOfCubieWithColorCombination:targetCombination];
                    elementNode = [root.children objectAtIndex:1];
                    FaceOrientationType targetOrientation = (FaceOrientationType)elementNode.value;
                    [magicCube rotateWithSingmasterNotation:[MCTransformUtil getPathToMakeCenterCubieAtPosition:targetCoor inOrientation:targetOrientation]];
                }
                    break;
                case LockCubie:
                {
                    MCTreeNode *elementNode = [root.children objectAtIndex:0];
                    int index = 0;
                    if ([root.children count] != 1) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                    }
                    int identity = [self treeNodesApply:elementNode];
                    if (identity == -1) {
                        [self.workingMemory unlockCubieAtIndex:index];
                    }
                    else{
                        [self.workingMemory lockCubie:[magicCube cubieWithColorCombination:(ColorCombinationType)identity]
                                atIndex:index];
                    }
                }
                    break;
                case UnlockCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    [self.workingMemory unlockCubieAtIndex:index];
                }
                    break;
                default:
                    return NO;
            }
        }
            break;
        // 信息
        case InformationNode:
            switch (root.value) {
                case getCombinationFromOrientation:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ([magicCube centerMagicCubeFaceInOrientation:(FaceOrientationType)child.value]) {
                            case Up:
                                y = 2;
                                break;
                            case Down:
                                y = 0;
                                break;
                            case Left:
                                x = 0;
                                break;
                            case Right:
                                x = 2;
                                break;
                            case Front:
                                z = 2;
                                break;
                            case Back:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getCombinationFromColor:
                {
                    // 跟getCombinationFromOrientation相同的操作
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        switch ((FaceColorType)[self treeNodesApply:child]) {
                            case UpColor:
                                y = 2;
                                break;
                            case DownColor:
                                y = 0;
                                break;
                            case LeftColor:
                                x = 0;
                                break;
                            case RightColor:
                                x = 2;
                                break;
                            case FrontColor:
                                z = 2;
                                break;
                            case BackColor:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getFaceColorFromOrientation:
                {
                    FaceColorType color;
                    FaceOrientationType orientation = (FaceOrientationType)[(MCTreeNode *)[root.children objectAtIndex:0] value];
                    if ([root.children count] == 1) {
                        switch ([magicCube centerMagicCubeFaceInOrientation:orientation]) {
                            case Up:
                                color = UpColor;
                                break;
                            case Down:
                                color = DownColor;
                                break;
                            case Left:
                                color = LeftColor;
                                break;
                            case Right:
                                color = RightColor;
                                break;
                            case Front:
                                color = FrontColor;
                                break;
                            case Back:
                                color = BackColor;
                                break;
                            default:
                                color = NoColor;
                                break;
                        }
                    }
                    else{
                        // 如果count != 1，属性储存在第二个子节点中
                        int value = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                        struct Point3i coordinate = {value%3-1, value%9/3-1, value/9-1};
                        color = [[magicCube cubieAtCoordinatePoint3i:coordinate] faceColorInOrientation:orientation];
                    }
                    
                    //Store the result at the node
                    root.result = color;
                    return root.result;
                }
                case lockedCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    
                    if ([self.workingMemory lockerEmptyAtIndex:index]) {
                        root.result = -1;
                    }
                    else{
                        root.result = [[self.workingMemory cubieLockedInLockerAtIndex:index] identity];
                    }
                    
                    return root.result;
                }
                default:
                    break;
            }
            break;
        case ElementNode:
            return root.value;
        default:
            return NO;
    }
    return YES;
}

/**
 *	处理根节点的子节点序列
 */
- (BOOL)sequenceNodeApply:(MCTreeNode *)root{
    for (MCTreeNode *node in root.children) {
        [self treeNodesApply:node];
    }
    return YES;
}

/**
 *	对MCRule的每一个适宜的节点应用treeNodesApply
 *
 *	@return	返回BOOL值来报告是否成功完成
 */
- (BOOL)decomposeRule:(MCRule *)rule{
    // Get the tree of the action according to the pattern name
    MCTreeNode *actionTree = [rule root];
    
    // Analyse the action and return the result
    switch (actionTree.type) {
        // 运算符节点的情况
        case ExpNode:
        {
            BOOL flag = YES;
            for (MCTreeNode *node in actionTree.children) {
                if (flag) {
                    if (node.type == ActionNode && (node.value == Rotate|| node.value == FaceToOrientation)) {
                        // 应用队列来进行处理。这里终于要初始化MCWorkingMemory的applyQueue成员
                        self.workingMemory.applyQueue = [MCApplyQueue applyQueueWithRotationAction:node withMagicCube:self.workingMemory.magicCube];
                        self.workingMemory.applyQueue.queueCompleteDelegate = self;
                        flag = NO;
                    }
                    else{// not special type
                        [self treeNodesApply:node];
                    }
                } else {// flag == NO
                    //符合ActionNode && (Rotate || FaceToOrientation)的节点之后的剩余节点
                    [self.workingMemory.residualActions addObject:node];
                }
            }
        }
            break;
        // 动作节点的情况。可以直接处理了。
        case ActionNode:
            switch (actionTree.value) {
                case Rotate:
                    // fall through
                case FaceToOrientation:
                    self.workingMemory.applyQueue = [MCApplyQueue applyQueueWithRotationAction:actionTree withMagicCube:self.workingMemory.magicCube];
                    self.workingMemory.applyQueue.queueCompleteDelegate = self;
                    break;
                default:
                    [self treeNodesApply:actionTree];
                    break;
            }
            break;
            
        default:
            return NO;
    }
    return YES;
}

/**
 *	实现<QueueCompleteDelegate>中声明的onQueueComplete
 */
- (void)onQueueComplete{
    //do the clear thing for next rotation queue
    // 应用剩余动作
    for (MCTreeNode *node in self.workingMemory.residualActions) {
        [self treeNodesApply:node];
    }
    // 然后移除它们
    [self.workingMemory.residualActions removeAllObjects];
}

@end
