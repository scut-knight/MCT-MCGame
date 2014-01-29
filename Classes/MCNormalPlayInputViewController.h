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

/**
 *	学习模式下的交互控制器。
 *  实现了UAModalPanelDelegate，可以加载UAModalPanel类型的对话框
 */
@interface MCNormalPlayInputViewController : InputController<UAModalPanelDelegate>{
    /**
     *	计步器
     */
    MCMultiDigitCounter *stepcounter;
    /**
     *	计时器
     */
    MCTimer * timer;
    /**
     *	重新加载时弹出的菜单
     */
    AskReloadView* askReloadView;
    /**
     *	暂停时的弹出菜单
     */
    LearnPagePauseMenu *learnPagePauseMenuView;
    /**
     *	学习模式结束时的弹出菜单
     */
    FinishView *finishView;
    /**
     *	魔方旋转动作队列
     */
    MCActionQueue *actionQueue;
    /**
     *	目前已经打乱的步数
     */
    int randomRotateCount;
    /**
     *	打乱阶段时控制打乱节奏
     */
    NSTimer *radomtimer;
    //优化random
    AxisType lastRandomAxis;
    /**
     *	是否位于打乱阶段
     */
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
