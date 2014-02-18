//
//  MCTexturedQuad.h
//  MCGame
//
//  Created by kwan terry on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMesh.h"
#import "MCMaterialController.h"
/**
 *	纹理渲染区域
 *
 *  Quad是方块的意思，这里代表了一片特定的区域。
 *
 *  估计这里是最早出现uvCoordinates的地方之一。
 *  所以有针对地说明一下。
 *  uvCoordinates字面意思就是一个表示uv坐标的数组。
 *
 *  那么什么是uv坐标呢？
 *  
 *  我们知道，通过y = kx + b，我们可以表示一条一维直线。
 *  当然也可以转化为参数式的形式，表示为x = f(t),y = g(t).拓展开来，还可以有z = h(t),k = l(t)等等。
 *  这样就可以在多维空间下定义一条直线。
 *  同理，如果要在多维空间下定义一个曲面，我们可以用上两个参数，u和v。
 *  这就是uv坐标的来由。
 *  
 *  每一个顶点在一个曲面中都有一对唯一的坐标值。所以4个顶点会有8个uv坐标值。
 */
@interface MCTexturedQuad : MCMesh{
    GLfloat * uvCoordinates;
	NSString * materialKey;
}

@property (assign) GLfloat * uvCoordinates;
@property (retain) NSString * materialKey;

@end
