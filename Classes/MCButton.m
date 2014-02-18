//
//  MCButton.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCButton.h"
#import "CoordinatingController.h"


#pragma mark square
static NSInteger MCSquareVertexSize = 2;
static NSInteger MCSquareColorSize = 4;
// 未按下的外观
static GLenum MCSquareOutlineRenderStyle = GL_LINE_LOOP;
static NSInteger MCSquareOutlineVertexesCount = 4;
static CGFloat MCSquareOutlineVertexes[8] = {-0.5f, -0.5f, 0.5f,  -0.5f, 0.5f,   0.5f, -0.5f,  0.5f};
static CGFloat MCSquareOutlineColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};
// 按下后的外观
static GLenum MCSquareFillRenderStyle = GL_TRIANGLE_STRIP;
static NSInteger MCSquareFillVertexesCount = 4;
static CGFloat MCSquareFillVertexes[8] = {-0.5,-0.5, 0.5,-0.5, -0.5,0.5, 0.5,0.5};


@implementation MCButton

@synthesize buttonDownAction,buttonUpAction,target;

/**
 * called once when the object is first created.
 */
-(void)awake
{
	pressed = NO;
	mesh = [[MCMesh alloc] initWithVertexes:MCSquareOutlineVertexes vertexCount:MCSquareOutlineVertexesCount vertexSize:MCSquareVertexSize renderStyle:MCSquareOutlineRenderStyle];
	mesh.colors = MCSquareOutlineColorValues;
	mesh.colorSize = MCSquareColorSize;
    
	screenRect = [[[CoordinatingController sharedCoordinatingController] currentController].inputController 
                  screenRectFromMeshRect:self.meshBounds 
                  atPoint:CGPointMake(translation.x, translation.y)];

	// this is a bit rendundant, but allows for much simpler subclassing
	[self setNotPressedVertexes];
}

/**
 * called once every frame
 */
-(void)update
{
	// check for touches
	[self handleTouches];
	[super update];
}

/**
 *	设置按下按钮后的外观
 */
-(void)setPressedVertexes
{
	mesh.vertexes = MCSquareFillVertexes;
	mesh.renderStyle = MCSquareFillRenderStyle;
	mesh.vertexCount = MCSquareFillVertexesCount;	
	mesh.colors = MCSquareOutlineColorValues;
}

/**
 *	设置未按下按钮时的外观
 */
-(void)setNotPressedVertexes
{
	mesh.vertexes = MCSquareOutlineVertexes;
	mesh.renderStyle = MCSquareOutlineRenderStyle;
	mesh.vertexCount = MCSquareOutlineVertexesCount;	
	mesh.colors = MCSquareOutlineColorValues;
}

/**
 *	处理触摸事件
 */
-(void)handleTouches
{
	NSSet * touches = [[[CoordinatingController sharedCoordinatingController] currentController].inputController touchEvents];
	if ([touches count] == 0) return;
	BOOL pointInBounds = NO;
    FSM_Interaction_State fsm_Current_State = [[[CoordinatingController sharedCoordinatingController] currentController].inputController fsm_Current_State];
	CGPoint lastpoint = [[[CoordinatingController sharedCoordinatingController] currentController].inputController lastpoint];
    // 处理每一点触控
    for (UITouch * touch in [touches allObjects]) {
        CGPoint touchPoint = [touch previousLocationInView:[touch view]];
        if (touch.phase == UITouchPhaseEnded && fsm_Current_State==kState_F1){
            if (CGRectContainsPoint(screenRect, lastpoint)) {
                [self touchUp];
                break;
            }
        }
		if (CGRectContainsPoint(screenRect, touchPoint)) {
			pointInBounds = YES;
			if ((touch.phase == UITouchPhaseBegan)||((touch.phase == UITouchPhaseStationary))) {
                [self touchDown];
            }
        }
	}
    if (!pointInBounds) {
        [self showUp];
    }
	
}

/**
 *	按下按钮了
 */
-(void)touchUp
{
	if (!pressed) return; // we were already up
	pressed = NO;
	[self setNotPressedVertexes];
    
	[target performSelector:buttonUpAction];
}

/**
 *	按下按钮，但是是无效的，无需产生buttonUpAction动作
 */
-(void)showUp
{
	if (!pressed) return; // we were already up
	pressed = NO;
	[self setNotPressedVertexes];
}

/**
 *	松开按钮
 */
-(void)touchDown
{
	if (pressed) return; // we were already down
	pressed = YES;
	[self setPressedVertexes];
	[target performSelector:buttonDownAction];
}


@end
