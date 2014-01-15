//
//  MCParticle.m
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCParticle.h"

@implementation MCParticle

@synthesize position,velocity;
@synthesize life,decay;
@synthesize size,grow;


-(void)update{
    // 更新坐标
    position.x += velocity.x;
	position.y += velocity.y;
	position.z += velocity.z;
	
	life -= decay;
	size += grow;
    // 确保大小不是负值
	if (size < 0.0) size = 0.0;
    
    // 因为生命值为负的粒子会被回收，所以不用确认生命值的合理性
}
@end
