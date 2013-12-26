//
//  MC    Mesh.m
//  
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCMesh.h"


@implementation MCMesh

@synthesize vertexCount,vertexSize,colorSize,renderStyle,vertexes,colors,centroid,radius;
/**
 *	初始化MCMesh
 *
 *	@param	verts	顶点数组
 *	@param	vertCount	顶点个数
 *	@param	vertSize	顶点大小
 *	@param	style	渲染方式
 */
- (id)initWithVertexes:(CGFloat*)verts 
           vertexCount:(NSInteger)vertCount 
            vertexSize:(NSInteger)vertSize
           renderStyle:(GLenum)style;
{
	self = [super init];
	if (self != nil) {
		self.vertexes = verts;
		self.vertexCount = vertCount;
		self.vertexSize = vertSize;
		self.renderStyle = style;
		self.centroid = [self calculateCentroid];
		self.radius = [self calculateRadius];
	}
	return self;
}
/**
 *	计算中点
 *
 *	@return	MCPoint(centerX,centerY,0.0)
 */
-(MCPoint)calculateCentroid
{
	CGFloat xTotal = 0;
	CGFloat yTotal = 0;
	CGFloat zTotal = 0;
	NSInteger index;
	// step through each vertex and add them all up
	for (index = 0; index < vertexCount; index++) {
		NSInteger position = index * vertexSize;
		xTotal += vertexes[position];
		yTotal += vertexes[position + 1];
		if (vertexSize > 2) zTotal += vertexes[position + 2];
	}
	// now average each total over the number of vertexes
    //	return MCPointMake(xTotal/(CGFloat)vertexCount, yTotal/(CGFloat)vertexCount, zTotal/(CGFloat)vertexCount);
    // 注意z轴坐标上的值恒为0.0
	return MCPointMake(xTotal/(CGFloat)vertexCount, yTotal/(CGFloat)vertexCount, 0.0);
}

/**
 *	计算半径，注意这个不是圆，其半径为中点到最远顶点的距离
 *
 *	@return	CGFloat类型的半径值
 */
-(CGFloat)calculateRadius
{
	CGFloat rad = 0.0;
	NSInteger index;
	for (index = 0; index < vertexCount; index++) {
		NSInteger position = index * vertexSize;
		MCPoint vert;
		if (vertexSize > 2) {
			vert = MCPointMake(vertexes[position], vertexes[position + 1], vertexes[position + 2]);		
		} else {
			vert = MCPointMake(vertexes[position], vertexes[position + 1], 0.0);
		}
		CGFloat thisRadius = MCPointDistance(centroid, vert);
		if (rad < thisRadius) rad = thisRadius;
	}
	return rad;
}


// called once every frame
-(void)render
{
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	// load arrays into the engine
	glVertexPointer(vertexSize, GL_FLOAT, 0, vertexes);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(colorSize, GL_FLOAT, 0, colors);	
	glEnableClientState(GL_COLOR_ARRAY);
	
	//render
	glDrawArrays(renderStyle, 0, vertexCount);	
}

/**
 *	计算MCMesh的边界
 *
 *	@param	mesh	输入的MCMesh
 *	@param	scale	以向量表示的缩放尺度
 *
 *	@return	如果mesh的边数小于三，返回CGRectZero；否则返回一个至少为1.0 * 1.0的CGRect类型
 */
+(CGRect)meshBounds:(MCMesh*)mesh scale:(MCPoint)scale
{
	if (mesh == nil) return CGRectZero;
	// need to run through my vertexes and find my extremes
	if (mesh.vertexCount < 2) return CGRectZero;
    
	CGFloat xMin,yMin,xMax,yMax;
	xMin = xMax = mesh.vertexes[0];
	yMin = yMax = mesh.vertexes[1];
	NSInteger index;
	for (index = 0; index < mesh.vertexCount; index++) {
		NSInteger position = index * mesh.vertexSize;
		if (xMin > mesh.vertexes[position] * scale.x) xMin = mesh.vertexes[position] * scale.x;
		if (xMax < mesh.vertexes[position] * scale.x) xMax = mesh.vertexes[position] * scale.x;
		if (yMin > mesh.vertexes[position + 1] * scale.y) yMin = mesh.vertexes[position + 1] * scale.y;
		if (yMax < mesh.vertexes[position + 1] * scale.y) yMax = mesh.vertexes[position + 1] * scale.y;
	}
	CGRect meshBounds = CGRectMake(xMin, yMin, xMax - xMin, yMax - yMin);
	if (CGRectGetWidth(meshBounds) < 1.0) meshBounds.size.width = 1.0;
	if (CGRectGetHeight(meshBounds) < 1.0) meshBounds.size.height = 1.0;
	return meshBounds;
}

- (void) dealloc
{
	[super dealloc];
}



@end
