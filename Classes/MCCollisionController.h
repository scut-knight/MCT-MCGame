//
//  MCCollidersController.h
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
/**
 *	碰撞处理控制器.
 *  曾经有用，但现在已经不需要了。
 *  只有DEBUG_DRAW_COLLIDERS设置为1时，该类才会被调用。
 *  但是由于某些方法的实现已经不完整，就算是DEBUG模式下也没有起作用。
 */
@interface MCCollisionController : MCSceneObject{
    NSMutableArray * sceneObjects;
	NSMutableArray * allColliders;
	/**
	 *	需要检查的碰撞器
	 */
	NSMutableArray * collidersToCheck;
}
@property (retain) NSMutableArray * sceneObjects;

- (void)awake;
- (void)handleCollisions;
- (void)render;
- (void)update;
@end
