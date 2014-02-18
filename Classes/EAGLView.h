//
//  EAGLView.h
//  BBOpenGLIntro
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "MCRay.h"

/**
 *This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 *The view content is basically an EAGL surface you render your OpenGL scene into.
 *Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
 *
 *该类作为一个便利的UIView子类，包装了CoreAnimation中的CAEAGLLayer类。
 *其视图内容主要为进行openGL scene渲染的EAGL层。
 *注意只有当EAGL表面有一个alpha通道的时候，才能设定视图为透明
 *
 *该类负责Opengl ES 视图绘制。又，EAGL是embeded apple graphic library的缩写
*/
@interface EAGLView : UIView {
   
    
@private
    /* The pixel dimensions of the backbuffer */
    /**
     *	图层背景宽度
     */
    GLint backingWidth;
    /**
     *	图层背景高度
     */
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    BOOL isNeedToLayView;
}

- (void)beginDraw;
- (void)finishDraw;
- (void)setupViewLandscape;
- (void)setupViewPortrait;
-(void)perspectiveFovY:(GLfloat)fovY 
                aspect:(GLfloat)aspect 
                 zNear:(GLfloat)zNear
                  zFar:(GLfloat)zFar ;
@end