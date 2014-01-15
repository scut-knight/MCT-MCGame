//
//  MCInputViewController.h
//  MCGame
// 
//  Created by ruitaoCC@gmail.com on 1/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputController.h"
#import "MCParticleSystem.h"

/**
 *	输入场景控制器
 *
 *  负责加载主场景的场景对象和调用各个子场景的控制器
 */
@interface MCInputViewController : InputController{
    //MCParticleSystem *particleEmitter;
}
//overload
-(void)loadInterface;
//selectors
-(void)countingPlayBtnDown;
-(void)countingPlayBtnUp;
-(void)normalPlayBtnDown;
-(void)normalPlayBtnUp;
-(void)randomSolveBtnDown;
-(void)randomSolveBtnUp;
-(void)systemSettingBtnDown;
-(void)systemSettingBtnUp;
-(void)heroBoardBtnDown;
-(void)heroBoardBtnUp;


@end
