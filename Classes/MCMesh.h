//
//  MCMesh.h
//  
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "MCPoint.h"
#import "MCSceneController.h"

/**
 *	这个类表示一个由顶点包围的，被用于渲染的区域。
 *  用作基类。
 */
@interface MCMesh : NSObject {
	// mesh data
	GLfloat * vertexes;
	GLfloat * colors;
	
	/**
	 *	渲染模式
	 */
	GLenum renderStyle;
    
	NSInteger vertexCount;
	NSInteger vertexSize;
	NSInteger colorSize;	
	
	/**
	 *	中心点
	 */
	MCPoint centroid;
	/**
	 *	最大半径
	 */
	CGFloat radius;
}

@property (assign) NSInteger vertexCount;
@property (assign) NSInteger vertexSize;
@property (assign) NSInteger colorSize;
@property (assign) GLenum renderStyle;

@property (assign) MCPoint centroid;
@property (assign) CGFloat radius;

@property (assign) GLfloat * vertexes;
@property (assign) GLfloat * colors;

- (id)initWithVertexes:(CGFloat*)verts 
           vertexCount:(NSInteger)vertCount 
            vertexSize:(NSInteger)vertexSize
           renderStyle:(GLenum)style;

+(CGRect)meshBounds:(MCMesh*)mesh scale:(MCPoint)scale;

-(MCPoint)calculateCentroid;
-(CGFloat)calculateRadius;
-(void)render;

@end
