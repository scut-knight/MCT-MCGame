//
//  MCCountingPlaySceneController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCCountingPlaySceneController__1.h"
#import "MCMagicCubeUIModelController.h"
#import "MCCountingPlayInputViewController__1.h"
#import "Cube.h"
#import "MCMultiDigitCounter.h"
#import "MCBackGroundTexMesh.h"
#import "SoundSettingController.h"
#import "MCStringDefine.h"

@implementation MCCountingPlaySceneController
@synthesize magicCube;

/**
 *	产生竞速模式场景控制器的单件
 *
 *	@return	一个指向单件的指针
 */
+(MCCountingPlaySceneController*)sharedCountingPlaySceneController
{
    static MCCountingPlaySceneController *sharedCountingPlaySceneController;
    @synchronized(self)
    {
        if (!sharedCountingPlaySceneController)
            sharedCountingPlaySceneController = [[MCCountingPlaySceneController alloc] init];
	}
	return sharedCountingPlaySceneController;
}

/**
 *	根据魔方公式的旋转类型进行旋转
 *
 *	@param	rotateType	魔方公式中的旋转类型
 *
 *  @see MCNormalPlaySceneController#rotate
 * TODO: 解决不播放音效的问题
 */
-(void)rotate:(RotateType *)rotateType{
    [magicCube rotateWithSingmasterNotation:[rotateType notation]];
    [magicCubeUI flashWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    
    SoundSettingController *soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting playSoundForKey:Audio_RotateSound_Ding_key];
    
    [self checkIsOver];
}

/**
 *	加载场景
 */
-(void)loadScene{
    needToLoadScene = NO;
	RANDOM_SEED();
	// this is where we store all our objects
	if (sceneObjects == nil) sceneObjects = [[NSMutableArray alloc] init];	
	magicCube = [[MCMagicCube magicCube]retain];
    //随机置乱魔方
    //[self randomMagiccube];
    //背景
    MCBackGroundTexMesh* background = [[MCBackGroundTexMesh alloc]init];
    background.pretranslation = MCPointMake(0, 0, -246);
    background.scale = MCPointMake(64, 64, 1);
    [self addObjectToScene:background];
    [background release];
    //魔方模型
    magicCubeUI = [[MCMagicCubeUIModelController alloc]initiateWithState:[ magicCube getColorInOrientationsOfAllCubie]];
    magicCubeUI.target=self;
    [magicCubeUI setStepcounterAddAction:@selector(stepcounterAdd)];
    [magicCubeUI setStepcounterMinusAction:@selector(stepcounterMinus)];
    [self addObjectToScene:magicCubeUI];
    [magicCubeUI release];
    
    collisionController = [[MCCollisionController alloc] init];
	collisionController.sceneObjects = magicCubeUI.array27Cube;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
	    
	// reload our interface
	[(MCCountingPlayInputViewController*)inputController loadInterface];
}

/**
 *	计步器加一
 */
-(void)stepcounterAdd{
    MCMultiDigitCounter *tmp = [(MCCountingPlayInputViewController*)inputController stepcounter];
    [tmp addCounter];
}

/**
 *	计步器减一
 */
-(void)stepcounterMinus{
    MCMultiDigitCounter *tmp = [(MCCountingPlayInputViewController*)inputController stepcounter];
    [tmp minusCounter];
}


/**
 *	检测游戏过程是否结束
 */
-(void)checkIsOver{
    if ([[self magicCube] isFinished]) {
        [((MCCountingPlayInputViewController*)[self inputController])showFinishView];
        NSLog(@"END form Scene");
    }
};


/**
 *	回退到前一步
 */
-(void)previousSolution{
    NSLog(@"mc previousSolution");
    [magicCubeUI performSelector:@selector(previousSolution)];
}

/**
 *	前进到下一步
 */
-(void)nextSolution{
    NSLog(@"mc nextSolution");
    [magicCubeUI performSelector:@selector(nextSolution)];
}

/**
 *	随机打乱魔方，用于重新加载的时候
 *
 *  @see MCNormalPlayInputViewController#randomRotateHelp1
 */
-(void)randomMagiccube{
    RANDOM_SEED();
    //更新下一次spaceindicator方向
    AxisType lastRandomAxis = X;
    AxisType axis;
    for (int i = 0; i<RandomRotateMaxCount; i++) {
        axis = (AxisType)(RANDOM_INT(0, 2));
        if (axis==lastRandomAxis) {
            axis = (AxisType)((lastRandomAxis+1)%3);
        }
        lastRandomAxis = axis;
        LayerRotationDirectionType direction = (LayerRotationDirectionType)(RANDOM_INT(0, 1));
        int layer = RANDOM_INT(0, 2);
        [magicCube rotateOnAxis:axis onLayer:layer inDirection:direction];
    }
}

/**
 *	重新由魔方模型数据渲染魔方外观
 */
-(void)flashScene{
    [magicCubeUI flashWithState:[magicCube getColorInOrientationsOfAllCubie]];
};

-(void)releaseSrc{
    [super releaseSrc];
}

@end
