//
//  MCSceneObject.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#include "Quaternion.hpp"
#import "MCPoint.h"
#import "MCMaterialController.h"
#import "MCTexturedQuad.h"
#import "MCSceneController.h"
#import "MCTexturedMesh.h"
#import "MCPoint.h"
#import "MCConfiguration.h"
#import "MCRay.h"
//#include "MeshRenderEngine.hpp"

@class MCMesh;
@class MCCollider;
/**
 *	该类用于处理图像渲染
 */
@interface MCSceneObject : NSObject {
	// transform values
	/**
	 *	平移前坐标
	 */
	MCPoint pretranslation;
	/**
	 *	旋转前坐标
	 */
	MCPoint prerotation;
    
    /**
     *	平移后坐标
     */
    MCPoint translation;
	MCPoint scale;
	/**
	 *	旋转后坐标
	 */
	MCPoint rotation;
    // 旋转用的四元数
    Quaternion quaRotation;
    Quaternion quaPreviousRotation;
    //用来进行校验的四元数
    Quaternion start_quaRotation;
    Quaternion finish_quaRotation;
	MCMesh * mesh;
	
	BOOL active;
    
    
	CGFloat * matrix;
	
	CGRect meshBounds;
	
	MCCollider *collider;//;

    
}
@property (retain) MCCollider *collider;
@property (retain) MCMesh * mesh;
@property (assign) MCPoint translation;
@property (assign) MCPoint rotation;
@property (assign) MCPoint scale;
@property (assign) CGFloat * matrix;
@property (assign) MCPoint pretranslation;
@property (assign) MCPoint prerotation;
//@property (assign) Quaternion m_orientation;
@property (assign) Quaternion quaRotation;
@property (assign) Quaternion quaPreviousRotation;
@property (assign) Quaternion start_quaRotation;
@property (assign) Quaternion finish_quaRotation;
@property (assign) BOOL active;
@property (readonly) CGRect meshBounds;
- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;




@end
