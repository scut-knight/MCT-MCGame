//
//  MCSceneController.m
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCSceneController.h"
#import "InputController.h"
#import "EAGLView.h"
#import "MCSceneObject.h"
#import "MCConfiguration.h"
#import "MCPoint.h"
#import "Cube.h"
#import "MCBackGroundTexMesh.h"
#import "MCMagicCubeUIModelController.h"
//#import "data.hpp"
@implementation MCSceneController

/**
 *  使用Singleton来初始化
 */
+(MCSceneController*)sharedSceneController
{
  static MCSceneController *sharedSceneController;
  @synchronized(self)
  {
    if (!sharedSceneController)
      sharedSceneController = [[MCSceneController alloc] init];
	}
	return sharedSceneController;
}


#pragma mark scene preload

/**
 *	初始化所有的场景对象
 */
// this is where we initialize all our scene objects
-(void)loadScene
{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	// 加载背景
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    
    //大魔方
    MCMagicCubeUIModelController* magicCubeUI = [[MCMagicCubeUIModelController alloc] initiate];
    magicCubeUI.target=self;
    [magicCubeUI setUsingMode:SOlVE_Input_MODE];
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];

	// reload our interface
	[inputController loadInterface];

    
}



/**
 *	游戏结束时为实现了该接口的各个场景类所调用。
 *  这里没有实现，可供实现来覆盖
 */
-(void)gameOver
{
    //this selector would be the action take by interface when the puzzle is solved. but now it is not implement.
	if([inputController respondsToSelector:@selector(gameOver)]){
      //  [inputController gameOver];
    }
}

#pragma mark dealloc


- (void) dealloc
{
	
	[super dealloc];
}

- (void)releaseSrc{
    [super releaseSrc];
}


@end
