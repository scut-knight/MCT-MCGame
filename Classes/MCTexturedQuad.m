//
//  MCTexturedQuad.m
//  MCGame
//
//  Created by kwan terry on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCTexturedQuad.h"
/**
 *	纹理坐标
 *  
 *  一个立方体有八个顶点。
 */
static CGFloat MCTexturedQuadVertexes[8] = {-0.5,-0.5, 0.5,-0.5, -0.5,0.5, 0.5,0.5};
/**
 *	颜色坐标。
 *
 *  RGB和alpha共四种参数，所以是4*4的矩阵。
 */
static CGFloat MCTexturedQuadColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation MCTexturedQuad

@synthesize uvCoordinates,materialKey;

- (id) init
{
	self = [super initWithVertexes:MCTexturedQuadVertexes vertexCount:4 vertexSize:2 renderStyle:GL_TRIANGLE_STRIP];
	if (self != nil) {
		// 4 vertexes
		uvCoordinates = (CGFloat *) malloc(8 * sizeof(CGFloat));
		colors = MCTexturedQuadColorValues;
		colorSize = 4;
	}
	return self;
}

// called once every frame
-(void)render
{
	glVertexPointer(vertexSize, GL_FLOAT, 0, vertexes); // 定义一个顶点数组
	glEnableClientState(GL_VERTEX_ARRAY);   // 激活并写入顶点数组
	glColorPointer(colorSize, GL_FLOAT, 0, colors);	// 定义一个颜色数组
	glEnableClientState(GL_COLOR_ARRAY);	// 激活并写入颜色数组
	
	if (materialKey != nil) {
        // 记录纹理类型
		[[MCMaterialController sharedMaterialController] bindMaterial:materialKey];
        
        // 以下两步顺序可以互换
		glEnableClientState(GL_TEXTURE_COORD_ARRAY); // 激活并写入纹理数组
		glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates); //定义一个纹理数组
	} 
	//render
    // 从数组数据来渲染图元
	glDrawArrays(renderStyle, 0, vertexCount);	
}


- (void) dealloc
{
	free(uvCoordinates);
	[super dealloc];
}

@end
