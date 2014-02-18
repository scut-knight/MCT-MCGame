//
//  sceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "sceneController.h"



//#import "MCInputViewController.h"
#import "InputController.h"
#import "EAGLView.h"
#import "MCSceneObject.h"
#import "MCConfiguration.h"
#import "MCPoint.h"
#import "Cube.h"
#import "MCCollisionController.h"

@implementation sceneController

@synthesize sceneObjects;
@synthesize inputController, openGLView;
@synthesize animationInterval, animationTimer;
@synthesize levelStartDate;
@synthesize deltaTime;

/**
 * Singleton accessor.  this is how you should ALWAYS get a reference
 * to the scene controller.  Never init your own.
 *
 * 使用该静态方法返回单件，切勿调用init
 */
+(sceneController*)sharedsceneController
{
    static sceneController *sharedsceneController;
    @synchronized(self)
    {
        if (!sharedsceneController)
            sharedsceneController = [[sceneController alloc] init];
	}
	return sharedsceneController;
}


#pragma mark scene preload
/**
 *	记录当前场景对象，准备加载新的场景
 */
-(void)restartScene{
    // queue up all the old objects to be removed
	[objectsToRemove addObjectsFromArray:sceneObjects];
	// reload the scene
	needToLoadScene = YES;
    
}

// this is where we initialize all our scene objects
-(void)loadScene
{
    needToLoadScene = NO;
    // 以当前时间作为生成随机数的种子
	RANDOM_SEED();
    
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	
	// reload our interface
	[inputController loadInterface];
    
    
}



/**
 *	将需要加载的场景对象加载到“预备加载”队列中。并且唤醒场景对象。
 *
 *  we don't actualy add the object directly to the scene.
 * this can get called anytime during the game loop, so we want to
 * queue up any objects that need adding and add them at the start of
 * the next game loop
 *
 *  实际的加入场景对象将会推迟到新的游戏循环的开始阶段。
 *
 *	@param	sceneObject	MC应用的GUI组件的基类，所谓的场景对象
 */
-(void)addObjectToScene:(MCSceneObject*)sceneObject
{
	if (objectsToAdd == nil) objectsToAdd = [[NSMutableArray alloc] init];
	sceneObject.active = YES;
	[sceneObject awake];
	[objectsToAdd addObject:sceneObject];
}


/**
 *	将需要加载的场景对象移除到“预备移除”队列中。
 *
 *  similar to adding objects, we cannot just remove objects from
 * the scene at any time.  we want to queue them for removal
 * and purge them at the end of the game loop
 *
 *  实际的移除场景对象将推迟到当前游戏循环的结束
 *
 *	@param	sceneObject	MC应用的GUI组件的基类，所谓的场景对象
 */
-(void)removeObjectFromScene:(MCSceneObject*)sceneObject
{
	if (objectsToRemove == nil) objectsToRemove = [[NSMutableArray alloc] init];
	[objectsToRemove addObject:sceneObject];
}

/**
 *	@see sceneController#removeObjectFromScene
 */
-(void)removeAllObjectFromScene{
    if ([sceneObjects count] > 0) {
        [sceneObjects removeAllObjects];
    }
}

/**
 * makes everything go
 */
-(void) startScene
{
	self.animationInterval = 1.0/MC_FPS;
	[self startAnimation];
	self.levelStartDate = [NSDate date];
	lastFrameStartTime = 0;
}

#pragma mark Game Loop

- (void)gameLoop
{
	// we use our own autorelease pool so that we can control when garbage gets collected
	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
    
    // 重置场景计时器
	thisFrameStartTime = [levelStartDate timeIntervalSinceNow];
	deltaTime =  lastFrameStartTime - thisFrameStartTime;
	lastFrameStartTime = thisFrameStartTime;
	
	
	
	// add any queued scene objects
	if ([objectsToAdd count] > 0) {
		[sceneObjects addObjectsFromArray:objectsToAdd];
		[objectsToAdd removeAllObjects];
	}
	
	// update our model
	[self updateModel];
	
    
    // deal with collisions
    [collisionController handleCollisions];
    
	// send our objects to the renderer
	[self renderScene];
	
	// remove any objects that need removal
	if ([objectsToRemove count] > 0) {
		[sceneObjects removeObjectsInArray:objectsToRemove];
		[objectsToRemove removeAllObjects];
	}
    
	[apool release];
	if (needToLoadScene) [self loadScene];
}


/**
 *	该方法最终没有实现
 */
-(void)gameOver
{
    //this selector would be the action take by interface when the puzzle is solved. but now it is not implement.
	//[inputController gameOver];
}

- (void)updateModel
{
	// simply call 'update' on all our scene objects
	[inputController updateInterface];
	[sceneObjects makeObjectsPerformSelector:@selector(update)];
	// be sure to clear the events
	[inputController clearEvents];
}

/**
 *	渲染场景内的各个对象和场景
 */
- (void)renderScene
{
	// turn openGL 'on' for this frame
	[openGLView beginDraw];
	//[self setupLookAt];
//	[self setupLighting];
    // 如果上面的setupLighting被调用，会有左上角方向的灯光打到3D魔方上，但是这样其他地方相对显得昏暗。
    // 估计由于美观的原因，该方法没有被调用
	// simply call 'render' on all our scene objects
	[sceneObjects makeObjectsPerformSelector:@selector(render)];
    // draw the interface on top of everything
	[inputController renderInterface];
	// finalize this frame
	[openGLView finishDraw];
}

/**
 *	该方法没有实现
 */
-(void)setupLookAt{
    
}

/**
 *	从左上角处产生光照效果，并且使其他部位相对变得昏暗。
 *  由于美观的原因，该方法最终没有被调用。
 */
-(void)setupLighting
{
	// cull the unseen faces
	// we use 'front' culling because  exports our models to be compatible
	// with this way
    //glFrontFace(GL_CW);
    // 仅仅处理我们能看到的前三个表面
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	
    // Light features
    GLfloat light_ambient[]= { 2.0f, 2.0f, 2.0f, 1.0f };// 环境强度
    GLfloat light_diffuse[]= { 80.0f, 80.0f, 80.0f, 1.0f }; // 散射光强度
    GLfloat light_specular[]= { 10.0f, 10.0f, 10.0f, 1.0f };// 镜面光强度
    // Set up light 0
    glLightfv (GL_LIGHT0, GL_AMBIENT, light_ambient);
    glLightfv (GL_LIGHT0, GL_DIFFUSE, light_diffuse);
    glLightfv (GL_LIGHT0, GL_SPECULAR, light_specular);
    glShadeModel (GL_SMOOTH);
    
	// Place the light up and to the right
    // 如果该数组的最后一个值为1.0，表示指定的坐标为光源位置。如果是0.0，则表示光从无限远处沿指定的向量照射过来。
    GLfloat light0_position[] = { 0.0, 0.0, 100.0, 1.0 };
    
    glLightfv(GL_LIGHT0, GL_POSITION, light0_position);
    
	
	
    // Enable lighting and lights
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    
    
}



#pragma mark Animation Timer

// these methods are copied over from the EAGLView template

- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
	self.animationTimer = nil;
}

/**
 *	为动画指定一个计时器
 *
 *	@param	newTimer	计时器
 */
- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

#pragma mark dealloc


- (void) dealloc
{
	[self stopAnimation];
	
	[sceneObjects release];
	[objectsToAdd release];
	[objectsToRemove release];
	[inputController release];
	[openGLView release];
	
	[super dealloc];
}

- (void)releaseSrc{
    [inputController releaseInterface];
}


@end
