//
//  EAGLView.m
//  MCOpenGLIntro
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
/// 使用深度缓冲
#define USE_DEPTH_BUFFER 1

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;


@end


@implementation EAGLView

@synthesize context;

// You must implement this method
/**
 *	类方法，返回CAEAGLLayer类。不过这个方法没有被用到。
 *
 *	@return	一个抽象的Class类型，可以用于反射
 */
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

/**
 * The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
 *
 * GL视图储存在nib文件中。当它被解档案时，它会执行initWithCoder:
 *
 * 至于该函数，接受一块区域作为CAEAGLLayer绘图的地方
 */
- (id)initWithFrame:(CGRect)rect {
    
    if ((self = [super initWithFrame:rect])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        self.multipleTouchEnabled = YES;
        isNeedToLayView = YES;
    }
    return self;
}

/**
 *	建立视图
 */
- (void)setupViewLandscape
{	/*		
	// Sets up matrices and transforms for OpenGL ES
	glViewport(0, 0, backingWidth, backingHeight);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
	// set up the viewport so that it is analagous to the screen pixels
	[self perspectiveFovY:60 aspect:1024.0/768.0 zNear:0.01 zFar:1000.0];
	//280
    glTranslatef(0.0, 0.0, -180.0);
     */
	
    glViewport(0, 0, backingWidth, backingHeight);
    //You can see that instead of glMatrixMode(GL_PROJECTION) you use this function.
    [MCGL matrixMode:GL_PROJECTION];
    //You can see that instead of glLoadIdentity() you use this function.
    [MCGL loadIdentity];
    //Here, you can use this advanced function to set the projection matrix.
    [MCGL perspectiveWithFovy:60.0
                       aspect:1024.0/768.0
                        zNear:100.01
                         zFar:1000];
    
    glMatrixMode(GL_MODELVIEW);
    
	// Clears the view with gray
	glClearColor(0.7f, 0.7f, 0.7f, 1.0f);
    
    
}

/**
 *	建立视图肖像，就是建立世界坐标系下的魔方模型到我们的屏幕上的投影
 */
- (void)setupViewPortrait
{		
	// Set up the window that we will view the scene through
	glViewport(0, 0, backingWidth, backingHeight);
	
	// switch to the projection matrix and setup our 'camera lens'
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);	
    
	// switch to model mode and set our background color
	glMatrixMode(GL_MODELVIEW);
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
}

-(void)beginDraw
{
	// Make sure that you are drawing to the current context
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	// make sure we are in model matrix mode and clear the frame
	glMatrixMode(GL_MODELVIEW);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	// set a clean transform
	glLoadIdentity();	
}

-(void)finishDraw
{
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];	
}

/**
 *	是否需要重新加载视图，如果isNeedToLayView为YES，则重新加载视图
 */
- (void)layoutSubviews 
{
    if (isNeedToLayView) {
        [EAGLContext setCurrentContext:context];
        [self destroyFramebuffer];
        [self createFramebuffer];
        [self setupViewLandscape];
        isNeedToLayView = NO;
    }
}

/**
 *	设置frameBuffer
 *
 *	@return	YES 如果成功，否则返回NO
 */
- (BOOL)createFramebuffer {    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
        glEnable(GL_DEPTH_TEST);

    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    glEnable(GL_LINE_SMOOTH_HINT);
    glHint(GL_LINE_SMOOTH,GL_NICEST);
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

/**
 *	该方法已经没有用了，用MCGL的同名方法代替了它
 *
 *  @see MCGL
 */
-(void)perspectiveFovY:(GLfloat)fovY
                aspect:(GLfloat)aspect 
                 zNear:(GLfloat)zNear
                  zFar:(GLfloat)zFar 
{
	const GLfloat pi = 3.1415926;
	//	Half of the size of the x and y clipping planes.
	// - halfWidth = left, halfWidth = right
	// - halfHeight = bottom, halfHeight = top
	GLfloat halfWidth, halfHeight;
	//	Calculate the distance from 0 of the y clipping plane. Basically trig to calculate
	//	position of clip plane at zNear.
	halfHeight = tan( (fovY / 2) / 180 * pi ) * zNear;	
	//	Calculate the distance from 0 of the x clipping plane based on the aspect ratio.
	halfWidth = halfHeight * aspect;
	//	Finally call glFrustum with our calculated values.
	glFrustumf( -halfWidth, halfWidth, -halfHeight, halfHeight, zNear, zFar );
}



- (void)dealloc {
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end

