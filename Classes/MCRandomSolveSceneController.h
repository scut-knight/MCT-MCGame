//
//  MCRandomSolveViewController.h
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "sceneController.h"
#import "MCMagicCube.h"
#import "RotateType.h"
#import "MCPlayHelper.h"
#import "MCCollisionController.h"
#import "MCMagicCubeUIModelController.h"
#import "MCPoint.h"
@interface MCRandomSolveSceneController : sceneController{
    MCMagicCubeUIModelController* magicCubeUI;
    MCMagicCube * magicCube;
    MCPlayHelper * playHelper;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (nonatomic,retain)MCPlayHelper * playHelper;


+ (MCRandomSolveSceneController*)sharedRandomSolveSceneController;

-(void)loadScene;

-(BOOL)isSelectOneFace:(vec2)touchpoint;

@end
