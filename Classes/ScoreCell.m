//
//  ScoreCell.m
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-13.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "ScoreCell.h"

@implementation ScoreCell
@synthesize rankLabel;
@synthesize userNameLabel;
@synthesize moveLabel;
@synthesize timeLabel;
@synthesize speedLabel;
@synthesize scoreLabel;

/**
 *	初始化单元格对象
 *
 *	@param	style	单元格类型
 *	@param	reuseIdentifier	重用标识，当一个单元格滑出屏幕时，可以通过重用标识在另一边重用该单元格。
 *
 *	@return	自定义的单元格对象
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  处理被选中事件
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [rankLabel release];
    [userNameLabel release];
    [moveLabel release];
    [timeLabel release];
    [speedLabel release];
    [scoreLabel release];
    [super dealloc];
}

/**
 *	填充表格栏内容
 *
 *	@param	_rank	排名
 *	@param	_name	用户
 *	@param	_move	步数
 *	@param	_time	时间
 *	@param	_speed	速度
 *	@param	_score	总分
 */
-(void)setCellWithRank:(NSString *)_rank Name:(NSString *)_name Move:(NSString *)_move Time:(NSString *)_time Speed:(NSString *)_speed Score:(NSString *)_score
{
    rankLabel.text = _rank;
    userNameLabel.text = _name;
    moveLabel.text = _move;
    timeLabel.text = _time;
    speedLabel.text = _speed;
    scoreLabel.text = _score;
}
@end
