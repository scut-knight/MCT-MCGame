//
//  MCUserManagerController.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-30.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCUserManagerController.h"

#define userFile @"userFile.txt"

@implementation MCUserManagerController
/**
 *	标记是否已经生成了一个实例
 */
static MCUserManagerController* sharedSingleton_ = nil;

@synthesize userModel;
@synthesize database;
@synthesize calculator;

#pragma mark -
#pragma mark single instance methods
/**
 *	唯一的公有构造方式，防止产生多个实例
 *
 *	@return	该单件的唯一实例
 */
+ (MCUserManagerController *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL] init];
        NSLog(@"create single user manager controller");
    }
    return sharedSingleton_;
}
/**
 *	重载allocWithZone函数，防止生成副本
 */
+(id)allocWithZone:(NSZone *)zone
{
    return [MCUserManagerController sharedInstance];
}

/**
 *  重载copy函数，防止生成副本
 */
- (id)copy
{
    return self;
}
/**
 *	重载retain函数，防止生成副本
 */
-(id)retain
{
    return self;
}

/**
 *	重载retainCount函数，防止生成副本
 */
- (NSUInteger)retainCount
{
    return NSIntegerMax;// 返回最大的整数值，导致retain计数不成功
}

/**
 *	@return	用户数据文件的路径
 */
- (NSString *)dataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:userFile];
}

/**
 *	调用时从数据库中获取所有用户，并切换到最后用户(当前用户)
 */
- (id)init
{
    if (self = [super init]) {
        database = [MCDBController allocWithZone:NULL];
        userModel = [MCUserManagerModel allocWithZone:NULL];
        calculator = [MCUserCalculator alloc];
        
        //init all users from database
        [self updateAllUser];
        // 注意当前用户是从userfile中获取的
        NSData *lastUser = [[NSData alloc] initWithContentsOfFile:[self dataFilePath]];
        NSString *lastName = [[NSString alloc] initWithData:lastUser encoding:NSStringEncodingConversionExternalRepresentation];
        [self changeCurrentUser:lastName];
        [lastName release];
        [lastUser release];
        
        //init top score
        [self updateTopScore];
        [self updateMyScore];
        
        //add observer to database and user model
        //notification was sent by MC DB Controller
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertUserSuccess:) name:@"DBInsertUserSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertScoreSuccess) name:@"DBInsertScoreSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertLearnSuccess) name:@"DBInsertLearnSuccess" object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [database release];
    [userModel release];
    [calculator release];
    [super dealloc];
}

#pragma mark -
#pragma mark user methods
/**
 *	以_name新建一个新的用户，用户的各项信息均为空值
 *
 *	@param	_name	新用户的用户名
 *
 *	@return	如果用户已存在，返回NO；否则插入新用户并且返回YES
 */
- (BOOL)createNewUser:(NSString *)_name
{
    for (MCUser* user in userModel.allUser) {
        if ([user.name isEqualToString:_name]) {
            return NO;
        }
    }
    
    MCUser *newUser = [[MCUser alloc] initWithUserID:0 UserName:_name UserSex:@"unknown" totalMoves:0 totalGameTime:0 totalLearnTime:0 totalFinish:0];
    [database insertUser:newUser];
    [newUser release];
    
    return YES;
}

- (void)changeCurrentUser:(NSString *)_name
{
    for (MCUser* user in userModel.allUser) {
        if ([user.name isEqualToString:_name]) {
            self.userModel.currentUser = user;
        }
    }
    NSLog(@"change user");
    
    [self saveCurrentUser];
    [self updateMyScore];
}
/**
 *	一旦更新成功，改变当前用户为已更新的用户
 *
 *	@param	_notification	观察者发送过来的信息包
 */
- (void) insertUserSuccess:(NSNotification*)_notification
{
    //after insert successful, update information
    [self updateAllUser];
    
    NSString* name = [[NSString alloc] initWithString:[_notification.userInfo objectForKey:@"name"]];
    [self changeCurrentUser:name];
    [name release];
}

- (void)updateAllUser
{
    self.userModel.allUser = [database queryAllUser];
    NSLog(@"update all user");
}

- (void)updateCurrentUser
{
    self.userModel.currentUser = [database queryUser:userModel.currentUser.name];
}

#pragma mark
#pragma mark score methods
/**
 *	通过步数和时间来更新得分，并且更新数据库
 *
 *	@param	_move	使用步数
 *	@param	_time	消耗时间
 */
- (void)createNewScoreWithMove:(NSInteger)_move Time:(double)_time
{
    NSInteger _score = [calculator calculateScoreForMove:_move Time:_time];
    double _speed = [calculator calculateSpeedForMove:_move Time:_time];
    
    NSDate *date = [[NSDate alloc] init];
    NSString* _date = [date description];
    [date release];
    
    MCScore* newScore = [[MCScore alloc] initWithScoreID:0 userID:userModel.currentUser.userID name:userModel.currentUser.name score:_score move:_move time:_time speed:_speed date:_date];    
    [database insertScore:newScore];
    
    [newScore release];
}
/**
 *	一旦更新成功，改变当前用户数据
 *
 *	@param	_notification	观察者发送过来的信息包
 */
- (void) insertScoreSuccess
{
    //after insert successful, update information
    [self updateTopScore];
    [self updateMyScore];
    
    [self updateAllUser];
    [self updateCurrentUser];
    
    //post notification to view controller to refresh view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserManagerSystemUpdateScore" object:nil];
}

#pragma mark -learn methods
/**
 *	通过步数和时间来更新学习记录，并且更新数据库
 *
 *	@param	_move	使用步数
 *	@param	_time	消耗时间
 */
- (void) createNewLearnWithMove:(NSInteger)_move Time:(double)_time
{
    NSDate *date = [[NSDate alloc] init];
    NSString* _date = [date description];
    [date release];
    
    MCLearn* newLearn = [[MCLearn alloc] initWithLearnID:0 userID:userModel.currentUser.userID name:userModel.currentUser.name move:_move time:_time date:_date];
    [database insertLearn:newLearn];
    
    [newLearn release];
}
/**
 *	一旦更新成功，改变当前用户数据
 *
 *	@param	_notification	观察者发送过来的信息包
 */
- (void) insertLearnSuccess
{
    //after insert learn record. update information
    [self updateAllUser];
    [self updateCurrentUser];
    
    //post notification to view controller to refresh view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserManagerSystemUpdateScore" object:nil];

}

- (void)updateTopScore
{
    self.userModel.topScore = [database queryTopScore];
    NSLog(@"update top score");
}
/**
 *	更新当前用户的最高的五个得分
 */
- (void)updateMyScore
{
    self.userModel.myScore = [database queryMyScore:userModel.currentUser.userID];
    NSLog(@"update my score");
}


/**
 *	将当前用户数据写入userfile。
 */
- (void)saveCurrentUser
{
    if (userModel.currentUser.name != nil) {
    //save current user to file
    const char *name = [userModel.currentUser.name UTF8String];
    //NSData *lastUser = [[NSData alloc] initWithBytes:userModel.currentUser.name length:[userModel.currentUser.name length]]; 
    NSData *lastUser = [NSData dataWithBytes:name length:strlen(name)];
    
    NSLog(@"user name: %s",[lastUser bytes]);
    
    [lastUser writeToFile:[self dataFilePath] atomically:YES];
    }
}

@end
