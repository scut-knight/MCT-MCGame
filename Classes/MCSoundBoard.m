//
//  MCSoundBoard.m
//  MCSoundBoard
//
//  Created by Baglan Dosmagambetov on 7/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCSoundBoard.h"
#import <AudioToolbox/AudioToolbox.h>
/// 音量渐变的频率
#define MCSOUNDBOARD_AUDIO_FADE_STEPS   30

@implementation MCSoundBoard {
    /**
     *	@private 
     *  a NSMutableDictionary collect sound records
     */
    NSMutableDictionary *_sounds;
    /**
     *	@private
     *  a NSMutableDictionary collect audio records
     */
    NSMutableDictionary *_audio;
}
@synthesize backgroundPlayer;
// Sound board singleton
// Taken from http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
/**
 *	return a singleton to control
 *  if _shareObject has not been initialized, use MCSoundBoard to initialize it
 */
+ (MCSoundBoard *)sharedInstance
{
     static MCSoundBoard* _sharedObject = nil;
    @synchronized(self)
    {
        if (!_sharedObject)
            _sharedObject = [[MCSoundBoard alloc] init];
	}
    return _sharedObject;
}

/**
 *	initialize _sounds and _audio
 */
- (id)init
{
    self = [super init];
    if (self != nil) {
        _sounds = [[NSMutableDictionary alloc]init];
        _audio = [[NSMutableDictionary alloc]init];
    }
    return self;
}

/**
 *	add a soundId(int value) for selected filePath with a particular key
 *
 *	@param	filePath : a NSString to define the file path
 *	@param	key	: id value
 */
- (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [_sounds setObject:player forKey:key];
    [player release];
}

/**
 *	the same as - (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
 *  using an anonymous instance
 *
 *	@param	filePath	: a NSString to define the file path
 *	@param	key	: id value
 */
+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addSoundAtPath:filePath forKey:key];
}

/**
 *	play particular sound in the _sounds with particular key and particular volume
 *
 *	@param	key	: id value
 *  @param  volume : NSNumber value
 */
- (void)playSoundForKey:(id)key withVolume:(NSNumber *)volume
{
    AVAudioPlayer *player = [_sounds objectForKey:key];
    player.volume = [volume floatValue];
    [player play];
}

/**
 *	play particular sound in the _sounds with particular key and particular volume
 *
 *  with an anoymous instance
 *
 *	@param	key	: id value
 *  @param  volume : NSNumber value
 */
+ (void)playSoundForKey:(id)key withVolume:(NSNumber *)volume
{
    [[self sharedInstance] playSoundForKey:key  withVolume:volume];
}

/**
 *	add a player(int value) for selected filePath with a particular key
 *
 *	@param	filePath    : a NSString to define the file path
 *	@param	key	: id value
 */
- (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [_audio setObject:player forKey:key];
    [player release];
}

/**
 *	the same as - (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
 *
 *	@param	filePath	: a NSString to define the file path
 *	@param	key	id value
 */
+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addAudioAtPath:filePath forKey:key];
}

/**
 *	音量渐增
 *  定时器的调用者提供"player"键选择渐增的音频名，"maxvolume"键(float值)选择最大音量
 *
 *	@param	timer	
 */
- (void)fadeIn:(NSTimer *)timer
{
    backgroundPlayer = [timer.userInfo objectForKey:@"player"];
    float maxvolume = [[timer.userInfo objectForKey:@"maxvolume"]floatValue];;
    float volume = backgroundPlayer.volume;
    volume = volume + 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume > maxvolume ? maxvolume : volume;
    backgroundPlayer.volume = volume;
    
    if (volume == maxvolume) {
        [timer invalidate];
    }
}

/**
 *	call the fadeIn:(NSTimer *)timer to play the audio fading in gradually
 *
 *	@param	key	: id value
 *	@param	fadeInInterval
 *	@param	maxvolume
 */
- (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval maxVolume:(NSNumber*)maxvolume
{
    backgroundPlayer = [_audio objectForKey:key];
    if (fadeInInterval > 0.0) {
        backgroundPlayer.volume = 0.0;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:backgroundPlayer forKey:@"player"];
        [dic setObject:maxvolume forKey:@"maxvolume"];
        NSTimeInterval interval = fadeInInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeIn:)
                                       userInfo:dic
                                        repeats:YES];
        [dic release];
    }
    [backgroundPlayer play];
}

/**
 *	call the fadeIn:(NSTimer *)timer to play the audio fading in gradually
 *  using an anoymous instance
 *
 *	@param	key	: id value
 *	@param	fadeInInterval
 *	@param	maxvolume	
 */
+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval maxVolume:(NSNumber*)maxvolume
{
    [[self sharedInstance] playAudioForKey:key fadeInInterval:fadeInInterval maxVolume:maxvolume];
}

/**
 *	play the audio without fade in
 *
 *	@param	key	: id valur
 *	@param	maxvolume	
 */
+ (void)playAudioForKey:(id)key maxVolume:(NSNumber*)maxvolume
{
    [[self sharedInstance] playAudioForKey:key fadeInInterval:0.0 maxVolume:maxvolume];
}

/** 
 *   音量渐弱直至消失
 */
- (void)fadeOutAndStop:(NSTimer *)timer
{
    backgroundPlayer = timer.userInfo;
    float volume = backgroundPlayer.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    backgroundPlayer.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [backgroundPlayer pause];
    }
}

/**
 *  结束音频，通过fadeOutInterval调节音量渐弱的速度
 */
- (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
     backgroundPlayer = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndStop:)
                                       userInfo:backgroundPlayer
                                        repeats:YES];
    } else {
        [backgroundPlayer stop];
    }
}

/**
 *	the same as
 *  - (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
 *	using an anoymous instance
 */
+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self sharedInstance] stopAudioForKey:key fadeOutInterval:fadeOutInterval];
}

/**
 *	stop playing audio immediately
 */
+ (void)stopAudioForKey:(id)key
{
    [[self sharedInstance] stopAudioForKey:key fadeOutInterval:0.0];
}

/**
 *   音量渐弱直至消失
 */
- (void)fadeOutAndPause:(NSTimer *)timer
{
    backgroundPlayer = timer.userInfo;
    float volume = backgroundPlayer.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    backgroundPlayer.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [backgroundPlayer pause];
    }
}

/**
 *  结束音频，通过fadeOutInterval调节音量渐弱的速度
 */
- (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    backgroundPlayer = [_audio objectForKey:key];
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndPause:)
                                       userInfo:backgroundPlayer
                                        repeats:YES];
    } else {
        [backgroundPlayer pause];
    }
}

/**
 *	the same as
 *  - (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
 *	using an anoymous instance
 */
+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self sharedInstance] pauseAudioForKey:key fadeOutInterval:fadeOutInterval];
}

/**
 *  pause audio immediately
 */
+ (void)pauseAudioForKey:(id)key
{
    [[self sharedInstance] pauseAudioForKey:key fadeOutInterval:0.0];
}


- (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [_audio objectForKey:key];
}

+ (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [[self sharedInstance] audioPlayerForKey:key];
}

- (void)dealloc
{
    [_sounds release];
    [_audio release];
    [backgroundPlayer release];
    [super dealloc];
}
@end
