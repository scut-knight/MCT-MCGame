//
//  MCInferenceEngine.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCKnowledgeBase.h"
#import "MCTransformUtil.h"
#import "MCWorkingMemory.h"
#import "MCActionPerformer.h"

/**
 *	魔方公式推断引擎
 */
@interface MCInferenceEngine : NSObject

@property (nonatomic, retain) MCWorkingMemory *workingMemory;
@property (nonatomic, retain) MCActionPerformer *actionPerformer;
@property (nonatomic, retain) NSDictionary *patterns;
@property (nonatomic, retain) NSDictionary *rules;
@property (nonatomic, retain) NSDictionary *specialPatterns;
@property (nonatomic, retain) NSDictionary *specialRules;
@property (nonatomic, retain) NSDictionary *states;


+ (MCInferenceEngine *)inferenceEngineWithWorkingMemory:(MCWorkingMemory *)wm;


- (id)iniInferenceEngineWithWorkingMemory:(MCWorkingMemory *)wm;
/**
 * Check whether the target cubie is at home
 */
- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity;
/**
 * Avoiding to loading all rules into memory,
 * Every time we just load rules that can be applied at current state.
 * Thereby we should reload rules whenever the state of rubik's cube changes.
 */
- (void)reloadRulesAccordingToCurrentStateOfRubiksCube;
/**
 * Apply the pattern and return result
 */
- (BOOL)applyPatternWihtPatternName:(NSString *)name ofType:(AppliedRuleType)type;


- (NSInteger)treeNodesApply:(MCTreeNode *)root withDeep:(NSInteger)deep;

/**
 *	Check the current state and return it.Change workingMemory.magicCubeState to new state
 *
 *	@param	isCheckStateFromInit	是否需要初始化
 *
 *	@return	(NSString*)workingMemory.magicCubeState
 */
- (NSString *)checkStateFromInit:(BOOL)isCheckStateFromInit;
/**
 * 准备进行推断
 *
 * Do some preparation work for reasoning.
 */
- (void)prepareReasoning;

/**
 * 选择适当的推断
 *
 * Begin the inference and return appropriate result.Change self.workingMemory.agendaPattern to an approriate pattern.
 *
 * @return the approriate rule
 */
- (MCRule *)reasoning;

/**
 *	结束推断，清理遗留的数据
 */
- (void)closeReasoning;

@end
