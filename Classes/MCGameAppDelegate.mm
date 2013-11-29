//
//  MCGameAppDelegate.m
//  MCGame
//
//  
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "MCGameAppDelegate.h"

#import "MCInputViewController.h"
#import "EAGLView.h"
#import "MCSceneController.h"
#import "MCCountingPlayInputViewController__1.h"
#import "MCCountingPlaySceneController__1.h"
#import "CoordinatingController.h"
#import "MCOBJLoader.h"
#import "SoundSettingController.h"
#import "SoundSettingController.h"
#import "PlatformDetect.h"
@implementation MCGameAppDelegate

@synthesize window;

/**
 *	返回一个游戏App类的单件，确保只有一个实例被创建
 */
+ (MCGameAppDelegate*)sharedMCGameAppDelegate{
    static MCGameAppDelegate *sharedMCGameAppDelegate;
    @synchronized(self)
    {
        if (!sharedMCGameAppDelegate)
            sharedMCGameAppDelegate = [[MCGameAppDelegate alloc] init];
	}
	return sharedMCGameAppDelegate;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{   
    //laod external OBJ 3D model into appliaction
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"RadiusOneCubeWithPic" ofType:@"obj"];
    MCOBJLoader *tmp = [MCOBJLoader sharedMCOBJLoader];
    [tmp loadObjFromFile:filename objkey:nil];
    
    SoundSettingController * soundcontroller = [SoundSettingController sharedsoundSettingController];
    [soundcontroller loadSounds];
    [soundcontroller loadSoundConfiguration];
    
    
    
    //场景对象控制器
	MCSceneController * sceneController = [MCSceneController sharedSceneController];
	//MCCountingPlaySceneController * sceneController = [MCCountingPlaySceneController sharedCountingPlaySceneController];
    [[CoordinatingController sharedCoordinatingController] setCurrentController: sceneController];
    [[CoordinatingController sharedCoordinatingController] setWindow:window];
    //创建输入控制器，并绑定到场景控制器
	// make a new input view controller, and save it as an instance variable
	MCInputViewController * anInputController = [[MCInputViewController alloc] initWithNibName:nil bundle:nil];
    //MCCountingPlayInputViewController * anInputController = [[MCCountingPlayInputViewController alloc] initWithNibName:nil bundle:nil];
	sceneController.inputController = anInputController;
	[anInputController release];
	
    //创建glview
	// init our main EAGLView with the same bounds as the window
	EAGLView * glView = [[EAGLView alloc] initWithFrame:window.bounds];
    
    
	sceneController.inputController.view = glView;
	sceneController.openGLView = glView;
	
	
	// set our view as the first window view
    [window setRootViewController:sceneController.inputController];
	//[window addSubview:sceneController.inputController.view];
    
	[window makeKeyAndVisible];
	
    //开始游戏循环
	// begin the game.
	[sceneController loadScene];
	[sceneController startScene];
    
        
    [glView release];
    
    //[countingPlaySceneController loadScene];
    
/////////////////////////////
    
    

}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
