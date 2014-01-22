//
//  MCButton.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCInputViewController.h"
/**
 *	按钮
 */
@interface MCButton : MCSceneObject{
	/**
	 *	是否按下
	 */
	BOOL pressed;
	/**
	 *	操作对象
	 */
	id target;
	/**
	 *	选择器类型，按下按钮的动作
	 */
	SEL buttonDownAction;
	/**
	 *	选择器类型，松开按钮的动作
	 */
	SEL buttonUpAction;
	CGRect screenRect;
    MCPoint originScale;
}

@property (assign) id target;
@property (assign) SEL buttonDownAction;
@property (assign) SEL buttonUpAction;

- (void)awake;
- (void)handleTouches;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;
- (void)touchDown;
- (void)touchUp;
- (void)showUp;
- (void)update;




@end
