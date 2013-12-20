//
//  MCGL.m
//  HelloCone
//
//  Created by Aha on 12-10-24.
//
//

#import "MCGL.h"
/**
 * the model matrix，模型矩阵栈。
 * 一个矩阵栈的存在是为了维护不同坐标下的一系列矩阵。可以通过push和pop操作来进行坐标场景的变换。不过更加受推荐的方法是利用投影矩阵。
 */
static stack<mat4> modelMatrix;
/**
 *	the view matrix，视图矩阵
 */
static mat4 viewMatrix;
/**
 *	the projection matrix 投射矩阵
 */
static mat4 projectionMatrix;
/**
 *	the current matrixMode, GL_MODELVIEW default.默认的矩阵模式是GL_MODELVIEW
 */
GLenum matrixMode = GL_MODELVIEW;



@implementation MCGL

+(BOOL)unProjectfWithScreenX:(float)screenX
                     screenY:(float)screenY
                      depthZ:(float)depthZ
                returnObject:(float*)object{
    int viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
    screenY = viewport[3] - screenY;
    //Transformation matrices
    float m[16], A[16];
    float in[4], out[4];
    //Calculation for inverting a matrix, compute projection x modelview
    //and store in A[16]
    multiplyMatrices4by4OpenGL_FLOAT(A, projectionMatrix.Pointer(), viewMatrix.Pointer());
    //Now compute the inverse of matrix A
    if(glhInvertMatrixf2(A, m) == 0) // 如果计算A的倒置矩阵失败，直接退出
        return NO;
    //Transformation of normalized coordinates between -1 and 1
    in[0]=(screenX-(float)viewport[0])/(float)viewport[2]*2.0-1.0;
    in[1]=(screenY-(float)viewport[1])/(float)viewport[3]*2.0-1.0;
    in[2]=2.0*depthZ-1.0;
    in[3]=1.0;
    //Objects coordinates
    multiplyMatrixByVector4by4OpenGL_FLOAT(out, m, in);
    if(out[3]==0.0)
        return NO;
    out[3]=1.0/out[3];
    object[0]=out[0]*out[3];
    object[1]=out[1]*out[3];
    object[2]=out[2]*out[3];
    return YES;
}

/**
 *	将一个4*4矩阵与4*4矩阵相乘，并将结果储存在result[16]中
 *
 *  Because of some differences on multiple operation between normal mathmatic operation and opengl, I retain it.
 *
 *	@param	result[16]	储存运算结果的float类型数组
 *	@param	matrix1	4*4矩阵
 *	@param	matrix2	4*4矩阵
 */
void multiplyMatrices4by4OpenGL_FLOAT(float *result, const float *matrix1, const float *matrix2){
    // 0,4,8,12
    result[0]=matrix1[0]*matrix2[0]+
    matrix1[4]*matrix2[1]+
    matrix1[8]*matrix2[2]+
    matrix1[12]*matrix2[3];
    
    result[4]=matrix1[0]*matrix2[4]+
    matrix1[4]*matrix2[5]+
    matrix1[8]*matrix2[6]+
    matrix1[12]*matrix2[7];
    
    result[8]=matrix1[0]*matrix2[8]+
    matrix1[4]*matrix2[9]+
    matrix1[8]*matrix2[10]+
    matrix1[12]*matrix2[11];
    
    result[12]=matrix1[0]*matrix2[12]+
    matrix1[4]*matrix2[13]+
    matrix1[8]*matrix2[14]+
    matrix1[12]*matrix2[15];
    // 1,5,9,13
    result[1]=matrix1[1]*matrix2[0]+
    matrix1[5]*matrix2[1]+
    matrix1[9]*matrix2[2]+
    matrix1[13]*matrix2[3];
    
    result[5]=matrix1[1]*matrix2[4]+
    matrix1[5]*matrix2[5]+
    matrix1[9]*matrix2[6]+
    matrix1[13]*matrix2[7];
    
    result[9]=matrix1[1]*matrix2[8]+
    matrix1[5]*matrix2[9]+
    matrix1[9]*matrix2[10]+
    matrix1[13]*matrix2[11];
    
    result[13]=matrix1[1]*matrix2[12]+
    matrix1[5]*matrix2[13]+
    matrix1[9]*matrix2[14]+
    matrix1[13]*matrix2[15];
    // 2,6,10,14
    result[2]=matrix1[2]*matrix2[0]+
    matrix1[6]*matrix2[1]+
    matrix1[10]*matrix2[2]+
    matrix1[14]*matrix2[3];
    
    result[6]=matrix1[2]*matrix2[4]+
    matrix1[6]*matrix2[5]+
    matrix1[10]*matrix2[6]+
    matrix1[14]*matrix2[7];
    
    result[10]=matrix1[2]*matrix2[8]+
    matrix1[6]*matrix2[9]+
    matrix1[10]*matrix2[10]+
    matrix1[14]*matrix2[11];
    
    result[14]=matrix1[2]*matrix2[12]+
    matrix1[6]*matrix2[13]+
    matrix1[10]*matrix2[14]+
    matrix1[14]*matrix2[15];
    // 3,7,11,15
    result[3]=matrix1[3]*matrix2[0]+
    matrix1[7]*matrix2[1]+
    matrix1[11]*matrix2[2]+
    matrix1[15]*matrix2[3];
    
    result[7]=matrix1[3]*matrix2[4]+
    matrix1[7]*matrix2[5]+
    matrix1[11]*matrix2[6]+
    matrix1[15]*matrix2[7];
    
    result[11]=matrix1[3]*matrix2[8]+
    matrix1[7]*matrix2[9]+
    matrix1[11]*matrix2[10]+
    matrix1[15]*matrix2[11];
    
    result[15]=matrix1[3]*matrix2[12]+
    matrix1[7]*matrix2[13]+
    matrix1[11]*matrix2[14]+
    matrix1[15]*matrix2[15];
}

/**
 *	将一个4*4矩阵与四维向量相乘，并将结果储存在一个向量中
 *
 *  Because of some differences on multiple operation between normal mathmatic operation and opengl, I retain it.
 *
 *	@param	resultvector	结果向量
 *	@param	matrix	4*4矩阵
 *	@param	pvector	四维向量
 */
void multiplyMatrixByVector4by4OpenGL_FLOAT(float *resultvector, const float *matrix, const float *pvector){
    resultvector[0] = matrix[0]*pvector[0]+matrix[4]*pvector[1]+matrix[8]*pvector[2]+matrix[12]*pvector[3];
    resultvector[1] = matrix[1]*pvector[0]+matrix[5]*pvector[1]+matrix[9]*pvector[2]+matrix[13]*pvector[3];
    resultvector[2] = matrix[2]*pvector[0]+matrix[6]*pvector[1]+matrix[10]*pvector[2]+matrix[14]*pvector[3];
    resultvector[3] = matrix[3]*pvector[0]+matrix[7]*pvector[1]+matrix[11]*pvector[2]+matrix[15]*pvector[3];
}

/**
 *  This code comes directly from GLU except that it is for float.
 *
 *	转置输入的float类型矩阵，并作为输出矩阵输出。转置的原理是：
 *
 *      (A E) = (E A-1)
 * 
 *      在需要转置的矩阵的下方(或右方)增加一个单位矩阵E，再将新的矩阵化为上方(或左方)是单位矩阵E的形式。
 *
 *	@param	m	输入矩阵[4][4]，注意不改变输入矩阵的值
 *	@param	out	输出矩阵[4][4],注意要事先为输出矩阵分配内存
 *
 *	@return	返回1如果成功；否则返回0，说明该矩阵不存在逆矩阵
 */
int glhInvertMatrixf2(const float *m, float *out){
    float wtmp[4][8];
    float m0, m1, m2, m3, s;
    float *r0, *r1, *r2, *r3;
    r0 = wtmp[0], r1 = wtmp[1], r2 = wtmp[2], r3 = wtmp[3];
    /*
     wtmp 0         1           2           3
     0-3  m[0][0-3] m[1][0-3]   m[2][0-3]   m[3][0-3]
     4    1.0       0.0         0.0         0.0
     5    0.0       1.0         0.0         0.0
     6    0.0       0.0         1.0         0.0
     7    0.0       0.0         0.0         1.0
     */
    r0[0] = MAT(m, 0, 0), r0[1] = MAT(m, 0, 1),
    r0[2] = MAT(m, 0, 2), r0[3] = MAT(m, 0, 3),
    r0[4] = 1.0, r0[5] = r0[6] = r0[7] = 0.0,
    
    r1[0] = MAT(m, 1, 0), r1[1] = MAT(m, 1, 1),
    r1[2] = MAT(m, 1, 2), r1[3] = MAT(m, 1, 3),
    r1[5] = 1.0, r1[4] = r1[6] = r1[7] = 0.0,
    
    r2[0] = MAT(m, 2, 0), r2[1] = MAT(m, 2, 1),
    r2[2] = MAT(m, 2, 2), r2[3] = MAT(m, 2, 3),
    r2[6] = 1.0, r2[4] = r2[5] = r2[7] = 0.0,
    
    r3[0] = MAT(m, 3, 0), r3[1] = MAT(m, 3, 1),
    r3[2] = MAT(m, 3, 2), r3[3] = MAT(m, 3, 3),
    r3[7] = 1.0, r3[4] = r3[5] = r3[6] = 0.0;
    
    // 通过初等列变换来实现单位矩阵的转换
    // 查找第一行的最大值，并进行列的交换，以方便化简出单位矩阵。如果第一列全为0，则不存在矩阵的逆
    /* choose pivot - or die */
    if (fabsf(r3[0]) > fabsf(r2[0]))
        SWAP_ROWS_FLOAT(r3, r2);
    if (fabsf(r2[0]) > fabsf(r1[0]))
        SWAP_ROWS_FLOAT(r2, r1);
    if (fabsf(r1[0]) > fabsf(r0[0]))
        SWAP_ROWS_FLOAT(r1, r0);
    if (0.0 == r0[0])
        return 0;
    /* eliminate first variable     */
    m1 = r1[0] / r0[0];
    m2 = r2[0] / r0[0];
    m3 = r3[0] / r0[0];
    s = r0[1];  //比例因子
    r1[1] -= m1 * s;
    r2[1] -= m2 * s;
    r3[1] -= m3 * s;
    s = r0[2];
    r1[2] -= m1 * s;
    r2[2] -= m2 * s;
    r3[2] -= m3 * s;
    s = r0[3];
    r1[3] -= m1 * s;
    r2[3] -= m2 * s;
    r3[3] -= m3 * s;
    s = r0[4];
    if (s != 0.0) {
        r1[4] -= m1 * s;
        r2[4] -= m2 * s;
        r3[4] -= m3 * s;
    }
    s = r0[5];
    if (s != 0.0) {
        r1[5] -= m1 * s;
        r2[5] -= m2 * s;
        r3[5] -= m3 * s;
    }
    s = r0[6];
    if (s != 0.0) {
        r1[6] -= m1 * s;
        r2[6] -= m2 * s;
        r3[6] -= m3 * s;
    }
    s = r0[7];
    if (s != 0.0) {
        r1[7] -= m1 * s;
        r2[7] -= m2 * s;
        r3[7] -= m3 * s;
    }
    // 以下同理
    /* choose pivot - or die */
    if (fabsf(r3[1]) > fabsf(r2[1]))
        SWAP_ROWS_FLOAT(r3, r2);
    if (fabsf(r2[1]) > fabsf(r1[1]))
        SWAP_ROWS_FLOAT(r2, r1);
    if (0.0 == r1[1])
        return 0;
    /* eliminate second variable */
    m2 = r2[1] / r1[1];
    m3 = r3[1] / r1[1];
    r2[2] -= m2 * r1[2];
    r3[2] -= m3 * r1[2];
    r2[3] -= m2 * r1[3];
    r3[3] -= m3 * r1[3];
    s = r1[4];
    if (0.0 != s) {
        r2[4] -= m2 * s;
        r3[4] -= m3 * s;
    }
    s = r1[5];
    if (0.0 != s) {
        r2[5] -= m2 * s;
        r3[5] -= m3 * s;
    }
    s = r1[6];
    if (0.0 != s) {
        r2[6] -= m2 * s;
        r3[6] -= m3 * s;
    }
    s = r1[7];
    if (0.0 != s) {
        r2[7] -= m2 * s;
        r3[7] -= m3 * s;
    }
    
    /* choose pivot - or die */
    if (fabsf(r3[2]) > fabsf(r2[2]))
        SWAP_ROWS_FLOAT(r3, r2);
    if (0.0 == r2[2])
        return 0;
    /* eliminate third variable */
    m3 = r3[2] / r2[2];
    r3[3] -= m3 * r2[3], r3[4] -= m3 * r2[4],
    r3[5] -= m3 * r2[5], r3[6] -= m3 * r2[6], r3[7] -= m3 * r2[7];
    /* last check */
    if (0.0 == r3[3])
        return 0;
    
    s = 1.0 / r3[3];		/* now back substitute row 3 */
    r3[4] *= s;
    r3[5] *= s;
    r3[6] *= s;
    r3[7] *= s;
    
    m2 = r2[3];			/* now back substitute row 2 */
    s = 1.0 / r2[2];
    r2[4] = s * (r2[4] - r3[4] * m2), r2[5] = s * (r2[5] - r3[5] * m2),
    r2[6] = s * (r2[6] - r3[6] * m2), r2[7] = s * (r2[7] - r3[7] * m2);
    m1 = r1[3];
    r1[4] -= r3[4] * m1, r1[5] -= r3[5] * m1,
    r1[6] -= r3[6] * m1, r1[7] -= r3[7] * m1;
    m0 = r0[3];
    r0[4] -= r3[4] * m0, r0[5] -= r3[5] * m0,
    r0[6] -= r3[6] * m0, r0[7] -= r3[7] * m0;
    
    m1 = r1[2];			/* now back substitute row 1 */
    s = 1.0 / r1[1];
    r1[4] = s * (r1[4] - r2[4] * m1), r1[5] = s * (r1[5] - r2[5] * m1),
    r1[6] = s * (r1[6] - r2[6] * m1), r1[7] = s * (r1[7] - r2[7] * m1);
    m0 = r0[2];
    r0[4] -= r2[4] * m0, r0[5] -= r2[5] * m0,
    r0[6] -= r2[6] * m0, r0[7] -= r2[7] * m0;
    
    m0 = r0[1];			/* now back substitute row 0 */
    s = 1.0 / r0[0];
    r0[4] = s * (r0[4] - r1[4] * m0), r0[5] = s * (r0[5] - r1[5] * m0),
    r0[6] = s * (r0[6] - r1[6] * m0), r0[7] = s * (r0[7] - r1[7] * m0);
    
    // 下面为所求矩阵的逆
    MAT(out, 0, 0) = r0[4];
    MAT(out, 0, 1) = r0[5], MAT(out, 0, 2) = r0[6];
    MAT(out, 0, 3) = r0[7], MAT(out, 1, 0) = r1[4];
    MAT(out, 1, 1) = r1[5], MAT(out, 1, 2) = r1[6];
    MAT(out, 1, 3) = r1[7], MAT(out, 2, 0) = r2[4];
    MAT(out, 2, 1) = r2[5], MAT(out, 2, 2) = r2[6];
    MAT(out, 2, 3) = r2[7], MAT(out, 3, 0) = r3[4];
    MAT(out, 3, 1) = r3[5], MAT(out, 3, 2) = r3[6];
    MAT(out, 3, 3) = r3[7];
    return 1;
}

+(void)matrixMode:(GLenum)mode{
    matrixMode = mode;
    glMatrixMode(mode);
}

+(void)loadIdentity{
    switch (matrixMode) {
        case GL_PROJECTION:
            projectionMatrix.Identity();
            glLoadMatrixf(projectionMatrix.Pointer());
            break;
        case GL_MODELVIEW:
            {
                viewMatrix.Identity();
                int size = modelMatrix.size();
                for (int i = 0; i <size; ++i) {
                    modelMatrix.pop();
                }
                mat4 initMatrix;
                initMatrix.Identity();
                modelMatrix.push(initMatrix);
                glLoadMatrixf(viewMatrix.Pointer());
            }
            break;
        default:
            break;
    }
}

+(void)perspectiveWithFovy:(float)fovy
                    aspect:(float)aspect
                     zNear:(float)zNear
                      zFar:(float)zFar{
    //avoid error
    // 这里为了避免发生错误，先构造出一个新的矩阵，对这个矩阵变换成功后，再赋值给projectionMatrix
    projectionMatrix.Identity();
    
    GLfloat halfWidth, halfHeight, deltaZ;
    deltaZ = zFar - zNear;
    halfHeight = tan( (fovy / 2) / 180 * Pi ) * zNear;
    halfWidth = halfHeight * aspect;
    //fill projection matrix，填充投影矩阵
    projectionMatrix.x.x = zNear / halfWidth;
    projectionMatrix.y.y = zNear / halfHeight;
    projectionMatrix.z.z = - (zFar + zNear) / deltaZ;
    projectionMatrix.z.w = -1;
    projectionMatrix.w.z = -2 * zNear * zFar / deltaZ;
    projectionMatrix.w.w = 0;
    //load the matrix
    //glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
    glMultMatrixf(projectionMatrix.Pointer());
    glTranslatef(0.0, 0.0, -180.0);

    GLfloat  projection[16];

    glGetFloatv(GL_PROJECTION_MATRIX, projection);
    mat4 pro = Matrix4<float>(projection);
    projectionMatrix = pro;
    //projectionMatrix = projectionMatrix.Rotate(-90);
}

+(void)translateWithX:(float)x
                    Y:(float)y
                    Z:(float)z{
    //avoid error
    if (modelMatrix.empty()) {
        mat4 initMatrix;
        initMatrix.Identity();
        modelMatrix.push(initMatrix);
    }
    
    modelMatrix.top() = mat4::Translate(x, y, z) * modelMatrix.top();
    glLoadMatrixf((modelMatrix.top()*viewMatrix).Pointer());
}




+(void)rotateWithQuaternion:(Quaternion)delta{
    if (modelMatrix.empty()) {
        mat4 initMatrix;
        initMatrix.Identity();
        modelMatrix.push(initMatrix);
    }
    
    mat4 deltaMatrix = delta.ToMatrix();
    // 将四元数与model栈的顶部的矩阵相乘
    modelMatrix.top() = deltaMatrix * modelMatrix.top();
    glLoadMatrixf((modelMatrix.top()*viewMatrix).Pointer());
}


//it has some problems
+(void)lookAtEyefv:(vec3)eye
          centerfv:(vec3)center
              upfv:(vec3)up{
    vec3 tmpF, tmpUp, tmpS, tmpT;
    tmpF.x = center.x - eye.x;
    tmpF.y = center.y - eye.y;
    tmpF.z = center.z - eye.z;
    
    tmpF.Normalize();
    tmpUp = up;
    tmpUp.Normalize();
    
    tmpS = tmpF.Cross(tmpUp);
    tmpT = tmpS.Cross(tmpF);
    
    
    viewMatrix.x.x = tmpS.x;
    viewMatrix.x.y = tmpT.x;
    viewMatrix.x.z = -tmpF.x;
    viewMatrix.x.w = 0;
    
    viewMatrix.y.x = tmpS.y;
    viewMatrix.y.y = tmpT.y;
    viewMatrix.y.z = -tmpF.y;
    viewMatrix.y.w = 0;
    
    viewMatrix.z.x = tmpS.z;
    viewMatrix.z.y = tmpT.z;
    viewMatrix.z.z = -tmpF.z;
    viewMatrix.z.w = 0;
    
    viewMatrix.w.x = 0;
    viewMatrix.w.y = 0;
    viewMatrix.w.z = 0;
    viewMatrix.w.w = 1;
    
    
    viewMatrix = mat4::Translate(-eye.x, -eye.y, -eye.z) * viewMatrix;
    
    glLoadMatrixf(viewMatrix.Pointer());
}

+(void)pushMatrix{
    mat4 newMatrix = modelMatrix.top();
    modelMatrix.push(newMatrix);
}

+(void)popMatrix{
    modelMatrix.pop();
    glLoadMatrixf(viewMatrix.Pointer());
    glMultMatrixf(modelMatrix.top().Pointer());
}

+(mat4)getCurrentViewMatrix{
    return viewMatrix;
}

+(mat4)getCurrentModelMatrix{
    return modelMatrix.top();
}

+(mat4)getCurrentProjectionMatrix{
    return projectionMatrix;
}

@end
