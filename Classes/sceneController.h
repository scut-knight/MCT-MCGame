//
//  sceneController.h
//  MCGame
//
//  Created by kwan terry on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MCInputViewController;
@class MCCollisionController;
@class InputController;
@class EAGLView;
@class MCSceneObject;
/**
 *	该类搭建了一个舞台，负责各种场景对象的产生、渲染和终结。
 */
@interface sceneController : NSObject{
    /**
     *	maintain all the scene objects
     */
    NSMutableArray * sceneObjects;
	/**
	 *	queue that store object to remove next update gameloop
	 */
	NSMutableArray * objectsToRemove;
    /**
     *	queue that store object to add next update gameloop,and add to the sceneObject array.
     */
	NSMutableArray * objectsToAdd;
    
    //inputcontroller
	InputController * inputController;
	EAGLView * openGLView;
	
    //MCCollisionController * collisionController;
    // 以下是关于动画播放的
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
    
    // 以下是关于场景的帧管理的
	/**
	 *	每次gameloop需要的时间
	 */
	NSTimeInterval deltaTime;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval thisFrameStartTime;
	/**
	 *	场景开始时间
	 */
	NSDate * levelStartDate;
	
	BOOL needToLoadScene;
    MCCollisionController * collisionController;
}
@property (retain) NSMutableArray * sceneObjects;
@property (retain) InputController * inputController;
@property (retain) EAGLView * openGLView;
@property (retain) NSDate *levelStartDate;
@property NSTimeInterval deltaTime;
@property NSTimeInterval animationInterval;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (sceneController*)sharedsceneController;
- (void)dealloc;
- (void)loadScene;
- (void)startScene;
- (void)addObjectToScene:(MCSceneObject*)sceneObject; 
- (void)gameLoop;
- (void)gameOver;
- (void)removeObjectFromScene:(MCSceneObject*)sceneObject;
- (void)removeAllObjectFromScene;
- (void)renderScene;
- (void)restartScene;
- (void)setAnimationInterval:(NSTimeInterval)interval ;
- (void)setAnimationTimer:(NSTimer *)newTimer ;
- (void)startAnimation ;
- (void)stopAnimation ;
- (void)updateModel;
- (void)setupLighting;
- (void)setupLookAt;

- (void)releaseSrc;

@end
