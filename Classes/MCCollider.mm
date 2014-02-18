//
//  MCCollider.m
//  MCGame
//
//  Created by kwan terry on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCCollider.h"
#import "MCConfiguration.h"


@implementation MCCollider

@synthesize checkForCollision;
/**
 *	创建一个MCCollider，并且根据是否处于debug状态来决定是否开启其检查功能。
 *
 *	@return	autorelease的碰撞检查器。
 */
+(MCCollider*)collider
{
	MCCollider * collider = [[MCCollider alloc] init];
    // 如果处于debug状态，检查碰撞情况
	if (DEBUG_DRAW_COLLIDERS) {
		collider.active = YES;
		[collider awake];		
	}
	collider.checkForCollision = NO;
	return [collider autorelease];	
}

/**
 *	根据一个输入的MCSceneObject来修改MCCollider的值，也即通过对应的Collider来检查是否发生碰撞。
 *
 *	@param	sceneObject	用于更新的MCSceneObject类
 */
-(void)updateCollider:(MCSceneObject*)sceneObject
{
	if (sceneObject == nil) return;
	transformedCentroid = MCPointMatrixMultiply([sceneObject mesh].centroid , [sceneObject matrix]);
	self.matrix = [sceneObject matrix];
    translation = transformedCentroid;
    scale = MCPointMake(sceneObject.scale.x, sceneObject.scale.y,sceneObject.scale.z);
   //scale = MCPointMake(17, 17,17);
}

/**
 *	检查是否跟别的碰撞器发生冲突。注意这个函数已经被废弃了，只会返回NO。
 *
 *	@param	aCollider	输入的碰撞器
 *
 *	@return	NO
 */
-(BOOL)doesCollideWithCollider:(MCCollider*)aCollider
{
	
	return NO;
}

/**
 *	检查是否跟别的场景对象发生冲突。注意这个函数已经被废弃了，只会返回NO。
 *
 *	@param	sceneObject	输入的场景对象
 *
 *	@return	NO
 */
-(BOOL)doesCollideWithMesh:(MCSceneObject*)sceneObject
{
	
	return NO;
}



#pragma mark Scene Object methods for debugging;

-(void)awake
{
    bool line = YES;
    // 以debug模式下的常量来赋值。
    if (line) {
        mesh = [[MCMesh alloc] initWithVertexes:MCCubreOutlineVertexes_line
                                    vertexCount:MCCubreOutlineVertexesCount_line
                                     vertexSize:MCCubreVertexStride_line renderStyle:GL_LINES];
        mesh.colors = MCCubreColorValues_line;
        mesh.colorSize = MCCubreColorStride_line;
    }else {
        mesh = [[MCMesh alloc] initWithVertexes:MCCubreOutlineVertexes
                                    vertexCount:MCCubreOutlineVertexesCount
                                     vertexSize:MCCubreVertexStride renderStyle:GL_TRIANGLES];
        mesh.colors = MCCubreColorValues;
        mesh.colorSize = MCCubreColorStride;
    }
}


-(void)render
{
	if (!mesh || !active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	
	glMultMatrixf(matrix);
 
	[mesh render];	
	glPopMatrix();
}


- (void) dealloc
{
	[super dealloc];
}

@end
