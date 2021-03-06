//
//  MCSceneObject.m
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCSceneController.h"
#import "MCInputViewController.h"
#import "MCMesh.h"
#pragma mark Spinny Square mesh



@implementation MCSceneObject

@synthesize prerotation,pretranslation;
@synthesize translation,rotation,scale,active,mesh,matrix,meshBounds;
//@synthesize m_orientation;
@synthesize quaRotation,quaPreviousRotation,start_quaRotation,finish_quaRotation;

- (id) init
{
	self = [super init];
	if (self != nil) {
		translation = MCPointMake(0.0, 0.0, 0.0);
		rotation = MCPointMake(0.0, 0.0, 0.0);
        pretranslation = MCPointMake(0.0, 0.0, 0.0);
        prerotation = MCPointMake(0.0, 0.0, 0.0);
		scale = MCPointMake(1.0, 1.0, 1.0);
		matrix = (CGFloat *) malloc(16 * sizeof(CGFloat));
		active = NO;
		meshBounds = CGRectZero;
        // 注意mesh没有被初始化。
	}
	return self;
}

-(CGRect) meshBounds
{
	if (CGRectEqualToRect(meshBounds, CGRectZero)) {
        // 在这里设置meshBounds
		meshBounds = [MCMesh meshBounds:mesh scale:scale];
	}
	return meshBounds;
}

/**
 * called once when the object is first created.
 */
-(void)awake
{
    // do nothing
}

/*
 * called once every frame
 */
-(void)update
{
	glPushMatrix();
	glLoadIdentity();
	
	// move to my position
	glTranslatef(pretranslation.x, pretranslation.y, pretranslation.z);
	
    // 以四元数来进行旋转
   	mat4 matRotation = quaRotation.ToMatrix();
    glMultMatrixf(matRotation.Pointer());
    
    //----------------

        
    // rotate
    // 向三个方向旋转对应的prerotation度数
	glRotatef(prerotation.x, 1.0f, 0.0f, 0.0f);
	glRotatef(prerotation.y, 0.0f, 1.0f, 0.0f);
	glRotatef(prerotation.z, 0.0f, 0.0f, 1.0f);
    
    
    //tanslation_after_rotate
    glTranslatef(translation.x, translation.y, translation.z);
    // rotate
	glRotatef(rotation.x, 1.0f, 0.0f, 0.0f);
	glRotatef(rotation.y, 0.0f, 1.0f, 0.0f);
	glRotatef(rotation.z, 0.0f, 0.0f, 1.0f);

    

	//scale
	glScalef(scale.x, scale.y, scale.z);
	// save the matrix transform
	glGetFloatv(GL_MODELVIEW_MATRIX, matrix);
    
	//restore the matrix
	glPopMatrix();
	//if (collider != nil) [collider updateCollider:self];   
}

/**
 * called once every frame
 */
-(void)render
{
    if (!mesh || !active) return; // if we do not have a mesh, no need to render
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	glMultMatrixf(matrix);
    // use mesh to render itself
	[mesh render];	
	glPopMatrix();
}

- (void) dealloc
{
    if (matrix != NULL) {
        free(matrix);
    }
	[super dealloc];

}

@end
