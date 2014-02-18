//
//  MCCountingPlayInputViewController__1.h
//  MCGame
//
//  Created by kwan terry on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputController.h"
#import "MCMultiDigitCounter.h"
#import "MCTimer.h"
#import "UAModalPanel.h"
#import "PauseMenu.h"
#import "CountingFinishView.h"
#import "AskReloadView.h"

/**
 *	竞速模式下的交互控制器。
 *  实现了UAModalPanelDelegate，可以加载UAModalPanel类型的对话框
 */
@interface MCCountingPlayInputViewController : InputController<UAModalPanelDelegate>{
    /**
     *	计步器
     */
    MCMultiDigitCounter *stepcounter;
    /**
     *	计时器
     */
    MCTimer * timer;
    /**
     *	暂停时的弹出菜单
     */
    PauseMenu* puseMenu;
    /**
     *	竞速模式结束时的弹出菜单
     */
    CountingFinishView *finishView;
    /**
     *	重新加载时弹出的菜单
     */
    AskReloadView* askReloadView;

}
@property (nonatomic,retain) MCMultiDigitCounter *stepcounter;
@property (nonatomic,retain) MCTimer * timer;
//overload
-(void)loadInterface;

//interface action selectors
//撤销
-(void)previousSolutionBtnUp;
-(void)previousSolutionBtnDown;
//暂停
-(void)pauseSolutionBtnUp;
-(void)pauseSolutionBtnDown;
//恢复
-(void)nextSolutionBtnUp;
-(void)nextSolutionBtnDown;

-(void)mainMenuBtnDown;
-(void)mainMenuBtnUp;

-(void)releaseInterface;
-(void)showFinishView;

@end
