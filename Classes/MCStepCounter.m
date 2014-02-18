//
//  MCStepCounter.m
//  MCGame
//
//  Created by kwan terry on 13-2-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCStepCounter.h"

@implementation MCStepCounter

/**
 *	加载10个纹理图层，分别代表10个数字，作为计步器的图层背景
 *
 *	@param	Keys	数字图层所在的纹理名数组
 *
 *	@return	初始化了纹理数组的MCStepCounter
 */
- (id) initWithUpKeyS:(NSString*[])Keys{
    self = [super init];
	if (self != nil) {
        for (int i = 0; i<10; i++) {
            m_numberQuad[i] = [[MCMaterialController sharedMaterialController]quadFromAtlasKey:Keys[i]];
            [m_numberQuad[i] retain];
        }
    }
	return self;
};

/**
 *	设置纹理为0的值
 */
- (void)reset{
    [self setNumberQuad:0];
};

- (void)awake{
    [self setNumberQuad:0];
};

- (void)update{
    [super update];
};

/**
 *	设置背景纹理为对应的数字值
 *
 *	@param	index	0-9的索引
 */
- (void)setNumberQuad:(NSInteger)index{
    self.mesh = m_numberQuad[index];
};

- (void)dealloc{
    for (int i = 0; i<10; i++) {
        [m_numberQuad[i] release];
    }
	[super dealloc];
};


@end
