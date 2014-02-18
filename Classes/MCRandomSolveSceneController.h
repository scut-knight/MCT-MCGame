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
//#import "MCPlayHelper.h"
#import "MCCollisionController.h"
#import "MCMagicCubeUIModelController.h"
#import "MCPoint.h"

/**
 *	求解模式场景控制器
 */
@interface MCRandomSolveSceneController : sceneController{
    /**
     *	魔方模型控制器，它就是中央的大魔方
     */
    MCMagicCubeUIModelController* magicCubeUI;
    /**
     *	被选中的方块的索引
     */
    int selected_index;
    /**
     *	被选中的面的索引
     */
    int selected_face_index;
    /**
     *	tips标签，用于展示提示
     */
     UILabel *_tipsLabel;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (assign)int selected_index;
@property (assign)int selected_face_index;
@property(nonatomic,retain)UILabel *tipsLabel;

+ (MCRandomSolveSceneController*)sharedRandomSolveSceneController;

-(void)loadScene;


-(void)turnTheMCUI_Into_SOlVE_Play_MODE;

-(void)rotateWithSingmasterNotation:(SingmasterNotation)notation isNeedStay:(BOOL)isStay isTwoTimes:(BOOL)isTwoTimes;

-(void)clearState;

-(void)releaseSrc;

-(void)previousSolution;

-(void)nextSolution;

-(BOOL)isSelectOneFace:(vec2)touchpoint;

-(void)flashSecne;

-(void)nextSingmasterNotation:(SingmasterNotation)notation;

-(void)closeSingmasterNotation;

@end
