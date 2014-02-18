//
//  MCCountingPlaySceneController.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sceneController.h"
#import "MCCollisionController.h"
#import "MCMagicCube.h"
#import "RotateType.h"
#import "MCMagicCubeUIModelController.h"

/**
 *	竞速模式场景控制器
 */
@interface MCCountingPlaySceneController : sceneController{
    /**
     *	魔方模型控制器，它就是中央的大魔方
     */
    MCMagicCubeUIModelController* magicCubeUI;
    /**
     *	魔方数据模型
     */
    MCMagicCube * magicCube;
}
@property (nonatomic,retain)MCMagicCube * magicCube;

+ (MCCountingPlaySceneController*)sharedCountingPlaySceneController;

-(void)loadScene;
-(void)rotate:(RotateType*)rotateType;
-(void)previousSolution;
-(void)nextSolution;
-(void)releaseSrc;
-(void)randomMagiccube;
-(void)flashScene;
@end
