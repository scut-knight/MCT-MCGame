//
//  MCPoint.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


// MCPoint is a 3d point struct.  
// this is the definition of that struct and a hand ful of inline functions for manipulating the point.

// A 3D point
#include "Vector.hpp"
/**
 *	3D 点 (拥有一系列内联函数用于点与点的运算)
 *
 *  这里多次出现CGFloat[16]。CGFloat[16] 是用于矩阵变换的4*4矩阵。为什么是4*4？
 *  在关于OpenGL的描述中，我们知道OpenGL有三种矩阵，一种是模型视图矩阵，另一种是投影矩阵，还有一种是纹理矩阵。
 *
 *  比如在下面华中科技大学的计算机图形学对OpenGL的描述中：
 *
 *  http://cs.hust.edu.cn/webroot/courses/csgraphics/jiaocai.php?bookpage=7_h
 *
 *  这里有一句：“模型视图矩阵是一个4×4的矩阵，用于指定场景的视图变换和几何变换。”
 *
 *  另，按维基百科的说法，n维空间的仿射变换与透视投影可以用n+1维的线性变换表示，所以3维空间的变换可以用4*4矩阵表示
 *  你可能会感到奇怪，4x4矩阵有4个分量，前三个分量应该与空间的三个维度有关，那么第四个分量是做什么的？
 *  下面的网址会帮助你解答这个疑问：
 *
 *  http://www.opengl-tutorial.org/zh-hans/beginners-tutorials-zh/tutorial-3-matrices-zh/
 *  
 */
typedef struct {
	CGFloat			x, y, z;
} MCPoint;

/**
 *	MCPoint 指针
 */
typedef MCPoint* MCPointPtr;

/**
 * 返回一个MCPoint，类似于CGPointMake
 */
static inline MCPoint MCPointMake(CGFloat x, CGFloat y, CGFloat z)
{
	return (MCPoint) {x, y, z};
}

/**
 *	返回一个描述MCPoint的字符串
 *	@return	@{x.xx,y.yy,z.zz}
 */
static inline NSString * NSStringFromMCPoint(MCPoint p)
{
	return [NSString stringWithFormat:@"{%3.2f, %3.2f, %3.2f}",p.x,p.y,p.z];
}

/**
 *	以CGFloat类型作为开始和长度的一个Range结构体，类似于CGRange
 */
typedef struct {
	CGFloat			start, length;
} MCRange;

/**
 *	类似于CGRangeMake
 */
static inline MCRange MCRangeMake(CGFloat start, CGFloat len)
{
	return (MCRange) {start,len};
}

/**
 *	返回一个描述MCRange的字符串
 *	@return	@{x.xx,y.yy}
 */
static inline NSString * NSStringFromMCRange(MCRange p)
{
	return [NSString stringWithFormat:@"{%3.2f, %3.2f}",p.start,p.length];
}

/**
 *	返回一个在range内的浮点数
 *  精度到小数点后三位
 */
static inline CGFloat MCRandomFloat(MCRange range) 
{
	// return a random float in the range
	CGFloat randPercent = ( (CGFloat)(random() % 1001) )/1000.0;
    // 0 <= randPercent <= 1.000
	CGFloat offset = randPercent * range.length;
	return offset + range.start;	
}

/**
 *	接受一个CGFloat[16]数组，并且将它输出成描述本身的字符串
 *
 *	@param	m	CGFloat[16]
 *
 *	@return	@"x.xx y.yy z.zz k.kk"类似这样的4 * 4 矩阵
 */
static inline NSString * NSStringFromMatrix(CGFloat * m)
{
	return [NSString stringWithFormat:@"%3.2f %3.2f %3.2f %3.2f\n%3.2f %3.2f %3.2f %3.2f\n%3.2f %3.2f %3.2f %3.2f\n%3.2f %3.2f %3.2f %3.2f\n",m[0],m[4],m[8],m[12],m[1],m[5],m[9],m[13],m[2],m[6],m[10],m[14],m[3],m[7],m[11],m[15]];
}

/**
 *	进行MCPoint 和 CGFloat[16] 的矩阵乘法
 *
 *	@param	p	用于矩阵乘法的MCPoint
 *	@param	m	CGFloat[16] 代表一个4 * 4 矩阵,用于将来的魔方转动处理
 *
 *	@return	经过矩阵变换后新的MCPoint
 */
static inline MCPoint MCPointMatrixMultiply(MCPoint p, CGFloat* m)
{
	CGFloat x = (p.x*m[0]) + (p.y*m[4]) + (p.z*m[8]) + m[12];
	CGFloat y = (p.x*m[1]) + (p.y*m[5]) + (p.z*m[9]) + m[13];
	CGFloat z = (p.x*m[2]) + (p.y*m[6]) + (p.z*m[10]) + m[14];
	
	return (MCPoint) {x, y, z};
}

/**
 *	顶点数组与矩阵乘积
 *
 *	@param	ptr	: GLfloat类型的顶点数组，GLfloat类型类似于CGFloat，是专门为OpenGL使用的
 *	@param	vertexStride	顶点步幅
 *	@param	vertexesCount	每个步幅内的顶点数
 *	@param	m	CGFloat[16]矩阵
 *
 *	@return	新的乘积矩阵
 */
static inline GLfloat* VertexesArray_Matrix_Multiply(GLfloat *ptr, int vertexStride, int vertexesCount, CGFloat* m)
{
    GLfloat *tmp = new GLfloat[vertexStride*vertexesCount];
	for (int i = 0; i < vertexesCount; i++) {
        // 为每一个步幅里的顶点做变换
        tmp[0+vertexStride*i] = (ptr[0+vertexStride*i]*m[0]) + (ptr[1+vertexStride*i]*m[4]) + (ptr[2+vertexStride*i]*m[8]) + m[12];
        tmp[1+vertexStride*i] = (ptr[0+vertexStride*i]*m[1]) + (ptr[1+vertexStride*i]*m[5]) + (ptr[2+vertexStride*i]*m[9]) + m[13];
        tmp[2+vertexStride*i] = (ptr[0+vertexStride*i]*m[2]) + (ptr[1+vertexStride*i]*m[6]) + (ptr[2+vertexStride*i]*m[10]) + m[14];
    }
    	
	return tmp;
}

/**
 *	返回两个三维点的距离
 */
static inline float MCPointDistance(MCPoint p1, MCPoint p2)
{
	return sqrt(((p1.x - p2.x) * (p1.x - p2.x)) + 
                ((p1.y - p2.y)  * (p1.y - p2.y)) + 
                ((p1.z - p2.z) * (p1.z - p2.z)));
}

/**
 *	返回两个矢量间的距离
 */
static inline float VectorPointDistance(vec2 p1, vec2 p2)
{
	return sqrt(((p1.x - p2.x) * (p1.x - p2.x)) +
                ((p1.y - p2.y)  * (p1.y - p2.y)));
}












