//
//  MCNormalPlayInputViewController.m
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "MCNormalPlaySceneController.h"
#import "MCTexturedButton.h"
#import "MCNormalPlayInputViewController.h"
#import "CoordinatingController.h"
#import "MCLabel.h"
#import "MCPlayHelper.h"
#import "MCStringDefine.h"
#import "MCMaterialController.h"
#import "Global.h"

@implementation MCNormalPlayInputViewController
@synthesize stepcounter;
@synthesize timer;
@synthesize actionQueue;
@synthesize isRandoming;

/**
 *	加载场景
 */
-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
    lastRandomAxis = X;
    randomRotateCount = 0;
    isRandoming = NO;
    //UI step counter
    // 计步器纹理名
    NSString *counterName[10] = {@"zero2",@"one2",@"two2",@"three2",@"four2",@"five2",@"six2",@"seven2",@"eight2",@"nine2"};
    stepcounter = [[MCMultiDigitCounter alloc]initWithNumberOfDigit:3 andKeys:counterName];
    [stepcounter setScale : MCPointMake(51, 25, 1.0)];
    [stepcounter setTranslation :MCPointMake(470, -360, 0.0)];
    [stepcounter setActive:YES];
    [stepcounter awake];
    [interfaceObjects addObject:stepcounter];
    
    //UI UI step counter label
    MCLabel *counterLabel= [[MCLabel alloc]initWithNstring:TextureKey_step];
    counterLabel.scale =  MCPointMake(48, 25, 1);
    [counterLabel setTranslation :MCPointMake(410, -360, 0.0)];
    [counterLabel setActive:YES];
    [counterLabel awake];
    [interfaceObjects addObject:counterLabel];
    [counterLabel release];
    
    //UI timer
    MCLabel *timerLabel= [[MCLabel alloc]initWithNstring:TextureKey_time];
    [timerLabel setScale :  MCPointMake(48, 25, 1)];
    [timerLabel setTranslation :MCPointMake(-475, -360, 0.0)];
    [timerLabel setActive:YES];
    [timerLabel awake];
    [interfaceObjects addObject:timerLabel];
    [timerLabel release];
    //UI timer
    timer = [[MCTimer alloc]initWithTextureKeys:counterName];
    [timer setScale:MCPointMake(153, 25, 1.0)];
    [timer setTranslation:MCPointMake(-345, -360, 0.0)];
    [timer setActive:YES];
    [timer awake];
    [interfaceObjects addObject:timer];
    
    //add action queue
    NSMutableArray *actionname = [[NSMutableArray alloc]init];
    actionQueue = [[MCActionQueue alloc]initWithActionList:actionname] ;
    [actionQueue setScale : MCPointMake(32, 32, 1.0)];
    [actionQueue setTranslation :MCPointMake(0, 340, 0.0)];
    [actionQueue setActive:NO];
    [actionQueue awake];
    [interfaceObjects addObject:actionQueue];
    [actionname release];
       
    //提示按钮
    MCTexturedButton * showTipsBtn = [[MCTexturedButton alloc] initWithUpKey:TextureKey_showTipsButtonUp downKey:TextureKey_showTipsButtonDown];
	showTipsBtn.scale =  MCPointMake(82, 56, 1);;
	showTipsBtn.translation = MCPointMake(512-41, 345, 0.0);
	showTipsBtn.target = self;
	showTipsBtn.buttonDownAction = @selector(tipsBtnDown);
	showTipsBtn.buttonUpAction = @selector(tipsBtnUp);
	showTipsBtn.active = YES;
	[showTipsBtn awake];
	[interfaceObjects addObject:showTipsBtn];
	[showTipsBtn release];

    //上一步/撤销
	MCTexturedButton * undoCommand = [[MCTexturedButton alloc] initWithUpKey:TextureKey_previousButtonUp downKey:TextureKey_previousButtonDown];
	undoCommand.scale =  MCPointMake(93, 58, 1);;
	undoCommand.translation = MCPointMake(-512+46, 0.0, 0.0);
	undoCommand.target = self;
	undoCommand.buttonDownAction = @selector(previousSolutionBtnDown);
	undoCommand.buttonUpAction = @selector(previousSolutionBtnUp);
	undoCommand.active = YES;
	[undoCommand awake];
	[interfaceObjects addObject:undoCommand];
	[undoCommand release];
    

    
    //暂停
	MCTexturedButton * pause = [[MCTexturedButton alloc] initWithUpKey:TextureKey_pauseButtonUp downKey:TextureKey_pauseButtonDown];
	pause.scale =  MCPointMake(73, 44, 1);;
	pause.translation = MCPointMake(-455, 345, 0.0);
	pause.target = self;
	pause.buttonDownAction = @selector(pauseSolutionBtnDown);
	pause.buttonUpAction = @selector(pauseSolutionBtnUp);
	pause.active = YES;
	[pause awake];
	[interfaceObjects addObject:pause];
	[pause release];
    
    
    //下一步/恢复
	MCTexturedButton * redoCommand = [[MCTexturedButton alloc] initWithUpKey:TextureKey_nextButtonUp downKey:TextureKey_nextButtonDown];
	redoCommand.scale =  MCPointMake(93, 58, 1);
	redoCommand.translation = MCPointMake(512-46, 0.0, 0.0);
	redoCommand.target = self;
	redoCommand.buttonDownAction = @selector(nextSolutionBtnDown);
	redoCommand.buttonUpAction = @selector(nextSolutionBtnUp);
	redoCommand.active = YES;
	[redoCommand awake];
	[interfaceObjects addObject:redoCommand];
	[redoCommand release];
    
    [super loadInterface];
    //基本界面加载完后，弹出是否加载上次未完成的任务，一定会弹出哦！
    //if (!isNeededReload) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(askReload) userInfo:nil repeats:NO];
    //}
    
    
    
}

/**
 *	按下了提示按钮。
 *  产生tips框，并显示旋转动作队列。
 */
-(void)tipsBtnUp{
    if (isRandoming) {
        return;
    }
    // 访问场景控制器，开始控制场景对象
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    //hiden the action queue
    [self.actionQueue setActive : !self.actionQueue.active ];
    //hiden the tips
    [[c tipsLabel] setHidden:![[c tipsLabel] isHidden]];
    //switch the isShowQueue flag in scenecontroller
    c.isShowQueue = !c.isShowQueue;
    // 开
    if (self.actionQueue.active) {
        [[c playHelper] prepare];
        [c showQueue];
    }else{
    // 关
        [self.actionQueue removeAllActions];
        [c closeSpaceIndicator];
        [[c tipsLabel]setText:@""];
        [[c playHelper] close];
    }
};

/**
 *	按下提示按钮时，什么都不做。
 */
-(void)tipsBtnDown{};

/**
 *	虽然名字叫做randomBtnUp，但是由于设计改动的原因，并没有random按钮了。
 *  不过这个函数将在重新加载场景时调用，用于打乱魔方。
 */
-(void)randomBtnUp{
    //TIME_PER_ROTATION = 0.15;
    // 打乱锁
    isRandoming = YES;
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c closeSpaceIndicator];
    // 定时反复打乱
    radomtimer = [NSTimer scheduledTimerWithTimeInterval:TIME_PER_ROTATION+0.1 target:self selector:@selector(randomRotateHelp1) userInfo:nil repeats:YES];
    // 打乱后……
    [NSTimer scheduledTimerWithTimeInterval:(TIME_PER_ROTATION+0.1)*(RandomRotateMaxCount+1)+0.1 target:self selector:@selector(randomRotateHelp2) userInfo:nil repeats:NO];
};

/**
 *	打乱的方法
 */
-(void)randomRotateHelp1{
    randomRotateCount ++;
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    RANDOM_SEED();
    
    //更新下一次spaceindicator方向
   
    AxisType axis = (AxisType)(RANDOM_INT(0, 2));
    if (axis==lastRandomAxis) {
        axis = (AxisType)((lastRandomAxis+1)%3);
    }
    lastRandomAxis = axis;
    LayerRotationDirectionType direction = (LayerRotationDirectionType)(RANDOM_INT(0, 1));
    int layer = RANDOM_INT(0, 2);
    [c rotateOnAxis:axis onLayer:layer inDirection:direction isTribleRotate:NO];
    
    if (randomRotateCount == RandomRotateMaxCount) {
        [radomtimer invalidate];
    }
}

/**
 *	打乱结束后的处理工作
 */
-(void)randomRotateHelp2{
    isRandoming = NO;
    randomRotateCount =0;
    [timer startTimer];
    //TIME_PER_ROTATION = 0.5;
    [[self stepcounter]reset];
}

/**
 *	空方法，为了配合randomBtnUp而存在，不要删掉
 */
-(void)randomBtnDown{};

#pragma mark - queue shift

-(void)shiftLeftBtnDown{}
-(void)shiftLeftBtnUp{[actionQueue shiftLeft];}
-(void)shiftRightBtnDown{}
-(void)shiftRightBtnUp{[actionQueue shiftRight];}


#pragma mark - button actions

/**
 *	按下了上一步按钮，撤销操作
 */
-(void)previousSolutionBtnUp{
    NSLog(@"previousSolutionBtnUp");
   MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c previousSolution];
}

/**
 *	空的方法，为了配合previousSolutionBtnUp而存在，不要删掉。
 */
-(void)previousSolutionBtnDown{}

/**
 *	按下暂停按钮，开始暂停操作。
 */
-(void)pauseSolutionBtnUp{
    NSLog(@"pauseSolutionBtnUp");
    //停止计时器
    [timer stopTimer];
    
    //弹出对话框
    learnPagePauseMenuView = [[LearnPagePauseMenu alloc] initWithFrame:self.view.bounds title:@"暂停"]; /*autorelease*/
    learnPagePauseMenuView.isShowColseBtn = NO;
    learnPagePauseMenuView.delegate = self;
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:learnPagePauseMenuView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[learnPagePauseMenuView showFromPoint:CGPointMake(512,384)];
}

/**
 *	空的方法，为了配合pauseSolutionBtnUp而存在，不要删掉。
 */
-(void)pauseSolutionBtnDown{}

/**
 *	按下了下一步按钮，恢复操作
 */
-(void)nextSolutionBtnUp{
    //;
    NSLog(@"nextSolutionBtnUp");
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c nextSolution];
}

/**
 *	空的方法，为了配合nextSolutionBtnUp而存在，不要删掉。
 */
-(void)nextSolutionBtnDown{}

-(void)mainMenuBtnDown{
    NSLog(@"mainMenuBtnDown");
}

/**
 *	保存魔方状态，并把控制权交由场景迁徙协调控制器。
 */
-(void)mainMenuBtnUp{
    NSLog(@"mainMenuBtnUp");
    
    //保存魔方状态
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:TmpMagicCubeData];
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    if (![[c tipsLabel]isHidden]) {
        [[c tipsLabel]setHidden:YES];
    }
    [NSKeyedArchiver archiveRootObject:[c magicCube] toFile:fileName];
    
    //发送消息到界面迁移协调控制器
    CoordinatingController *coordinatingController_ = [CoordinatingController sharedCoordinatingController];
    [coordinatingController_ requestViewChangeByObject:kMainMenu];
}



#pragma mark - UAModalDisplayPanelViewDelegate

/**
 * Optional: This is called before the open animations.
 *   Only used if delegate is set.
 */
- (void)willShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
}

/**
 * Optional: This is called after the open animations.
 *   Only used if delegate is set.
 */
- (void)didShowModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
}

/**
 * Optional: This is called when the close button is pressed
 *   You can use it to perform validations
 *   Return YES to close the panel, otherwise NO
 *   Only used if delegate is set.
 */
- (BOOL)shouldCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
	return YES;
}

/**
 * Optional: This is called before the close animations.
 *   Only used if delegate is set.
 */
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
}

/**
 * Optional: This is called after the close animations.
 *   Only used if delegate is set.
 *
 *  根据模态对话框的不同选项进行不同的操作。
 *  在模态对话框关闭后执行。
 */
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
	UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
    // 重新加载
    if (askReloadView) {
        // 继续上一次
        if ([askReloadView askReloadType]==kAskReloadView_LoadLastTime) {
            //重新加载上一次；
            //更新数据模型
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *filePath = [path stringByAppendingPathComponent:TmpMagicCubeData];
            
            MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
            c.magicCube=[MCMagicCube unarchiveMagicCubeWithFile:filePath];
            c.playHelper=[MCPlayHelper playerHelperWithMagicCube:[c magicCube]];
            
            //更新UI模型
            [c reloadLastTime];
            [[self timer]startTimer];
            NSLog(@"dd");
        // 重新开始
        }else if([askReloadView askReloadType]==kAskReloadView_Reload){
            //Default
            [self randomBtnUp];
            
        }else{
            //cancel
            
            
        }
        askReloadView = nil;
    }
    
    // 暂停
    if (learnPagePauseMenuView){
        // 保存并返回
        if ([learnPagePauseMenuView learnPagePauseSelectType]==kLearnPagePauseSelect_GoBack) {
            [self mainMenuBtnUp];
        // 继续
        }else if([learnPagePauseMenuView learnPagePauseSelectType]==kLearnPagePauseSelect_GoOn){
            //停止计时器
    
            [timer startTimer];
        // 重新开始
        }else if([learnPagePauseMenuView learnPagePauseSelectType]==kLearnPagePauseSelect_Restart){
            //更新UI模型
            
            //Default
            MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
            //hiden the action queue
            [self.actionQueue setActive : NO ];
            //hiden the tips
            [[c tipsLabel] setHidden:YES];
            c.isShowQueue = NO;
            [self.actionQueue removeAllActions];
            [[c tipsLabel]setText:@""];
            [[c playHelper] close];
            
            //counter reset
            [stepcounter reset];
            [timer reset];
            [self randomBtnUp];
        }
        
        learnPagePauseMenuView = nil;
    }
    if (finishView){
        // 除了退出没得选啦
        if ([finishView finishViewType]==kFinishView_GoBack) {
            [self mainMenuBtnUp];
        }        
        finishView = nil;
    }
}

/**
 *	学习模式结束时弹出的对话框
 */
-(void)showFinishView{
    
    //停止计时器
    [timer stopTimer];
    
    //弹出对话框
    finishView = [[FinishView alloc] initWithFrame:self.view.bounds title:@"结束"]; /*autorelease*/
    finishView.isShowColseBtn = NO;
    finishView.delegate = self;
    finishView.alpha = 0.2;
    
    
    // Set step count and learing time.
    finishView.learningStepCountLabel.text = [NSString stringWithFormat:@"%d", stepcounter.m_counterValue];
    finishView.learningTimeLabel.text = [timer description];
    finishView.lastingTime = timer.totalTime/1000;
    finishView.stepCount = stepcounter.m_counterValue;
    
    // If no name, set 'Rubiker'
    if ([finishView.userNameEditField.text compare:@""] == NSOrderedSame) {
        finishView.userNameEditField.text = @"Rubiker";
    }
    
    
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:finishView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[finishView showFromPoint:CGPointMake(512,384)];

}

/**
 *	在重新加载场景时弹出的对话框
 */
-(void)askReload{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:TmpMagicCubeData];
    if (fileName!=nil) {
        NSFileManager *fm;
        //Need to create an instance of the file manager
        fm = [NSFileManager defaultManager];
        
        //Let's make sure our test file exists first
        if([fm fileExistsAtPath: fileName] == NO)
        {
            NSLog(@"File doesn't exist'");
            return ;  
        }
        
    }
    //弹出对话框
    askReloadView = [[AskReloadView alloc] initWithFrame:self.view.bounds title:@"上次学习未完成"]; /*autorelease*/
    askReloadView.isShowColseBtn = NO;
    askReloadView.delegate = self;
    ///////////////////////////////////
	// Add the panel to our view
	[self.view  addSubview:askReloadView];
	///////////////////////////////////
    
	// Show the panel from the center of the button that was pressed
	[askReloadView showFromPoint:CGPointMake(512,384)];
}

/**
 *	加载上一次
 */
-(void)reloadLastTime{
    NSLog(@"reloadLastTime");
    MCNormalPlaySceneController *c = [MCNormalPlaySceneController sharedNormalPlaySceneController ];
    [c reloadLastTime];
}

- (void)releaseInterface{
    [super releaseInterface];
}
@end
