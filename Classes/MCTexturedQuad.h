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
 */
@interface MCTexturedQuad : MCMesh{
    GLfloat * uvCoordinates;
	NSString * materialKey;
}

@property (assign) GLfloat * uvCoordinates;
@property (retain) NSString * materialKey;

@end
