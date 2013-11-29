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
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((CFURLRef)fileURL, &soundId);
    
    [_sounds setObject:[NSNumber numberWithInt:soundId] forKey:key];
}

/**
 *	the same as - (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
 *  using an anonymous instance
 *	@param	filePath	: a NSString to define the file path
 *	@param	key	: id value
 */
+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addSoundAtPath:filePath forKey:key];
}

/**
 *	play particular sound in the _sounds with particular key
 *
 *	@param	key	: id value
 */
- (void)playSoundForKey:(id)key
{
    SystemSoundID soundId = [(NSNumber *)[_sounds objectForKey:key] intValue];
    AudioServicesPlaySystemSound(soundId);
}

/**
 *	play particular sound in the _sounds with particular key
 *  with an anoymous instance
 *	@param	key	: id value
 */
+ (void)playSoundForKey:(id)key
{
    [[self sharedInstance] playSoundForKey:key];
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
 *	@param	timer	
 */
- (void)fadeIn:(NSTimer *)timer
{
    AVAudioPlayer *player = [timer.userInfo objectForKey:@"player"];
    float maxvolume = [[timer.userInfo objectForKey:@"maxvolume"]floatValue];;
    float volume = player.volume;
    volume = volume + 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume > maxvolume ? maxvolume : volume;
    player.volume = volume;
    
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
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeInInterval > 0.0) {
        player.volume = 0.0;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:player forKey:@"player"];
        [dic setObject:maxvolume forKey:@"maxvolume"];
        NSTimeInterval interval = fadeInInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeIn:)
                                       userInfo:dic
                                        repeats:YES];
    }
    
    [player play];
}

/**
 *	call the fadeIn:(NSTimer *)timer to play the audio fading in gradually
 *  using an anoymous instance
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
    AVAudioPlayer *player = timer.userInfo ;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [player pause];
    }
}

/**
 *  结束音频，通过fadeOutInterval调节音量渐弱的速度
 */
- (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndStop:)
                                       userInfo:player
                                        repeats:YES];
    } else {
        [player stop];
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
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [player stop];
    }
}

/**
 *  结束音频，通过fadeOutInterval调节音量渐弱的速度
 */
- (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndPause:)
                                       userInfo:player
                                        repeats:YES];
    } else {
        [player pause];
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

@end
