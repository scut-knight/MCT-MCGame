//
//  CubeFace.m
//  MCGame
//
//  Created by kwan terry on 13-3-12.
//
//

#import "CubeFace.h"

@implementation CubeFace

@synthesize isNeedRender;
// called once every frame
-(void)render
{
    if (!isNeedRender) {
        return;
    }
    
    [[MCMaterialController sharedMaterialController] bindMaterial:materialKey];
	
    
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY); // do not use glEnableClientState(GL_COLOR_ARRAY)
    
	glVertexPointer(vertexSize, GL_FLOAT, 0, vertexes);
    glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
    glNormalPointer(GL_FLOAT, 0, normals);
    glDrawArrays(renderStyle, 0, vertexCount);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
//    glDisableClientState(GL_COLOR_ARRAY); 
}
@end
