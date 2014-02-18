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
 *	用于openGLES处理的基础类，注意这个类只是相当于一个包，不可能生成这个类的一个实例。
 *  这个类的用途就是把需要用到的openGL函数组织起来。
 *
 *  openGLES内容密集，小心:}   不过我会细加讲解，至少比起魔方的解法，openGLES还是易学很多。
 *
 *  这里用的是openGLES3.0。官方API文档参见下面链接：
 *  @see http://www.khronos.org/opengles/sdk/docs/man3/
 *
 *  另，这里提到一些glXX和gluXX函数。说一下gl与glu的区别：OpenGL中的gl库是核心库，glu是实用库。gl是核心，glu是对gl的部分封装
 *
 *  然后再说说别的：
 *
 *  openGL的精髓，在于矩阵变换。当我们通过一个坐标系指定了软件内的world coordination时，需要把坐标内的
 *  顶点变换到屏幕上。整个过程，一共会发生三种类型的变换：视图变换、模型变换、投影变换。这里先交代一些术语：
 *
 *  变换                  用途
 *
 *  视图(viewing)         指定观察者或照相机、眼睛、摄像头等等的位置
 *
 *  模型(modeling)        在场景中移动物体
 *
 *  模型视图(modelview)   描述视图和模型变换的对偶性
 *
 *  投影(projection)      改变可视区域的大小或重新设置它的形状
 *
 *  视口(viewport)        这是一种伪变换，只是对窗口上的最终输出进行缩放
 *
 *  视图变换：第一个需要应用的变换。它用于确认场景的观测点。在默认情况下，在透视投影中，
 *  观察者是从原点向z轴的负方向看过去。这个观测点相对于视觉坐标系进行移动，就可以提供一个特定的拍摄点。
 *  这样，观察者能够看到的画面，就会发生转变。作为总体原则，在进行任何其他变换之前，必须先指定视图变换。
 *  当然，从本质上说，视图变换只是在绘制物体之前应用到一个虚拟物体(观察者)之上的一种模型变换。
 *
 *  模型变换：用于对模型以及模型内部的特定物体进行操作。它可以移动物体，对它们进行旋转，或者缩放。
 *  场景或物体的最终外观很大程度上取决于模型变换的应用顺序。对于移动和旋转，情况更是如此。
 *
 *  在场景中放置更多的物体时，需要不断指定新的变换。按照约定，最初进行的变换作为参照(它已经修改了当前坐标系)，
 *  其他所有的变换均以它为基础。
 *
 *  投影变换：这是在模型变换和视图变换之后，应用于物体的顶点之上的。
 *  这种投影实际上定义了可视区域，并建立了裁剪平面。
 *  裁剪平面是3D空间的平面方程式，openGL用它来确定几何图形能否被看到。
 *  通俗地说，投影变换指定了一个完成的场景(在所有的视图和模型变换都已经完成之后)投影到屏幕上的最终图像。
 *
 *  视口变换：当上面这些操作全部完成之后，最终所获得的是场景的二维投影，将被映射到屏幕上的某个窗口。
 *  这种到物理窗口坐标的映射是最后一个完成的变换，称为视口变换。
 *
 *  最后总结一下整个变换的流程：首先，把顶点转变为一个1*4的矩阵，前3个值分别是x,y,z坐标。
 *  第4个元素是缩放因子w。它在默认情况下通常为1.0.我们一般不需要修改这个值。
 *  接着，把顶点分别与视图矩阵和模型矩阵相乘(别忘了视图矩阵在前),产生经过变换的视觉坐标。
 *  然后将这个视觉坐标与投影矩阵相乘，产生裁剪坐标。这个裁剪坐标随后除以w坐标，产生规范化的设备坐标。
 *  最后，我们把这个坐标通过视口变换映射到我们的屏幕上去。
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
 *   实现视图变换。
 *   通常视图变换操作在模型变换操作之前发出，以便模型变换先对物体发生作用。这样，场景中物体的顶点经过模型转换后一定到所希望的位置，然后再对场景进行视点定位等操作。
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
 *
 *  把当前的矩阵压入到堆栈中(所以不需要一个参数)，对它进行保存，然后再修改当前的矩阵。
 */
+(void)pushMatrix;

/**
 * the function like glPopMatrix.
 *
 * 从堆栈中弹出矩阵相当于恢复原来的那个矩阵
 */
+(void)popMatrix;

void multiplyMatrices4by4OpenGL_FLOAT(float *result, const  float *matrix1, const float *matrix2);

void multiplyMatrixByVector4by4OpenGL_FLOAT(float *resultvector, const float *matrix, const float *pvector);

int glhInvertMatrixf2(const float *m, float *out);

/**
 *  You can get the current view matrix.
 *  Notice!I have split the MODELVIEW_MATRIX into view matrix and model matrix.
 *
 *  返回当前的视图矩阵，注意这里将模型视图矩阵区分成模型矩阵和视图矩阵
 */
+(mat4)getCurrentViewMatrix;

/**
 *  You can get the current model matrix.
 *  Notice!I have split the MODELVIEW_MATRIX into view matrix and model matrix.
 *
 *  返回当前的模型矩阵，注意这里将模型视图矩阵区分成模型矩阵和视图矩阵
 */
+(mat4)getCurrentModelMatrix;

/**
 *  You can get the current projection matrix.
 *
 *  返回当前的投影矩阵
 */
+(mat4)getCurrentProjectionMatrix;

@end
