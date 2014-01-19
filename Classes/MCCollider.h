//
//  MCCollider.h
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"

/**
 *	@protocol
 *  实现该协议的类将有处理物体是否发生碰撞的能力。
 */
@protocol MCCollisionHandlerProtocol
- (void)didCollideWith:(MCSceneObject*)sceneObject; 
@end

/**
 *	碰撞检查器。用于检查场景对象之间的空间位置是否发生冲突。
 *  不过只在debug模式下有用。现在已经被废弃了。
 *  但只是没有用途罢了，有些代码依赖这个类，所以请勿删除。
 */
@interface MCCollider : MCSceneObject{
    MCPoint transformedCentroid;
	BOOL checkForCollision;
}

@property (assign) BOOL checkForCollision;

+ (MCCollider*)collider;
- (BOOL)doesCollideWithCollider:(MCCollider*)aCollider;
- (BOOL)doesCollideWithMesh:(MCSceneObject*)sceneObject;
- (void)dealloc;
- (void)awake;
- (void)render;
- (void)updateCollider:(MCSceneObject*)sceneObject;

// 6 methods



@end
