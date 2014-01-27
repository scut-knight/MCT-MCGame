//
//  MCNormalPlayInputViewController.h
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "InputController.h"
#import "UAModalPanel.h"
#import "MCMultiDigitCounter.h"
#import "MCTimer.h"
#import "AskReloadView.h"
#import "MCActionQueue.h"
#import "FinishView.h"
#import "LearnPagePauseMenu.h"
@interface MCNormalPlayInputViewController : InputController<UAModalPanelDelegate>{
    MCMultiDigitCounter *stepcounter;
    MCTimer * timer;
    AskReloadView* askReloadView;
    LearnPagePauseMenu *learnPagePauseMenuView;
    FinishView *finishView;
    MCActionQueue *actionQueue;
    int randomRotateCount;
    NSTimer *radomtimer;
    //优化random
    AxisType lastRandomAxis;
    BOOL isRandoming;
}

@property (nonatomic,retain) MCActionQueue *actionQueue;
@property (nonatomic,retain) MCMultiDigitCounter *stepcounter;
@property (nonatomic,retain) MCTimer * timer;
@property (nonatomic,assign) BOOL isRandoming;

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
//回到主菜单
-(void)mainMenuBtnDown;
-(void)mainMenuBtnUp;
//队列
-(void)shiftLeftBtnDown;
-(void)shiftLeftBtnUp;

-(void)shiftRightBtnDown;
-(void)shiftRightBtnUp;

-(void)showFinishView;
- (void)releaseInterface;

-(void)tipsBtnUp;
-(void)tipsBtnDown;
@end
