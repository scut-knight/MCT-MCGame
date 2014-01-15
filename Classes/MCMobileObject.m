//
//  MCMobileObject.m
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMobileObject.h"
#import "CoordinatingController.h"

@implementation MCMobileObject

@synthesize speed,rotationalSpeed;

/**
 *	called once every frame, 
 *  sublcasses need to remember to call this method via [super update]
 *
 *  供子类调用的update方法。注意不要覆盖掉它。
 */
-(void)update
{
	CGFloat deltaTime = [[[CoordinatingController sharedCoordinatingController] currentController] deltaTime];
	translation.x += speed.x * deltaTime;
	translation.y += speed.y * deltaTime;
	translation.z += speed.z * deltaTime;
	
	prerotation.x += rotationalSpeed.x * deltaTime;
	prerotation.y += rotationalSpeed.y * deltaTime;
	prerotation.z += rotationalSpeed.z * deltaTime;
    
	[self checkArenaBounds];
	[super update];
}

/**
 * it is a method used 。。。。！妈的！又不会说了
 *
 *  用这个函数让可移动的对象能够，当它从屏幕下方（或左方）移出时，回从另外一方滚回来
 *  
 *  以上内容不是维护者(我)添加的，对其粗口不负任何责任。
 *
 *  就是把屏幕变成类似球面的东西，让移动对象可以在球幕上移动。
 */
-(void)checkArenaBounds
{
    // 注意这里的屏幕大小是硬编码的。需要修改。TODO：修改硬编码的屏幕大小
    float width = 1024;
    float height = 768;
    
	if (translation.x > (width/2 + CGRectGetWidth(self.meshBounds)/2.0))
        translation.x -= width + CGRectGetWidth(self.meshBounds);
	if (translation.x < (-width/2 - CGRectGetWidth(self.meshBounds)/2.0))
        translation.x += width + CGRectGetWidth(self.meshBounds);
    
	if (translation.y > (height/2 + CGRectGetHeight(self.meshBounds)/2.0))
        translation.y -= height + CGRectGetHeight(self.meshBounds);
	if (translation.y < (-height/2 - CGRectGetHeight(self.meshBounds)/2.0))
        translation.y += height + CGRectGetHeight(self.meshBounds);
}

@end
