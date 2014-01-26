//
//  InputControllerViewController.m
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputController.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "CoordinatingController.h"

@implementation InputController

@synthesize touchCount;
@synthesize touchEvents;
@synthesize fsm_Current_State,fsm_Previous_State;
@synthesize particleEmitter;
@synthesize lastpoint;
//@synthesize isNeededReload;

/**
 *	根据nib文件来初始化
 *
 *	@param	nibNameOrNil	nib文件名
 *	@param	niMCundleOrNil	nib所在的bundle
 *
 *	@return	self
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)niMCundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:niMCundleOrNil]) {
		// init our touch storage set
		touchEvents = [[NSMutableSet alloc] init];
		fsm_Current_State = kState_None;
        fsm_Previous_State = kState_None;
        touchCount = 0;
  //      isNeededReload=NO;
	}
	return self;
}

/**
 *	一个空函数
 */
-(void)loadView
{
	
}

/**
 *  find the point on the screen that is the center of the rectangle
 *  and use that to build a screen-space rectangle
 *
 *  得到屏幕上给定的矩形的中心点，并用此来建立一个位于屏幕的矩形。
 *	从网孔映射中得到对应的屏幕映射。
 *
 *	@param	rect	需要定位的矩形
 *	@param	meshCenter	网孔的中心
 *
 *	@return	对应的屏幕矩形区域
 */
-(CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter
{
	CGPoint screenCenter = CGPointZero;
	CGPoint rectOrigin = CGPointZero;
	// since our view is rotated, then our x and y are flipped
	screenCenter.x = meshCenter.x + 512.0; // need to shift it over
	screenCenter.y = meshCenter.y - 384.0; // need to shift it up
    screenCenter.y = -screenCenter.y;
	rectOrigin.x = screenCenter.x - (CGRectGetWidth(rect)/2.0); // height and width 
	rectOrigin.y = screenCenter.y - (CGRectGetHeight(rect)/2.0); // are flipped
    return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetWidth(rect), CGRectGetHeight(rect));
}


#pragma mark Touch Event Handlers

/**
 *  just a handy way for other object to clear our events
 *
 *  提供一个基础的方法来清空事件对象
 */
- (void)clearEvents
{
	[touchEvents removeAllObjects];
}

#pragma mark touches

/**
 *  取消触摸事件
 */
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    touchCount = 0;
}

/**
 *	处理开始触摸事件，并产生粒子效果
 *
 *	@param	touches	触摸点的位置的集合
 *	@param	event	UI事件
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //轨迹跟踪粒子
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch previousLocationInView:self.view];
    particleEmitter.translation = MCPointMake(location.x-512, -(location.y-384),-1);
    particleEmitter.emit = YES;
    
    
    for (int i = 0; i<[touches count];i++) {
        touchCount++;
    }
    //正常
    // 过多的触屏
    if (touchCount>2 && fsm_Previous_State == kState_None) {
        
        return;
    }
    
    //正常1
    // 单指触屏
    if (touchCount==1 && fsm_Previous_State==kState_None) {
        fsm_Previous_State = kState_None;
        fsm_Current_State = kState_S1;
    }

    //双手
    // 双点触屏的两种情况
    if (touchCount==2 && (fsm_Current_State==kState_S1)) {
        fsm_Current_State = kState_S2;
        fsm_Previous_State = kState_None;
    }else  //双手
        if (touchCount==2&&(fsm_Previous_State==kState_None)) {
            fsm_Current_State = kState_S2;
            fsm_Previous_State = kState_None;
            // just store them all in the big set.
            //[touchEvents addObjectsFromArray:[touches allObjects]];
        }
    
        //单手异常
    //正在进行单层转动，突然多了一个,或多个手指，结束单层转动。
    if (touchCount>=2&&(fsm_Current_State==kState_M1)) {
        fsm_Current_State = kState_F1;
        fsm_Previous_State = kState_None;
        //touchCount = 0 ;
    }
    //正在进行视角变换，突然多了一个,或多个手指，结束视角变换。
    if (touchCount>=3&&(fsm_Current_State==kState_M2)) {
        fsm_Current_State = kState_F2;
        fsm_Previous_State = kState_None;
        //touchCount = 0 ;
    }
    [touchEvents addObjectsFromArray:[touches allObjects]];
    
}

/**
 *	处理触控点移动事件，并产生粒子效果
 *
 *	@param	touches	触摸点位置的集合
 *	@param	event	UI事件
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 多于两点的触控请忽略
    if ([touches count]>2) {
        return;
    }
    
    //轨迹跟踪粒子，该部分可以提炼成一个方法
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch previousLocationInView:self.view];
    particleEmitter.translation = MCPointMake(location.x-512, -(location.y-384),-1);
    
    //单层正常第一次move 发生单层状态切换
    if (touchCount==1&&fsm_Current_State == kState_S1) {
        fsm_Previous_State = fsm_Current_State;
        fsm_Current_State = kState_M1;
        //[touchEvents addObjectsFromArray:[touches allObjects]];
    }
    //单手指正常Move
    if (touchCount==1&&fsm_Current_State == kState_M1) {
    
    }
    //
    //有两个手指，但是只有一个移动 touch=1
    if (touchCount==2&&[touches count]!=2) {
        return;
    }
    
    if (touchCount==2&&fsm_Current_State == kState_M2) {
        fsm_Previous_State = kState_M2;
    }

    //视角变换.第一次双手指移动 发生状态切换
    if (touchCount==2&&fsm_Current_State == kState_S2) {
        fsm_Previous_State = fsm_Current_State;
        fsm_Current_State = kState_M2;
    }

    //视角变换.第一次双手指移动 发生状态切换
    if (touchCount==1&&fsm_Current_State == kState_F2) {
        fsm_Previous_State = kState_None;
        fsm_Current_State = kState_None;
    }

    // just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
     
}

/**
 *	处理触控结束事件，并结束粒子效果
 *
 *	@param	touches	触摸点位置的集合
 *	@param	event	UI事件
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //if ([touches count]>2) {
    //    return;
    //}
    //轨迹跟踪粒子
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch locationInView:self.view];
    particleEmitter.translation = MCPointMake(location.x-512, -(location.y-384),-1);
    particleEmitter.emit = NO;
    //单层正常结束
    //NSLog(@"[touches count]=%d",[touches count]);
    if (touchCount==1&&fsm_Current_State==kState_M1) {
        fsm_Current_State = kState_F1;
        fsm_Previous_State = kState_None;
        //touchCount=0;
    }
    
    if (touchCount==2&&fsm_Current_State==kState_M2) {
        fsm_Previous_State = kState_None;
        fsm_Current_State = kState_F2;
        //touchCount=0;
        [self clearEvents];
    }
    
    if ((fsm_Current_State == kState_S2)&&(fsm_Previous_State==kState_None)) {
        fsm_Previous_State = kState_None;
        fsm_Current_State = kState_F2;
        //touchCount =0;
    }
    if ((fsm_Current_State == kState_S1)&&(fsm_Previous_State==kState_None)) {
        fsm_Previous_State = kState_None;
        fsm_Current_State = kState_F1;
        //touchCount =0;
    }
    for (int i = 0; i<[touches count];i++) {
        touchCount--;
    }
    if (touchCount<0) {
        touchCount=0;
    }
    lastpoint = location;
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
    
    //if(touch.phase==UITouchPhaseEnded)NSLog(@"phase:end");
    //NSLog(@"touch:in(%f,%f)",location.x,location.y);
    
}

#pragma mark Autorotate
/**
 *	响应屏幕旋转事件
 *
 *	@param	interfaceOrientation	屏幕朝向，横向或纵向
 *
 *	@return	是否响应屏幕的旋转
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}



#pragma mark unload, dealloc
/**
 *	处理内存警告
 *
 *  交由父类进行处理
 */
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

/**
 *	处理视图无法加载的问题
 *
 *  不做任何处理
 */
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/**
 *	加载视图所做的动作。可由子类进行覆盖。
 */
-(void)loadInterface
{
	//implemented by sub class
    particleEmitter = [[MCParticleSystem alloc] init];
	particleEmitter.emissionRange = MCRangeMake(1.0, 0.0);
	particleEmitter.sizeRange = MCRangeMake(8.0, 0.0);
	particleEmitter.growRange = MCRangeMake(-0.5, 0.0);
	
	particleEmitter.xVelocityRange = MCRangeMake(0.0, 0.0);
	particleEmitter.yVelocityRange = MCRangeMake(0.0, 0.0);
	
	particleEmitter.lifeRange = MCRangeMake(5, 0.0);
	particleEmitter.decayRange = MCRangeMake(0.02, 0.00);
    
	[particleEmitter setParticle:@"lightBlur"];
	particleEmitter.emit = NO;
    [[[CoordinatingController sharedCoordinatingController] currentController] addObjectToScene:particleEmitter];

}

/**
 *	更新视图。
 *  通过调用各场景对象的update方法来更新视图。
 */
-(void)updateInterface
{
	[interfaceObjects makeObjectsPerformSelector:@selector(update)];
}

/**
 *	渲染视图。
 *  通过调用各场景对象的render方法来渲染视图。
 */
-(void)renderInterface
{
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	//glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
	
	// set up the viewport so that it is analagous to the screen pixels
	glOrthof(-512, 512, -384, 384, -1.0f, 50.0f);
	glMatrixMode(GL_MODELVIEW);
	glDisable(GL_LIGHTING);
	glDisable(GL_CULL_FACE);
    //	glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
	// simply call 'render' on all our scene objects
	[interfaceObjects makeObjectsPerformSelector:@selector(render)];
    
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
    
}

/**
 *	撤销视图
 */
-(void)releaseInterface{
    [interfaceObjects removeAllObjects];
}

/**
 *	是否可以响应屏幕旋转
 *
 *	@return	是的
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

/**
 *	返回支持的屏幕旋转类型
 *
 *	@return	UIInterfaceOrientationMaskLandscape
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)dealloc 
{
	[touchEvents release];
	[super dealloc];
}
@end
