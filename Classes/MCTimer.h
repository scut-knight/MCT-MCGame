//
//  MCTimer.h
//  MCGame
//
//  Created by kwan terry on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
#import "MCMultiDigitCounter.h"
#import "MCDotSeparater.h"
/**
 *	刷新计时器的时间间隔
 */
#define Interval 0.0005
/**
 *	计时器
 *
 *  注意该计时器并不使用获取当前时间的API。它仅仅是从当前的CoordinatingController获取已经消逝的时间差，并刷新计时器画面。
 */
@interface MCTimer : MCSceneObject{
    long  totalTime;//毫秒值
    //NSTimer * m_nstimer;
    MCMultiDigitCounter * m_hour;
    /**
     *	位于小时与分钟的相隔点
     */
    MCDotSeparater * separater21;
    MCMultiDigitCounter * m_minute;
    /**
     *	位于分钟与秒的相隔点
     */
    MCDotSeparater * separater22;
    MCMultiDigitCounter * m_second;
    /**
     *	位于秒与毫秒的相隔点
     */
    MCDotSeparater * separater11;
    MCMultiDigitCounter * m_millisecond;
    BOOL isStop;
}
@property (assign)long  totalTime;

- (id) initWithTextureKeys:(NSString *[])texturekeys;
-(void)carryLogic;
-(void)reset;
-(void)startTimer;
-(void)stopTimer;
- (void)awake;
- (void)update;
-(void)render;


@end
