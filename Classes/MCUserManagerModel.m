//
//  MCUserManagerModel.m
//  UserManagerSystem2
//
//  Created by Yingyi Dai on 12-12-29.
//  Copyright (c) 2012年 SCUT. All rights reserved.
//

#import "MCUserManagerModel.h"
#import "MCUser.h"

@implementation MCUserManagerModel
/**
 *	标记是否已经生成了一个实例
 */
static MCUserManagerModel* sharedSingleton_ = nil;

@synthesize currentUser;
@synthesize allUser;
@synthesize topScore;
@synthesize myScore;

#pragma mark implement singleton
/**
 *	唯一的公有构造方式，防止产生多个实例
 *
 *	@return	该单件的唯一实例
 */
+ (MCUserManagerModel *)sharedInstance
{
    if (sharedSingleton_ == nil) {
        sharedSingleton_ = [[super allocWithZone:NULL] init ];
        // 注意初始化时有命令行输出
        NSLog(@"create single user model");
    }
    return sharedSingleton_;
}
/**
 *	重载allocWithZone函数，防止生成副本
 */
+(id)allocWithZone:(NSZone *)zone
{
    return [MCUserManagerModel sharedInstance];
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


- (id)init
{
    if (self = [super init]) {
        currentUser = [[MCUser alloc] init];
        allUser = [[NSMutableArray alloc] init];
        topScore = [[NSMutableArray alloc] init];
        myScore = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc{
    self.allUser = nil;
    self.topScore = nil;
    self.myScore = nil;
    [super dealloc];
}


@end
