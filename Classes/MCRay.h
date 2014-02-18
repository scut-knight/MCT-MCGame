//
//  MCRay.h
//  HelloCone
//
//  Created by Aha on 12-10-24.
//
//

#import <Foundation/Foundation.h>
#import "Vector.hpp"
#import "MCGL.h"

/**
 *	射线类
 */
@interface MCRay : NSObject{
    /**
     *	射线原点（一个三维坐标）
     */
    vec3 vOrigin;
    /**
     *	射线方向
     */
    vec3 vDirection;
}

@property() vec3 vOrigin;
@property() vec3 vDirection;

/**
 * Once create the ray, this function is used for updating self by the screen coordinate.
 * What it gets is the ray in the world coordinate.
 *
 * 通过屏幕坐标更新vDirection,让vDirection为screen坐标到world坐标的矢量。
 *
 */
-(void)updateWithScreenX:(float) screenX
                 screenY:(float) screenY;
/**
 * Once the ray is transfor into the model coordinate, by this function you can check if the triangle intersect with the ray.
 * You should give three vertexs of the triangle.
 * If intersection occurs, it will return the distance between intersected point and the clicked point.
 * If no, return -1.
 *
 * 所给的V1,V2,V3三个顶点构成一个三角形。该函数用于在将射线转换成模型坐标时，检查射线是否与三角形相交。
 *
 * @return 如果不相交，返回-1。否则，返回交点和点击点间的距离。
 */
-(GLfloat)intersectWithTriangleMadeUpOfV0:(float *)V0
                                    V1:(float *)V1
                                    V2:(float *)V2;
/**
 * return the intetatived point
 *
 * 所给的V1,V2,V3三个顶点构成一个三角形。该函数用于在将射线转换成模型坐标时，检查射线是否与三角形相交。
 * 
 * @return 如果不相交，返回VOrigin即射线原点；否则返回射线与三角形的交点
 */
-(vec3)pointIntersectWithTriangleMadeUpOfV0:(float *)V0
                                       V1:(float *)V1
                                       V2:(float *)V2;
/**
 * You can transform the ray from world coordinate into model world coordinate by use the inverse of the current modelview.
 * If you want to check intersection many times, don't forget that before what is transformed should be the copy object.
 *
 *  利用当前模型矩阵把射线从world坐标系转换成在模型坐标系下的形式。修改了vOrigin和vDirection。
 *  注意：如果要多次检查交点，不要忘记在变换之前使用被变换矩阵的一个副本。
 *
 *  @param matrix 当前模型矩阵的逆
 */
-(void)transformWithMatrix:(mat4) matrix;

@end
