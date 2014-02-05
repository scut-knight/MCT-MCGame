//
//  UserManagerSystemViewController.m
//  UserManagerSystemXib
//
//  Created by yellow Dai on 13-1-18.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "UserManagerSystemViewController.h"
#import "CoordinatingController.h"

@interface UserManagerSystemViewController ()

- (NSString *)timeInFormatFromTotalSeconds:(NSInteger)totalSeconds;


@end

@implementation UserManagerSystemViewController

@synthesize scoreTable = _scoreTable;
@synthesize currentUserLabel;
@synthesize totalFinishLabel;
@synthesize totalGameTimeLabel;
@synthesize totalMovesLabel;
@synthesize totalLearnTimeLabel;
@synthesize createUserPopover;
@synthesize changeUserPopover;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    userManagerController = [MCUserManagerController allocWithZone:NULL];
    
    //popover
    PopCreateUserViewController *contentForCreateUser = [[PopCreateUserViewController alloc] init];
    createUserPopover = [[UIPopoverController alloc] initWithContentViewController:contentForCreateUser];
    createUserPopover.popoverContentSize = CGSizeMake(320., 216.);
    createUserPopover.delegate = self;
    [contentForCreateUser release];
    
    PopChangeUserViewController *contentForChangeUser = [[PopChangeUserViewController alloc] init];
    changeUserPopover = [[UIPopoverController alloc] initWithContentViewController:contentForChangeUser];
    changeUserPopover.popoverContentSize = CGSizeMake(320., 216.);
    changeUserPopover.delegate = self;
    [contentForChangeUser release];
    
    //init user information
    self.currentUserLabel.text = userManagerController.userModel.currentUser.name;
    self.totalFinishLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalFinish];
    self.totalMovesLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalMoves];
    self.totalGameTimeLabel.text = [self timeInFormatFromTotalSeconds:(NSInteger)(userManagerController.userModel.currentUser.totalGameTime + 0.5)];
    
    self.totalLearnTimeLabel.text = [self timeInFormatFromTotalSeconds:(NSInteger)(userManagerController.userModel.currentUser.totalLearnTime + 0.5)];
    
    
    //observer to refresh the table view
    //notification was sent by user manager controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAndScore) name:@"UserManagerSystemUpdateScore" object:nil];
    
    // Init selector btn
    [_totalRankBtn setEnabled:NO];
    
    // Circular bead
    _scoreTable.layer.cornerRadius = 5.0;
    _staticScrollPanel.layer.cornerRadius = 5.0;
}

- (void)viewDidUnload
{
    [self setScoreTable:nil];
    [self setCurrentUserLabel:nil];
    [self setTotalFinishLabel:nil];
    [self setTotalGameTimeLabel:nil];
    [self setTotalMovesLabel:nil];
    [self setTotalLearnTimeLabel:nil];
    [self setBackBtn:nil];
    [self setTotalRankBtn:nil];
    [self setPersonalRankBtn:nil];
    [self setStaticScrollPanel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/**
 *	响应屏幕转动事件
 *
 *	@param	interfaceOrientation	屏幕朝向
 *
 *	@return	响应正常情况下的屏幕
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

- (void)dealloc {
    [_scoreTable release];
    [currentUserLabel release];
    [totalFinishLabel release];
    [totalGameTimeLabel release];
    [totalMovesLabel release];
    [totalLearnTimeLabel release];
    [_backBtn release];
    [_totalRankBtn release];
    [_personalRankBtn release];
    [_staticScrollPanel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Tableview delegates
/**
 *	只有一个分栏表格，表格有5行
 *
 *  之所以这样，是因为数据库控制器被设定成只查询前五个。
 *
 *  @see MCDBController
 *
 *	@param	section	分栏序号
 *
 *	@return	只返回5，表示所有的表格都只有5行
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

/**
 *  加载单元格图像
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ScoreCell* cell = (ScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"ScoreCellIdentifier"];
    
    //set score information
    NSInteger scoreIndex = [indexPath row]; // 0 ~ 4
    
    if (cell == nil) { // the cell can not be reused
        if (scoreIndex % 2 == 0) {
            if (scoreIndex == 4) { // 4
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCellBottomDark" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            else{ // 0 2
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCellCenterDark" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
        }
        else { // 1 3
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScoreCellCenterGrey" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
    }
    
    // 总排行，他这里的按钮比较奇葩！see totalRankBtnUp
    if ([_personalRankBtn isEnabled]) {
        if (scoreIndex < [userManagerController.userModel.topScore count]) {
                    
            MCScore *_scoreRecord = [userManagerController.userModel.topScore objectAtIndex:scoreIndex];
            
            NSString *_rank = [[NSString alloc] initWithFormat:@"%d",scoreIndex+1];
            NSString *_move = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.move];
            NSString *_time = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.time];
            NSString *_speed = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.speed];
            NSString *_score = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.score];
            
            [cell setCellWithRank:_rank Name:_scoreRecord.name Move:_move Time:_time Speed:_speed Score:_score];
            
            [_rank release];
            [_move release];
            [_time release];
            [_speed release];
            [_score release];
        }
        else {
            [cell setCellWithRank:@"" Name:@"" Move:@"" Time:@"" Speed:@"" Score:@""];
        }
    }
    else {      // 个人排行
                if (scoreIndex < [userManagerController.userModel.myScore count]) {
                   
                    MCScore *_scoreRecord = [userManagerController.userModel.myScore objectAtIndex:scoreIndex];
                    
                    NSString *_rank = [[NSString alloc] initWithFormat:@"%d",scoreIndex+1];
                    NSString *_move = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.move];
                    NSString *_time = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.time];
                    NSString *_speed = [[NSString alloc] initWithFormat:@"%0.2f", _scoreRecord.speed];
                    NSString *_score = [[NSString alloc] initWithFormat:@"%d", _scoreRecord.score];
                    
                    [cell setCellWithRank:_rank Name:_scoreRecord.name Move:_move Time:_time Speed:_speed Score:_score];
                    
                    [_rank release];
                    [_move release];
                    [_time release];
                    [_speed release];
                    [_score release];
               }
                else {
                    [cell setCellWithRank:@"" Name:@"" Move:@"" Time:@"" Speed:@"" Score:@""];
                }

                    }
    return cell;
}



#pragma mark -
#pragma mark Popover controller delegates
/**
 *	弹出框消失之后，对应的处理
 *
 *	@param	popoverController	不同的弹出框
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //pop over dismiss, and update user information 
    [self updateUserAndScore];
    
    if (popoverController == createUserPopover) {
        
    }
    
    if (popoverController == changeUserPopover) {
        
    }
}

#pragma mark -
#pragma mark user methods
/**
 *	按下创建用户的按钮
 *
 *	@param	sender	创建用户按钮
 */
- (void)createUserPress:(id)sender
{
    UIButton *tapbtn = (UIButton*) sender;
    // 弹出框在下方
    [createUserPopover presentPopoverFromRect:tapbtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

/**
 *	按下更改用户的按钮
 *
 *	@param	sender	更改用户按钮
 */
- (void)changeUserPress:(id)sender
{
    UIButton *tapbtn = (UIButton*) sender;
    // 弹出框在下方
    [changeUserPopover presentPopoverFromRect:tapbtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

/**
 * 按下总排名按钮，注意这里的视觉设置很巧妙，按下会发现按钮变暗了。
 * 那是因为一旦按下，当前按钮就设为disabled，所以变暗了。
 */
- (IBAction)totalRankBtnUp:(id)sender {
    [_totalRankBtn setEnabled:NO];
    [_personalRankBtn setEnabled:YES];
    [_scoreTable reloadData]; //建议改为updateScoreInformation
}

/**
 * 按下个人排名按钮
 */
- (IBAction)personalRankBtnUp:(id)sender {
    [_totalRankBtn setEnabled:YES];
    [_personalRankBtn setEnabled:NO];
    [_scoreTable reloadData];
}


#pragma mark goback
/**
 *  回到主菜单
 */
- (IBAction)goBackMainMenu:(id)sender {
    CoordinatingController *tmp = [CoordinatingController sharedCoordinatingController];
    [tmp requestViewChangeByObject:kScoreBoard2MainMenu];
}

/**
 *	更新用户信息，包括当前用户名，解开魔方数，总步数，学习时间和竞速时间
 */
- (void) updateUserInformation
{
    //user information
    self.currentUserLabel.text = userManagerController.userModel.currentUser.name;
    self.totalFinishLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalFinish];
    self.totalMovesLabel.text = [NSString stringWithFormat:@"%d",userManagerController.userModel.currentUser.totalMoves];
    self.totalGameTimeLabel.text = [NSString stringWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalGameTime];
    self.totalLearnTimeLabel.text = [NSString stringWithFormat:@"%0.2f",userManagerController.userModel.currentUser.totalLearnTime];
}

- (void)updateScoreInformation
{
    [_scoreTable reloadData];
}

- (void) updateUserAndScore
{
    [self updateUserInformation];
    [self updateScoreInformation];
}

/**
 *	将总用时(单位为秒)转换成00:00:00这样的表示形式
 *
 *	@param	totalSeconds	总用时
 *
 *	@return	00:00:00字符串
 */
- (NSString *)timeInFormatFromTotalSeconds:(NSInteger)totalSeconds{
    NSInteger second = totalSeconds % 60;
    NSInteger minute = totalSeconds / 60 % 60;
    NSInteger hour = totalSeconds / 3600 % 100;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}




@end
