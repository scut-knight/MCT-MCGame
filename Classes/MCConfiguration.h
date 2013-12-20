//
//  MCConfiguration.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
/**
 *  this is the config file
 *  it holds all the constants and other various and sundry items that
 *  we need and dont want to hardcode in the code
 *
 *  配置文件,包括一些需要的宏和设置
 */

#pragma mark - #define

/**
 *	以当前时间为种子，生成随机数
 */
#define RANDOM_SEED() srandom(time(NULL))
/**
 *	返回min到max之间随机的一个数。范围属于[min,max]区间
 *
 *	@param	__MIN__	下界
 *	@param	__MAX__	上界
 *
 *	@return	min到max之间随机的一个数
 */
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

/**
 * will draw the circles around the collision radius
 * for debugging(如果该项设为1，则开启debug)
 */
#define DEBUG_DRAW_COLLIDERS 0

/**
 * the explosive force applied to the smaller rocks after a big rock has been smashed
 * 
 * 现在已经没有用了。
 */
//以下四项在其他文件没有用到
#define SMASH_SPEED_FACTOR 40
#define TURN_SPEED_FACTOR 3.0
#define THRUST_SPEED_FACTOR 1.2
// a handy constant to keep around
#define MCRADIANS_TO_DEGREES 57.2958

/**
 * material import settings
 *
 * debug开关，如果设置为1，则MCMaterialController.m处测试一个临时数据
 */
#define MC_CONVERT_TO_4444 0


// for particles
/**
 *	MCParticle总量
 */
#define MC_MAX_PARTICLES 500

/**
 *	场景动画每秒帧数
 */
#define MC_FPS 60.0

//
/**
 *	打乱时最大的打乱步数
 */
#define RandomRotateMaxCount 20

/**
 * 教学模式下让模型旋转对最大预知
 */
#define MaxDistance 160

#pragma mark - enum
/**
 *	暂停选择，此时可以要求是否重新加载，或者退出
 */
typedef enum _AskReloadType {
    kAskReloadView_LoadLastTime  = 0,
    kAskReloadView_Reload,
    kAskReloadView_Cancel,
    kAskReloadView_Default
} AskReloadType;

/**
 * for view transition 视图变换的key
 */
typedef enum {
    kCountingPlay,
    kNormalPlay,
    kRandomSolve,
    kSystemSetting,
    kHeroBoard,
    kMainMenu,
    kScoreBoard2MainMenu,
    kSystemSetting2MainMenu
}ViewTransitionTag;

/**
 *	完成视图的类型
 */
typedef enum _FinishViewType {
    kFinishView_GoBack= 0,
    kFinishView_ChangeName,
    kFinishView_OneMore,
    kFinishView_GoCountingPlay,
    kFinishView_Share,
    kFinishView_Default
} FinishViewType;

/**
 * for 魔方模型交互算法key
 */
typedef enum {
    kState_None,
    kState_S1,
    kState_M1,
    kState_F1,
    kState_A1,
    kState_S2,
    kState_M2,
    kState_F2
}FSM_Interaction_State;





#pragma mark cubre mesh
// 以下内容均被用于.mm文件中，却被编译器错误地当作未使用变量。所以不要除去这一部分

static NSInteger MCCubreVertexStride = 3;
static NSInteger MCCubreColorStride = 4;
static NSInteger MCCubreOutlineVertexesCount = 36;
 
static CGFloat MCCubreOutlineVertexes[108] = {    
    //Define the front face
    -0.5,0.5,0.5,//left top
    -0.5,-0.5,0.5,//left buttom
    0.5,0.5,0.5,//top right
    -0.5,-0.5,0.5,//left buttom     
    0.5,-0.5,0.5,//right buttom
    0.5,0.5,0.5,//top right
    //top face
    -0.5,0.5,-0.5,//left top(at rear)
    -0.5,0.5,0.5,//left buttom(at front)
    0.5,0.5,-0.5,//top right(at rear)
    -0.5,0.5,0.5,//left buttom(at front)
    0.5,0.5,0.5,//right buttom(at front)
    0.5,0.5,-0.5,//top right(at rear)
    //rear face
    0.5,0.5,-0.5,//right top(when viewed from front)    
    0.5,-0.5,-0.5,//left top
    -0.5,0.5,-0.5,//rigtht buttom
    0.5,-0.5,-0.5,//rigtht buttom
    -0.5,-0.5,-0.5,//left top
    -0.5,0.5,-0.5,//left buttom
    //buttom face
    -0.5,-0.5,0.5,//buttom left front
    -0.5,-0.5,-0.5,//left rear
    0.5,-0.5,0.5,//rigtht buttom
    0.5,-0.5,0.5,//rigtht buttom
    -0.5,-0.5,-0.5,//left rear
    0.5,-0.5,-0.5,//right rear
    //left face
    -0.5,0.5,-0.5,// top left
    -0.5,-0.5,-0.5,//buttom left
    -0.5,0.5,0.5,// top right
    -0.5,-0.5,-0.5,//buttom left
    -0.5,-0.5,0.5,//buttom right
    -0.5,0.5,0.5,// top right
    //right face
    0.5,0.5,0.5,//top left    
    0.5,-0.5,0.5,//left
    0.5,0.5,-0.5,//top right
    0.5,-0.5,0.5,//left
    0.5,-0.5,-0.5,//right
    0.5,0.5,-0.5//top right
};

static CGFloat MCCubreColorValues[144] = 
{   1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0} ;


static NSInteger MCCubreVertexStride_line = 3;
static NSInteger MCCubreColorStride_line = 4;
static NSInteger MCCubreOutlineVertexesCount_line = 48;
static CGFloat MCCubreOutlineVertexes_line[144] = {    
    //Define the front face
    -0.5,0.5,0.5,//left top
    -0.5,-0.5,0.5,//left buttom
    
    -0.5,0.5,0.5,//left top
    0.5,0.5,0.5,//top right
    
    -0.5,-0.5,0.5,//left buttom     
    0.5,-0.5,0.5,//right buttom
    
    0.5,0.5,0.5,//top right
    0.5,-0.5,0.5,//right buttom
    
    //top face
    
    -0.5,0.5,-0.5,//left top(at rear)
    -0.5,0.5,0.5,//left buttom(at front)
    
    -0.5,0.5,-0.5,//left top(at rear)
    0.5,0.5,-0.5,//top right(at rear)
    
    -0.5,0.5,0.5,//left buttom(at front)
    0.5,0.5,0.5,//right buttom(at front)
    
    0.5,0.5,0.5,//right buttom(at front)
    0.5,0.5,-0.5,//top right(at rear)
    
    //rear face
    0.5,0.5,-0.5,//right top(when viewed from front)    
    0.5,-0.5,-0.5,//left top
    
    0.5,0.5,-0.5,//right top(when viewed from front) 
    -0.5,0.5,-0.5,//rigtht buttom
    
    0.5,-0.5,-0.5,//rigtht buttom
    -0.5,-0.5,-0.5,//left top
    
    -0.5,-0.5,-0.5,//left top
    -0.5,0.5,-0.5,//left buttom
    //buttom face
    -0.5,-0.5,0.5,//buttom left front
    -0.5,-0.5,-0.5,//left rear
    
    -0.5,-0.5,0.5,//buttom left front
    0.5,-0.5,0.5,//rigtht buttom
    
    0.5,-0.5,0.5,//rigtht buttom
    0.5,-0.5,-0.5,//left rear
    
    -0.5,-0.5,-0.5,//left rear
    0.5,-0.5,-0.5,//right rear
    //left face
    -0.5,0.5,-0.5,// top left
    -0.5,-0.5,-0.5,//buttom left
    
    -0.5,0.5,-0.5,// top left
    -0.5,0.5,0.5,// top right
    
    -0.5,-0.5,-0.5,//buttom left
    -0.5,-0.5,0.5,//buttom right
    
    -0.5,-0.5,0.5,//buttom right
    -0.5,0.5,0.5,// top right
    //right face
    0.5,0.5,0.5,//top left    
    0.5,-0.5,0.5,//left
    
    0.5,0.5,0.5,//top left    
    0.5,0.5,-0.5,//top right
    
    0.5,-0.5,0.5,//left
    0.5,-0.5,-0.5,//right
    
    0.5,-0.5,-0.5,//right
    0.5,0.5,-0.5//top right
};

static CGFloat MCCubreColorValues_line[192] = 
{   1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0,
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0} ;

