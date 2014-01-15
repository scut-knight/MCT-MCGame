//
//  MCAnimatedQuad.h
//  MCGame
//
//  Created by kwan terry on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCTexturedQuad.h"
/**
 *	动画方块。
 *  每一帧动画都是一个MCTexturedQuad
 */
@interface MCAnimatedQuad : MCTexturedQuad{
    NSMutableArray * frameQuads;
	/**
	 *	帧数
	 */
	CGFloat speed;
	NSTimeInterval elapsedTime;
	/**
	 *	是否循环播放各帧
	 */
	BOOL loops;
	BOOL didFinish;
}

@property (assign) CGFloat speed;
@property (assign) BOOL loops;
@property (assign) BOOL didFinish;

- (id) init;
- (void) dealloc;
- (void)addFrame:(MCTexturedQuad*)aQuad;
- (void)setFrame:(MCTexturedQuad*)quad;
- (void)updateAnimation;


@end
