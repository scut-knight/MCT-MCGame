//
//  MCPartilcleSystem.h
//  MCGame
//
//  Created by ruitaocc@gmail.com on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCSceneObject.h"
#import "MCPoint.h"

@class MCParticle;

/**
 *	粒子系统
 *
 */
@interface MCParticleSystem : MCSceneObject{
    //three mutable array use to reuse particle objects,which avoid the alloc operation cost too much time.
    // 以下三个可变数组用于管理粒子对象的分配、回收。
    // 以免浪费太多的构造成本
    NSMutableArray * activeParticles;
    NSMutableArray * particlesToRemove;
    NSMutableArray * particlePool; 
    
    //	
    GLfloat * uvCoordinates;
	GLfloat * vertexes;
    
    /**
	 *	key material texture.
	 */
	NSString * materialKey;	
	NSInteger vertexIndex;
    
	/**
	 *	是否发射
	 */
	BOOL emit;
    
    // 图层的uv坐标的临界值
	CGFloat minU;
	CGFloat maxU;
	CGFloat minV;
	CGFloat maxV;
    
	//emit how many particle at per frame.
	NSInteger emitCounter;
    
	/**
	 *	发射的粒子数的范围
	 */
	MCRange emissionRange;
	////set the particle's initial size randomly and its growrate as well.
    /**
     *	发射的粒子大小的范围
     */
    MCRange sizeRange;
	/**
	 *	发射的粒子的增长率。其实就是缩小的速率
	 */
	MCRange growRange;
    //set the particle's initial velocity randomly and direction as well.
	/**
	 *	发射的粒子的x方向的速率
	 */
	MCRange xVelocityRange;
	/**
	 *	发射的粒子的y方向的速率
	 */
	MCRange yVelocityRange;
	//set the particle's lifetime randomly and decay cycle as well .
	/**
	 *	发射的粒子的生命值
	 */
	MCRange lifeRange;
	/**
	 *	粒子衰老的速率
	 */
	MCRange decayRange;
}

@property (retain) NSString * materialKey;

@property (assign) BOOL emit;
@property (assign) NSInteger emitCounter;

@property (assign) MCRange emissionRange;
@property (assign) MCRange sizeRange;
@property (assign) MCRange growRange;
@property (assign) MCRange xVelocityRange;
@property (assign) MCRange yVelocityRange;

@property (assign) MCRange lifeRange;
@property (assign) MCRange decayRange;

- (BOOL)activeParticles;
- (id)init;
- (void)dealloc;
- (void)addVertex:(CGFloat)x y:(CGFloat)y u:(CGFloat)u v:(CGFloat)v;
- (void)awake;
- (void)buildVertexArrays;
- (void)clearDeadQueue;
- (void)emitNewParticles;
- (void)removeChildParticle:(MCParticle*)particle;
- (void)render;
- (void)setDefaultSystem;
- (void)setParticle:(NSString*)atlasKey;
- (void)update;
@end