//
//  CoordinatingController.h
//  MCGame
//
//  Created by kwan terry on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCCountingPlaySceneController__1.h"
#import "MCSceneController.h"
#import "inputController.h"
#import "sceneController.h"
#import "MBProgressHUD.h"
#import "UserManagerSystemViewController.h"
#import "MCNormalPlaySceneController.h"
#import "MCRandomSolveSceneController.h"
#import "MCSystemSettingViewController.h"
/**
 *	名字虽然叫做“坐标控制器”，实际作用是控制各个场景的切换。在应用加载的时候，该类就开始作用。
 *  实现了MBProgressHUDDelegate协议(接口)，使用开源项目MBProgressHUD来表示场景切换时“等待中”的状态。
 */
@interface CoordinatingController : NSObject <MBProgressHUDDelegate>{
    /**
     *	当前使用的场景控制器
     */
    sceneController * currentController;
    MBProgressHUD *HUD;
    UIWindow *window;
    
@private
    /**
     *	主场景，就是有一个魔方在旋转的欢迎画面
     */
    MCSceneController * _mainSceneController;
    /**
     *	竞速场景
     */
    MCCountingPlaySceneController *_countingPlaySceneController;
    /**
     *	学习场景
     */
    MCNormalPlaySceneController *_normalPlaySceneController;
    /**
     *	求解场景
     */
    MCRandomSolveSceneController *_randomSolveSceneController;
    /**
     *	用户管理场景
     */
    UserManagerSystemViewController *userManagerSystemViewController;
    /**
     *	设置场景
     */
    MCSystemSettingViewController *_systemSettingViewController;
    BOOL needToReload;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (assign)BOOL needToReload;
@property (nonatomic ,readonly)MCSceneController *_mainSceneController;
@property (nonatomic, readonly )MCCountingPlaySceneController *_countingPlaySceneController;
@property (nonatomic, readonly )MCNormalPlaySceneController *_normalPlaySceneController;
@property (nonatomic, readonly ) MCRandomSolveSceneController *_randomSolveSceneController;
@property (nonatomic, readonly ) MCSystemSettingViewController *_systemSettingViewController;

@property (nonatomic,assign)sceneController *currentController;
@property (nonatomic,retain)UserManagerSystemViewController *userManagerSystemViewController;

+(CoordinatingController *) sharedCoordinatingController;
-(void)requestViewChangeByObject:(int)type;
@end
