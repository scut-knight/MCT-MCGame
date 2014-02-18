//
//  MCExplanationSystem.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCWorkingMemory.h"
#import "MCBasicElement.h"
#import "MCTransformUtil.h"


#define DEFAULT_PATTERN_ACCORDANCE_MESSAGE_NUM 5
/**
 *	表达式解释类，这个类解析之前构造起来的抽象语法树
 */
@interface MCExplanationSystem : NSObject

//After applying this pattern,
//intermediate informations will be stored here.
//However, these informations are those accordant condictions beacuse
//this pattern maybe not completely corresponding to current state of the rubik's cube.
/**
 *	储存着已经匹配的魔方公式的模式的字符串形式
 */
@property (nonatomic, retain) NSMutableArray *accordanceMsgs;
/**
 *	对workingMemory的引用
 */
@property (nonatomic, retain) MCWorkingMemory *workingMemory;

+ (MCExplanationSystem *)explanationSystemWithWorkingMemory:(MCWorkingMemory *)wm;


- (id)initExplanationSystemWithWorkingMemory:(MCWorkingMemory *)wm;


- (NSArray *)translateAgendaPattern;

@end
