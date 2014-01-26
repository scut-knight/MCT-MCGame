//
//  MCMagicCubeUIModelController.h
//  MCGame
//
//  Created by kwan terry on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPoint.h"
#import "Global.h"
#import "Cube.h"
@class MCMobileObject;
/**
 *  旋转速度 帧率无关设计 2秒
 */
#define TIME_PER_ROTATION 0.25
/**
 *	魔方一次性旋转90度
 */
#define ROTATION_ANGLE 90
/**
 *	组成魔方的立方体间的间隔
 */
#define CUBE_CUBE_GAP 0

#import "MCRay.h"
#include "MCCollider.h"
#import "MCMagicCube.h"

/**
 *	魔方模式
 */
typedef enum _MagicCubeUIUsingMode {
    /**
     *	竞速模式
     */
    PLAY_MODE = 0,
    /**
     *	学习模式
     */
    TECH_MODE = 1,
    /**
     *	求解输入模式
     */
    SOlVE_Input_MODE=2,
    /**
     *	求解旋转模式
     */
    SOlVE_Play_MODE=3
} MagicCubeUIUsingMode;

/**
 *	最终的魔方造型
 */
@interface MCMagicCubeUIModelController : MCMobileObject{
    /**
     *	27个Cube类型构成的数组
     */
    NSMutableArray* array27Cube;
    /**
     *	需要旋转的那一层，共有9个Cube实例
     */
    Cube * layerPtr[9];

    /**
     *	auto rotate 
     */
    BOOL isAutoRotate;
    /**
     *	完成旋转所剩余的时间
     */
    double rest_rotate_time;
    /**
     *	完成旋转所剩余的角度
     */
    double rest_rotate_angle;
    
    /**
     *	教学模式下魔方整体旋转
     */
    BOOL isTribleAutoRotateIn_TECH_MODE;
    /**
     *	教学模式下魔方整体旋转 输入处理
     */
    BOOL is_TECH_MODE_Rotate;
    
    
    /**
     *	本次旋转的旋转轴
     */
    AxisType current_rotate_axis;
    /**
     *	本次旋转的旋转方向
     */
    LayerRotationDirectionType current_rotate_direction;
    /**
     *	本次需要旋转的层序号
     */
    int current_rotate_layer;
    
    //以下三个参数用于 视角变换
    BOOL m_spinning;
    float m_trackballRadius;
    ivec2 m_fingerStart;
   
    
    MCRay *ray;
    
    double cuculated_angle;
    
    vec3 directionVector[2];
    vec2 firstThreePoint[3];
    Cube *selected;
    float selected_triangle[9];
    float select_trackballRadius;
    int firstThreePointCount;
    /**
     *	是否正在执行单层任务
     */
    BOOL isLayerRotating;
    
    //自动调整机制
    /**
     *	手动转动点角度
     */
    double fingerRotate_angle;
    /**
     *	手动转动点角度 对90度取模
     */
    double fingerRotate_angle_mod90;
    double rest_fingerRotate_angle;
    double rest_fingerRotate_time;
    BOOL isNeededToAdjustment;
    BOOL isNeededToUpdateMagicCubeState;
    /**
     *	但转过的角度时180时，需要更新魔方数据模型两次
     */
    BOOL isNeededToUpadteTwice;
       
    //计步器
    id target;
    BOOL isAddStepWhenUpdateState;
	SEL stepcounterAddAction;
    SEL stepcounterMinusAction;
    /**
     *	撤销恢复管理栈
     */
    NSUndoManager *undoManger;
    //MCMagicCube *magicCube;
    UITouch *touch;
    int rrrr;
    /**
     *	魔方当前使用状态
     */
    MagicCubeUIUsingMode _usingMode;
    /**
     *	当前整个魔方索引的状态，存储索引值
     */
    Cube * MagicCubeIndexState[27];
    NSMutableArray * lockedarray;
    
    Cube * spaceIndicatorlayerPtr[9];
    //
    int selected_cube_index;
    int selected_cube_face_index;
    
    /**
     *	标记两层转动
     */
    BOOL twoLayerFlag[3];
}
@property (nonatomic,retain) NSMutableArray * lockedarray;
@property (assign) id target;
@property (assign) SEL stepcounterAddAction;
@property (assign) SEL stepcounterMinusAction;
@property (retain) NSMutableArray* array27Cube;
@property (retain) NSUndoManager* undoManger;
//是否使用教学模式下的操作模式
@property (assign) MagicCubeUIUsingMode usingMode;
@property (assign)int selected_cube_index;
@property (assign)int selected_cube_face_index;


-(id)initiate;
-(id)initiateWithState:(NSArray *)stateList;
-(void)flashWithState:(NSArray *)stateList;
- (void) rotateOnAxis : (AxisType)axis onLayer: (int)layer inDirection: (LayerRotationDirectionType)direction isTribleRotate:(BOOL)is_trible_roate isTwoTimes:(BOOL)is_twotimes;

- (void) nextSpaceIndicatorWithRotateNotationType:(struct RotateNotationType)rotationNotationType;

-(void)awake;
-(void)render;
-(void)update;
-(void)adjustWithCenter;
-(void)adjustWithCenter_2;
-(void)closeSpaceIndicator;
//撤销栈管理
-(void)executeInvocation:(NSInvocation *)invocation
      withUndoInvocation:(NSInvocation *)undoInvocation;
//恢复栈管理
-(void)unexecuteInvocation:(NSInvocation *)invocation
        withRedoInvocation:(NSInvocation *)redoInvocation;

-(void)previousSolution;
-(void)nextSolution;

-(BOOL)isSelectOneFace:(vec2)touchpoint;

-(vec3)MapToSphere:(vec2 )touchpoint;

-(void)switchToOrignalPlace;

@end
