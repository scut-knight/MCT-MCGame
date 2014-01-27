//
//  MCNormalPlaySceneController.h
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//
#import <Foundation/Foundation.h>
#import "sceneController.h"
#import "MCMagicCube.h"
#import "MCMagicCubeUIModelController.h"
#import "RotateType.h"
#import "MCPlayHelper.h"

/**
 *	学习模式场景控制器
 */
@interface MCNormalPlaySceneController : sceneController{
    /**
     *	魔方模型控制器，它就是中央的大魔方
     */
    MCMagicCubeUIModelController* magicCubeUI;
    /**
     *	魔方数据模型
     */
    MCMagicCube * magicCube;
    /**
     *	指导魔方旋转的专家系统
     */
    MCPlayHelper * playHelper;
    /**
     *	是否需要展示队列
     */
    BOOL isShowQueue;
     /**
      *	tips标签，用于展示提示
      */
     UILabel *_tipsLabel;
    //float rotation_per_second;
}
@property (nonatomic,retain)MCMagicCube * magicCube;
@property (nonatomic,retain)MCPlayHelper * playHelper;
@property (assign)BOOL isShowQueue;
@property(nonatomic,retain)UILabel *tipsLabel;
//@property(assign)float rotation_per_second;

+ (MCNormalPlaySceneController*)sharedNormalPlaySceneController;
-(void)loadScene;
-(void)reloadScene;
- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction isTribleRotate:(BOOL)is_trible_roate;
-(void)rotate:(RotateType*)rotateType;
-(void)previousSolution;
-(void)nextSolution;
-(void)reloadLastTime;
-(void)showQueue;
-(void)checkIsOver;
-(void)closeSpaceIndicator;
-(void)releaseSrc;
@end
