//
//  MCActionPerformer.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMagicCubeDelegate.h"
#import "MCBasicElement.h"
#import "MCTransformUtil.h"


/**
 *	处理队列，包括该队列完成事件。
 *  该类遵从<QueueCompleteDelegate>,将一个MCWorkingMemory赋予该类的成员workingMemory。
 *  借此把该类实现的onQueueComplete应用到那个MCWorkingMemory上
 *  这应该算是装饰器的做法，非常巧妙
 */
@interface MCActionPerformer : NSObject <QueueCompleteDelegate>

@property (nonatomic, retain) MCWorkingMemory *workingMemory;


+ (MCActionPerformer *)actionPerformerWithWorkingMemory:(MCWorkingMemory *)wm;

- (id)initActionPerformerWithWorkingMemory:(MCWorkingMemory *)wm;

// Rotate operation with axis, layer, direction
- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction;

// Rotate operation with parameter SingmasterNotation
- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation;

- (BOOL)isQueueEmpty;

- (void)applyRotationInQueue:(SingmasterNotation)currentRotation;

// Get the queue in string format being contained in a array
- (NSArray *)queueStrings;

- (RotationResult)queueRotationResult;

// To begin with, run other actions before coming across first 'Rotate' action.
// Morever, transform the 'Rotation' action to apply queue.
// Lastly, store all residual actions in the working memory's residualActions array that
// will be executed after user complete the apply queue.
- (BOOL)decomposeRule:(MCRule *)rule;


- (NSInteger)treeNodesApply:(MCTreeNode *)root;

@end
