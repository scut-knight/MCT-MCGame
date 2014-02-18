//
//  MCUserManagerController.h
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-30.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCDBController.h"
#import "MCUser.h"
#import "MCScore.h"
#import "MCUserManagerModel.h"
#import "MCUserCalculator.h"
/**
 *	用户系统管理控制类
 */
@interface MCUserManagerController : NSObject{
    
}

@property (nonatomic, retain) MCDBController* database;
@property (nonatomic, retain) MCUserManagerModel* userModel;
@property (nonatomic, retain) MCUserCalculator* calculator;

+ (MCUserManagerController*) sharedInstance;

- (BOOL) createNewUser:(NSString*)_name;
- (void) changeCurrentUser:(NSString*)_name;
- (void) updateAllUser;
- (void) updateCurrentUser;

- (void) createNewScoreWithMove:(NSInteger)_move Time:(double)_time;
- (void) updateTopScore;
- (void) updateMyScore;

- (void) createNewLearnWithMove:(NSInteger)_move Time:(double)_time;

- (void) saveCurrentUser;

@end
