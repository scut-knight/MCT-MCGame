//
//  MCGL.h
//  HelloCone
//
//  Created by Aha on 12-10-24.
//
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <stack>
#import "Matrix.hpp"
#import "Quaternion.hpp"
using namespace std;

/**
 *	交换两个double类型变量
 */
#define SWAP_ROWS_DOUBLE(a, b) { double *_tmp = a; (a)=(b); (b)=_tmp; }
/**
 *	交换两个float类型变量
 */
#define SWAP_ROWS_FLOAT(a, b) { float *_tmp = a; (a)=(b); (b)=_tmp; }
/**
 *	等价于m[c][r]
 */
#define MAT(m,r,c) (m)[(c)*4+(r)]

/**
 *	用于openGLES处理的基础类
 *
 *  openGLES内容密集，小心:}   不过我会细加讲解，至少比起魔方的解法，openGLES还是易学很多。
 *
 *  这里用的是openGLES3.0。官方API文档参见下面链接：
 *  @see http://www.khronos.org/opengles/sdk/docs/man3/
 *
 *  另，这里提到一些glXX和gluXX函数。说一下gl与glu的区别：OpenGL中的gl库是核心库，glu是实用库。gl是核心，glu是对gl的部分封装
 */
@interface MCGL : NSObject

/**
 *You can use this function for get the vertex in the 3D space(world coordinate).
 *You should give the screen location and the Z depth(between 0 and 1, included).
 *If the Z is 0, it will return the vertex on the near plane(平面). If 1,the far plane.
 *如果winz为0，那么得到的向量将位于近平面，否则将位于远平面。
 *The renturn value will store in parameter object below.(结果将会储存在object[3]中)
 *
 *  输入屏幕坐标winx,winy，以及深度z，得到由反投影形成的一个三维向量(一个float向量)。需铭记的是，通过openGL渲染的立体图形，需要最终投影到二维的屏幕上。当然也有必要实现一个相反的步骤。
 */
+(BOOL)unProjectfWithScreenX:(float)winx
                     screenY:(float)winy
                      depthZ:(float)winz
                returnObject:(float*)object;
/**
 *  the function like glMatrixMode.
 *
 *  修改当前的matrixMode，有模型、投影、纹理三种选项
 */
+(void)matrixMode:(GLenum)mode;

/**
 * the function like glLoadIdentity().实现glLoadIdentity()功能，该函数在openGL中提供，但在openGLES中不提供。
 *
 * 该函数的作用是恢复初始化坐标系。用一个4×4的单位矩阵来替换当前矩阵，实际上就是对当前矩阵进行初始化。
 */
+(void)loadIdentity;

/**
 *	the function like gluPerspective.
 *  you can use this advanced function to set the projection matrix which isn't in OpenGL ES.
 *
 *  在openGLES中实现类似gluPerspective的功能。该函数用于设置投影矩阵。
 *  注意，修改了projectionMatrix
 *
 *	@param	fovy	视角，0-180度
 *	@param	aspect	实际窗口纵横比，x/y
 *	@param	zNear	近平面
 *	@param	zFar	远平面
 */
+(void)perspectiveWithFovy:(float)fovy
                    aspect:(float)aspect
                     zNear:(float)zNear
                      zFar:(float)zFar;
/**
 * the function like glTranslatef.
 *
 * 沿着 X, Y 和 Z 轴移动。移动时相对于当前所在的屏幕位置。其作用就是将坐标的原点在当前原点的基础上平移一个(x,y,z)向量。
 */
+(void)translateWithX:(float)x
                    Y:(float)y
                    Z:(float)z;
/**
 *  通过一个四元数来旋转。
 *
 *  Here, I use quaternion to set rotation.使用一个四元数来表示旋转。
 */
+(void)rotateWithQuaternion:(Quaternion)delta;

/**
 *	 the function like gluLookAt.
 *
 *   实现视点变换。
 *   通常视点变换操作在模型变换操作之前发出，以便模型变换先对物体发生作用。这样，场景中物体的顶点经过模型转换后一定到所希望的位置，然后再对场景进行视点定位等操作。
 *
 *	@param	eye	eye表示我们眼睛在"世界坐标系(软件中立体图形所在的坐标系)"中的位置
 *	@param	center	center表示眼睛"看"的那个点的坐标
 *	@param	up	最后那个up坐标表示观察者本身的方向,如果将观察点比喻成我们的眼睛,那么这个up则表示我们是正立还是倒立异或某一个角度在看,所看的影像大不相同。
 *   故此时如需要指明我们现在正立,那么X,Z轴为0,Y轴为正即可,通常将其设置为1,只要表示一个向上的向量(方向)即可。
 */
+(void)lookAtEyefv:(vec3)eye
          centerfv:(vec3)center
              upfv:(vec3)up;

/**
 *  the function like glPushMatrix.
 */
+(void)pushMatrix;

/**
 * the function like glPopMatrix.
 */
+(void)popMatrix;

void multiplyMatrices4by4OpenGL_FLOAT(float *result, const  float *matrix1, const float *matrix2);

void multiplyMatrixByVector4by4OpenGL_FLOAT(float *resultvector, const float *matrix, const float *pvector);

int glhInvertMatrixf2(const float *m, float *out);

/**
 *  You can get the current view matrix.
 *  Notice!I have split the MODELVIEW_MATRIX into view matrix and model matrix.
 */
+(mat4)getCurrentViewMatrix;

/**
 *  You can get the current model matrix.
 *  Notice!I have split the MODELVIEW_MATRIX into view matrix and model matrix.
 */
+(mat4)getCurrentModelMatrix;

/**
 *  You can get the current projection matrix.
 */
+(mat4)getCurrentProjectionMatrix;

@end
