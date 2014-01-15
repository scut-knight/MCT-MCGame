//
//  MCPartilcleSystem.m
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCParticleSystem.h"
#import "MCConfiguration.h"
#import "MCParticle.h"

@implementation MCParticleSystem

@synthesize emit,materialKey;
@synthesize emissionRange, sizeRange, growRange, xVelocityRange, yVelocityRange;
@synthesize lifeRange,decayRange,emitCounter;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setDefaultSystem];
	}
	return self;
}

/**
 *	初始化粒子系统的各项数据，比如发射粒子的速度的范围等等。
 *  注意，现在粒子们尚未初始化。
 *  而且粒子系统所在的图层也没有构造。
 */
-(void)setDefaultSystem
{
	// just some decent defaults so a naked emitter
	// will do something.
	self.emissionRange = MCRangeMake(1.0, 2.0);
	self.sizeRange = MCRangeMake(4.0, 8.0);
    // 只会渐渐消失
	self.growRange = MCRangeMake(-0.5, -0.1);
    // 向四面八方发射（应该是在同一个平面内扩散）
	self.xVelocityRange = MCRangeMake(-3.0, 3.0);
	self.yVelocityRange = MCRangeMake(-3.0, 3.0);
	self.lifeRange = MCRangeMake(0.0, 2.0);
	self.decayRange = MCRangeMake(0.05, 0.2);
    // 暂时先不发射
	self.emit = NO;
	emitCounter = -1;
}

/**
 *	这个函数初始化了粒子们，并把它们放到粒子池中
 */
-(void)awake
{
	// alloc some space for our particles
	if (activeParticles == nil) activeParticles = [[NSMutableArray alloc] init];
	
	// we are going to pre-alloc a whole bunch of particles so
	// we dont wast time during gameplay allocing them
    // 先初始化到粒子池中
	particlePool = [[NSMutableArray alloc] initWithCapacity:MC_MAX_PARTICLES];
	NSInteger count = 0;
	for (count = 0; count < MC_MAX_PARTICLES; count++) {
		MCParticle * p = [[MCParticle alloc] init];
		[particlePool addObject:p];
		[p release];
	}
	
	// finally make some space for our final particle mesh
	// our vertexes will be all 3 axes, and we need 6 axes per particle
    // 为粒子系统所在图层的描述坐标的数组分配内存
	vertexes = (CGFloat *) malloc(3 * 6 * MC_MAX_PARTICLES * sizeof(CGFloat));
	uvCoordinates = (CGFloat *) malloc(2 * 6 * MC_MAX_PARTICLES * sizeof(CGFloat));
}

/**
 *	设置粒子图层
 *
 *	@param	atlasKey	atlas：地图集 atlasKey是粒子图层所在的图层位置
 */
-(void)setParticle:(NSString*)atlasKey
{
	// ok, here we are going to go and get the quad that will be our particle image
	// however, we do not want to keep the mesh, we just want to get some information from it.
	MCTexturedQuad * quad = [[MCMaterialController sharedMaterialController] quadFromAtlasKey:atlasKey];
    
	// get the material key so we can bind it during render
	self.materialKey = quad.materialKey;
	
	// now we need to find the max/min of the UV coordinates
	// this is the location in the atlas where our image is, and we are
	// going to be applying it to every particle
	CGFloat u,v;
	NSInteger index;
	minU = minV = 1.0;
	maxU = maxV = 0.0;
	CGFloat * uvs = [quad uvCoordinates];
	for (index = 0; index < quad.vertexCount; index++) {
		u = uvs[index * 2];
		v = uvs[(index * 2) + 1];
		if (u < minU) minU = u;
		if (v < minV) minV = v;
		if (u > maxU) maxU = u;
		if (v > maxV) maxV = v;
	}
}

/**
 *	更新图层上的粒子
 */
-(void)update
{
	// update active particles, they will move themselves
	[super update];
	
	// build arrays
	[self buildVertexArrays];
	
	// generate new particles and queue them for addition
	[self emitNewParticles];
	
	//remove old particles
	[self clearDeadQueue];
}

/**
 *	是否有存活的粒子
 *
 *	@return	如果可变数组activeParticles不为空，返回YES,否则返回NO
 */
-(BOOL)activeParticles
{
	if ([activeParticles count] > 0) return YES;
	return NO;
}

/**
 *	建立节点队列
 *
 *  该队列中的节点由粒子横坐标、纵坐标、图层的U/V坐标四个数据组成。
 */
-(void)buildVertexArrays
{
	// go through all our individual particles and add their triangles
	// to our big mesh
	vertexIndex = 0;
	for (MCParticle * particle in activeParticles) {
        // 先刷新，更新粒子状态
		[particle update]; // first, update each particle before we use it's data
        
		// check to see if we have run out of life, or are too small to see
		// and if they are, then queue them for removal
		if ((particle.life < 0) || (particle.size < 0.3)) {
			[self removeChildParticle:particle];
			continue; // skip to the next particle, no need to add this one
		}
		
		// for each particle, need 2 triangles, so 6 verts
		// first triangle of the quad.  Need to load them in clockwise
		// order since our models are in that order
		[self addVertex:(particle.position.x - particle.size) 
                      y:(particle.position.y + particle.size) 
                      u:minU 
                      v:minV];
		[self addVertex:(particle.position.x + particle.size) 
                      y:(particle.position.y - particle.size) 
                      u:maxU 
                      v:maxV];		
		[self addVertex:(particle.position.x - particle.size) 
                      y:(particle.position.y - particle.size) 
                      u:minU 
                      v:maxV];
		
		// second triangle of the quad
		[self addVertex:(particle.position.x - particle.size) 
                      y:(particle.position.y + particle.size) 
                      u:minU 
                      v:minV];
		[self addVertex:(particle.position.x + particle.size) 
                      y:(particle.position.y + particle.size) 
                      u:maxU 
                      v:minV];
		[self addVertex:(particle.position.x + particle.size) 
                      y:(particle.position.y - particle.size) 
                      u:maxU 
                      v:maxV];
		
	}
}

/**
 *  重载了基类的render方法
 */
// we want to override the super's render because
// we dont have a mesh, but instead are holding onto all the array data
// as instance vars
-(void)render
{
	if (!active) return;
    
    // 设置投影矩阵
    glMatrixMode(GL_PROJECTION);
	glPushMatrix();
    // 加载投影矩阵
	glLoadIdentity();
	//glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
	
	// set up the viewport so that it is analagous to the screen pixels
    // glOrthof将当前矩阵与一个投影矩阵相乘
    // 并且得到的结果将代替当前矩阵。
    // 它描述了一个产生平行投影的变换。
	glOrthof(-512, 512, -384, 384, -1.0f, 50.0f);
    
	// clear the matrix
	//glPushMatrix();
	//glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    //glMultMatrixf(matrix);
	// bind our texture
	[[MCMaterialController sharedMaterialController] bindMaterial:materialKey];
    
    // 因为要重绘，停止（光照和屏蔽看不到的地方）
	glDisable(GL_LIGHTING);
	glDisable(GL_CULL_FACE);
    
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_NORMAL_ARRAY);
	
	// send the arrays to the rendered
	glVertexPointer(3, GL_FLOAT, 0, vertexes);
    glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
	//draw
    glDrawArrays(GL_TRIANGLES, 0, vertexIndex);
    glMatrixMode(GL_PROJECTION);
	glPopMatrix();

    glMatrixMode(GL_MODELVIEW);

}



/**
 *	发射随机数目的新粒子。
 *  同时更新粒子池和存活粒子数。
 */
-(void)emitNewParticles
{
	if (!emit) return;
	if (emitCounter > 0) emitCounter --; // if emitCounter == -1, then emit forever
	if (emitCounter == 0) emit = NO; // this will be our last time through the emit method
	
	NSInteger newParticles = (NSInteger)MCRandomFloat(emissionRange); // grab a random number to be emitted
	
	NSInteger index;
	CGFloat veloX,veloY;
    // 一个个粒子准备发射
	for (index = 0; index < newParticles; index++) {
		if ([particlePool count] == 0) {
			// if we are out of particles, then just get out early
			return;
		} 
		// grab a premade particle and set it up with some new random nubmers
		MCParticle * p = [particlePool lastObject];
        self.translation = MCPointMake(self.translation.x, self.translation.y, self.translation.z-0.001);
		p.position = self.translation;
		veloX = MCRandomFloat(xVelocityRange);
		veloY = MCRandomFloat(yVelocityRange);
		p.velocity = MCPointMake(veloX, veloY, -0.001);
		p.life = MCRandomFloat(lifeRange);
		p.size = MCRandomFloat(sizeRange);
		p.grow = MCRandomFloat(growRange);
		p.decay = MCRandomFloat(decayRange);
		
        // 同时更新粒子池和存活粒子数。
		// add this particle
		[activeParticles addObject:p];
		// remove this particle from the unused array
		[particlePool removeLastObject];
	}
}

/**
 *	移除粒子
 *
 *	@param	particle	待移除的粒子
 */
-(void)removeChildParticle:(MCParticle*)particle
{
	if (particlesToRemove == nil) particlesToRemove = [[NSMutableArray alloc] init];
	[particlesToRemove addObject:particle];
}

/**
 *	根据particlesToRemove数组更新粒子池和存活粒子数组。
 *  并清空待移除粒子的数组
 */
-(void)clearDeadQueue
{
	// remove any objects that need removal
	if ([particlesToRemove count] > 0) {
		[activeParticles removeObjectsInArray:particlesToRemove];
		[particlePool addObjectsFromArray:particlesToRemove];
		[particlesToRemove removeAllObjects];
	}
}


/**
 *	add a single vertex to our arrays
 *
 *  在数组中加入一个节点
 *
 *	@param	x	粒子的X轴坐标
 *	@param	y	粒子的Y轴坐标
 *	@param	u	图层的u轴坐标
 *	@param	v	图层的v轴坐标
 */
-(void)addVertex:(CGFloat)x y:(CGFloat)y u:(CGFloat)u v:(CGFloat)v
{
	// our position in the vertex array
	NSInteger pos = vertexIndex * 3.0;
	vertexes[pos] = x;
	vertexes[pos + 1] = y;
	vertexes[pos + 2] = self.translation.z;
	
	// the UV array has a different position
	pos = vertexIndex * 2.0;
	uvCoordinates[pos] = u;
	uvCoordinates[pos + 1] = v;
	// increment our vertex count
	vertexIndex++;
}

- (void) dealloc
{
	[particlePool release];
	[activeParticles release];
    
	free(vertexes);
	free(uvCoordinates);
	
	[super dealloc];
}


@end
