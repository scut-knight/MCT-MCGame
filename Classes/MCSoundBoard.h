//
//  MCSoundBoard.h
//  MCSoundBoard
//
//  Created by Baglan Dosmagambetov on 7/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

/**
 *  @file
 *  “Make playing audio from an iOS app simpler” 开源项目，介绍：
 *	@see https://github.com/Baglan/MCSoundBoard
 *
 *  提供一个控制声音的单件，用来简化对背景音乐的播放的处理，主要用于播放一小段音频
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 *	sound and audio controller
 */
@interface MCSoundBoard : NSObject

//sounds
+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key;
+ (void)playSoundForKey:(id)key withVolume:(NSNumber *)volume;


//audioes
+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key;

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval maxVolume:(NSNumber*)maxvolume;
+ (void)playAudioForKey:(id)key maxVolume:(NSNumber*)maxvolume;

+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)stopAudioForKey:(id)key;

+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval;
+ (void)pauseAudioForKey:(id)key;

+ (AVAudioPlayer *)audioPlayerForKey:(id)key;

@end
