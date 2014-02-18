//
//  MCRandomSolveViewInputControllerViewController.h
//  MCGame
//
//  Created by kwan terry on 13-5-28.
//
//

#import "InputController.h"
#import "QuadCurveMenu.h"
#import "MCActionQueue.h"
#import "MCMultiDigitCounter.h"
#import "SolvePagePauseMenu.h"
#import "AskReloadView.h"

/**
 *	求解模式下的交互控制器。
 *  实现了UAModalPanelDelegate，可以加载UAModalPanel类型的对话框
 */
@interface MCRandomSolveViewInputControllerViewController : InputController <QuadCurveMenuDelegate,UAModalPanelDelegate>{
    /// 判断是否要弹出选择框到标记
    BOOL isWantShowSelectView;
    /**
     *	魔方旋转动作队列
     */
    MCActionQueue *actionQueue;
    /**
     *	计步器
     */
    MCMultiDigitCounter *stepcounter;
    /**
     *	输入是否结束
     */
    BOOL isFinishInput;
    NSMutableArray * singmasternotations;
    int totalMove;
    int currentMove;
    /**
     *	该变量没有特别的作用
     */
    BOOL isStay;
    SolvePagePauseMenu *solvePagePauseMenuView;
    AskReloadView* askReloadView;
}

@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, retain) QuadCurveMenu *selectMenu;
@property (nonatomic) CGPoint lastestPoint;
@property(nonatomic, retain)NSArray *cubieArray;
@property (nonatomic,retain) MCActionQueue *actionQueue;
@property (nonatomic,retain) MCMultiDigitCounter *stepcounter;

-(void)loadInterface;

-(void)mainMenuBtnDown;

-(void)mainMenuBtnUp;
//求解
-(void)qSolveBtnDown;
-(void)qSolveBtnUp;

//
-(void)pauseSolutionBtnDown;
-(void)pauseSolutionBtnUp;

//撤销
-(void)previousSolutionBtnUp;
-(void)previousSolutionBtnDown;

//恢复
-(void)nextSolutionBtnUp;
-(void)nextSolutionBtnDown;

-(void)releaseInterface;

@end
