//
//  MCInferenceEngine.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCInferenceEngine.h"

@implementation MCInferenceEngine


@synthesize workingMemory = _workingMemory;
@synthesize patterns;
@synthesize rules;
@synthesize specialPatterns;
@synthesize specialRules;
@synthesize states;
@synthesize actionPerformer;


+ (MCInferenceEngine *)inferenceEngineWithWorkingMemory:(MCWorkingMemory *)wm{
    return [[[MCInferenceEngine alloc] iniInferenceEngineWithWorkingMemory:wm] autorelease];
}

/**
 * initialize and refresh state and rules
 */
- (id)iniInferenceEngineWithWorkingMemory:(MCWorkingMemory *)wm{
    if (self = [super init]) {
        // Set the working memory
        self.workingMemory = wm;
        
        // Create the action performer to perform action to working memory
        // This actions boundary contaions locker, magic cube, etc.
        self.actionPerformer = [MCActionPerformer actionPerformerWithWorkingMemory:self.workingMemory];
        
        // Load the state list.
        self.states = [NSDictionary dictionaryWithDictionary:[[MCKnowledgeBase getSharedKnowledgeBase] getStatesOfMethod:ETFF]];// ETFF规则
    }
    return self;
}


- (void)dealloc{
    // release all
    [_workingMemory release];
    [patterns release];
    [rules release];
    [specialPatterns release];
    [specialRules release];
    [states release];
    [actionPerformer release];
    
    [super dealloc];
}


- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity{
    return [self.workingMemory.magicCube isCubieAtHomeWithIdentity:identity];
}


- (void)reloadRulesAccordingToCurrentStateOfRubiksCube{
    // Every time apply rule, construct a pool for auto releasing.
    NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
    
    self.patterns = [NSDictionary dictionaryWithDictionary:
                     [[MCKnowledgeBase getSharedKnowledgeBase] getPatternsWithPreState:_workingMemory.magicCubeState
                                                                               inTable:DB_PATTERN_TABLE_NAME]];
    self.rules = [NSDictionary dictionaryWithDictionary:
                  [[MCKnowledgeBase getSharedKnowledgeBase] getRulesOfMethod:ETFF
                                                                   withState:_workingMemory.magicCubeState
                                                                     inTable:DB_RULE_TABLE_NAME]];
    self.specialPatterns = [NSDictionary dictionaryWithDictionary:
                            [[MCKnowledgeBase getSharedKnowledgeBase] getPatternsWithPreState:_workingMemory.magicCubeState
                                                                                      inTable:DB_SPECIAL_PATTERN_TABLE_NAME]];
    self.specialRules = [NSDictionary dictionaryWithDictionary:
                         [[MCKnowledgeBase getSharedKnowledgeBase] getRulesOfMethod:ETFF
                                                                          withState:_workingMemory.magicCubeState
                                                                            inTable:DB_SPECIAL_RULE_TABLE_NAME]];
    [loopPool release];
}

/**
 * Apply the pattern and return result,
 * 根据对应的模式调用treeNodesApply:
 *
 * @param type AppliedRuleType枚举类型定义于Global.h，有两种，分别是General和Special，对应两种模式
 */
- (BOOL)applyPatternWihtPatternName:(NSString *)name ofType:(AppliedRuleType)type{
    
    // Get the pattern named 'name'
    MCPattern *pattern = nil;
    switch (type) {
        case Special:
            pattern = [self.specialPatterns objectForKey:name];
            break;
        case General:
            pattern = [self.patterns objectForKey:name];
            break;
        default:
            break;
    }
    
    // apply
    if (pattern != nil) {
        return [self treeNodesApply:pattern.root withDeep:0];
    }
    else{
        NSLog(@"Can't find the pattern, the pattern name is wrong");
        return NO;
    }
}

/**
 *	根据所给的root节点类型进行解析。
 *
 *  处理所有的节点类型
 *
 *  如果是ExpNode，调用以下三个子函数继续解析：
 *
 *  1.(BOOL)andNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep
 *
 *  2.(BOOL)orNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep
 *
 *  3.(BOOL)notNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep
 *
 *  这三个子函数类似于treeNodesApply，当然具体细节上有些不同
 *
 *	@param	root	需要解析的树的根节点
 *	@param	deep	传递为子函数的withDeep参数
 *
 *	@return	(NSInteger)NO if error occurs; Yes if successed
 *
 * @see MCActionPerformer#treeNodesApply:
 * @see MCExplanationSystem#treeNodesApply:
 *
 * 注意与MCExplanationSystem#treeNodesApply:的区别
 */
- (NSInteger)treeNodesApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    // current MCMagicCube
    NSObject<MCMagicCubeDataSouceDelegate> *mcDataSource = self.workingMemory.magicCube;
    
    switch (root.type) {
        case ExpNode:
        {
            switch (root.value) {
                case And:
                {
                    root.result = [self andNodeApply:root withDeep:deep];
                    return root.result;
                }
                case Or:
                {
                    root.result = [self orNodeApply:root withDeep:deep];
                    return root.result;
                }
                case Not:
                {
                    root.result = [self notNodeApply:root withDeep:deep];
                    return root.result;
                }
                default:
                    break;
            }
        }
            break;
            
        case PatternNode:
        {
            
            switch (root.value) {
                case Home:
                {
                    ColorCombinationType value;
                    for (MCTreeNode *child in root.children) {
                        value = (ColorCombinationType)[self treeNodesApply:child withDeep:deep+1];
                        if (![self isCubieAtHomeWithIdentity:value]) {
                            root.result = NO;
                            return root.result;
                        }
                    }
                }
                    break;
                    
                case Check:
                {
                    ColorCombinationType targetCubie = ColorCombinationTypeBound;
                    for (MCTreeNode *subPattern in root.children) {
                        
                        switch (subPattern.value) {
                            case At:
                            {
                                targetCubie = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:0] withDeep:deep+1];
                                ColorCombinationType targetPosition = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:1] withDeep:deep+1];
                                struct Point3i coorValue = [mcDataSource coordinateValueOfCubieWithColorCombination:(ColorCombinationType)targetCubie];
                                // if the position of targetCube is not the targetPosition
                                if (coorValue.x + coorValue.y*3 + coorValue.z * 9 + 13 != targetPosition) {
                                    root.result = NO;
                                    return root.result;
                                }
                            }
                                break;
                            case ColorBindOrientation:
                            {
                                NSObject<MCCubieDelegate> *cubie = nil;
                                // cubie will be the special cube in appropriate place
                                FaceOrientationType targetOrientation = (FaceOrientationType)[self treeNodesApply:[subPattern.children objectAtIndex:0] withDeep:deep+1];
                                FaceColorType targetColor = (FaceColorType)[self treeNodesApply:[subPattern.children objectAtIndex:1] withDeep:deep+1];
                                if ([subPattern.children count] > 2) {
                                    NSInteger position = [(MCTreeNode *)[subPattern.children objectAtIndex:2] value];
                                    cubie = [mcDataSource cubieAtCoordinateX:(position%3-1) Y:(position%9/3-1) Z:(position/9-1)];
                                } else {
                                    cubie = [mcDataSource cubieWithColorCombination:(ColorCombinationType)targetCubie];
                                }
                                root.result = [cubie isFaceColor:targetColor inOrientation:targetOrientation];
                                return root.result;
                            }
                            case NotAt:
                            {
                                targetCubie = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:0] withDeep:deep+1];
                                ColorCombinationType targetPosition = (ColorCombinationType)[self treeNodesApply:[subPattern.children objectAtIndex:1] withDeep:deep+1];
                                struct Point3i coorValue = [mcDataSource coordinateValueOfCubieWithColorCombination:(ColorCombinationType)targetCubie];
                                // if the position of targetCube is the targetPosition
                                if (coorValue.x + coorValue.y*3 + coorValue.z * 9 + 13 == targetPosition) {
                                    root.result = NO;
                                    return root.result;
                                }
                            }
                                break;
                            default:
                            {
                                root.result = NO;
                                return root.result;
                            }
                        }
                    }
                }
                    break;
                    
                case CubiedBeLocked:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    
                    if ([self.workingMemory lockerEmptyAtIndex:index]) {
                        root.result = NO;
                        return root.result;
                    }
                }
                    break;
                default:
                {
                    root.result = NO;
                    return root.result;
                }
            }
        }
            break;
            
        case InformationNode:
            
            switch (root.value) {
                case getCombinationFromOrientation:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        
                        switch ([mcDataSource centerMagicCubeFaceInOrientation:(FaceOrientationType)child.value]) {
                            case Up:
                                y = 2;
                                break;
                            case Down:
                                y = 0;
                                break;
                            case Left:
                                x = 0;
                                break;
                            case Right:
                                x = 2;
                                break;
                            case Front:
                                z = 2;
                                break;
                            case Back:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getCombinationFromColor:
                {
                    int x=1, y=1, z=1;
                    for (MCTreeNode *child in root.children) {
                        
                        switch ((FaceColorType)[self treeNodesApply:child withDeep:deep+1]) {
                            case UpColor:
                                y = 2;
                                break;
                            case DownColor:
                                y = 0;
                                break;
                            case LeftColor:
                                x = 0;
                                break;
                            case RightColor:
                                x = 2;
                                break;
                            case FrontColor:
                                z = 2;
                                break;
                            case BackColor:
                                z = 0;
                                break;
                            default:
                                break;
                        }
                    }
                    
                    //Store the result at the node
                    root.result = x+y*3+z*9;
                    return root.result;
                }
                case getFaceColorFromOrientation:
                {
                    FaceColorType color;
                    FaceOrientationType orientation = (FaceOrientationType)[(MCTreeNode *)[root.children objectAtIndex:0] value];
                    if ([root.children count] == 1) {
                        
                        switch ([mcDataSource centerMagicCubeFaceInOrientation:orientation]) {
                            case Up:
                                color = UpColor;
                                break;
                            case Down:
                                color = DownColor;
                                break;
                            case Left:
                                color = LeftColor;
                                break;
                            case Right:
                                color = RightColor;
                                break;
                            case Front:
                                color = FrontColor;
                                break;
                            case Back:
                                color = BackColor;
                                break;
                            default:
                                color = NoColor;
                                break;
                        }
                    }
                    else{
                        int value = [(MCTreeNode *)[root.children objectAtIndex:1] value];
                        struct Point3i coordinate = {value%3-1, value%9/3-1, value/9-1};
                        color = [[mcDataSource cubieAtCoordinatePoint3i:coordinate] faceColorInOrientation:orientation];
                    }
                    
                    //Store the result at the node
                    root.result = color;
                    return root.result;
                }
                case lockedCubie:
                {
                    int index = 0;
                    if ([root.children count] != 0) {
                        index = [(MCTreeNode *)[root.children objectAtIndex:0] value];
                    }
                    
                    if ([self.workingMemory lockerEmptyAtIndex:index]) {
                        root.result = -1;
                    }
                    else{
                        root.result = [[self.workingMemory cubieLockedInLockerAtIndex:index] identity];
                    }
                    
                    return root.result;
                }
                default:
                    break;
            }
            break;
            
        case ElementNode:
            return root.value;
        default:
        {
            root.result = NO;
            return root.result;
        }
    }
    
    root.result = YES;
    return root.result;
}

/**
 * @see MCInferenceEngine#treeNodesApply:
 */
- (BOOL)andNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        //Being a 'and' node,
        //it will be failed whever one of its child is failed.
        if (![self treeNodesApply:node withDeep: deep+1]) {
            root.result = NO;
            return root.result;
        }
    }
    root.result = YES;
    return root.result;
}

/**
 * @see MCInferenceEngine#treeNodesApply:
 */
- (BOOL)orNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        if ([self treeNodesApply:node withDeep:deep+1]) {
            root.result = YES;
            return root.result;
        }
    }
    root.result = NO;
    return root.result;
}

/**
 * @see MCInferenceEngine#treeNodesApply:
 */
- (BOOL)notNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    root.result = ![self treeNodesApply:[root.children objectAtIndex:0] withDeep:deep+1];
    return root.result;
}


- (NSString *)checkStateFromInit:(BOOL)isCheckStateFromInit;{
    NSString *goStr;
    //to check from init or not(是否需要初始化)
    if (isCheckStateFromInit) {
        goStr = START_STATE;
        [self.workingMemory unlockAllCubies];
    }
    else{
        goStr = _workingMemory.magicCubeState;
    }
    //check state
    MCState *tmpState = [states objectForKey:goStr];
    for (; tmpState != nil && [self treeNodesApply:[tmpState root] withDeep:0]; tmpState = [states objectForKey:goStr]) {
        // 更新goStr
        goStr = tmpState.afterState;
    }
    // if goStr != magicCubeState
    if ([goStr compare:_workingMemory.magicCubeState] != NSOrderedSame) {
        _workingMemory.magicCubeState = goStr;
        [self.workingMemory unlockCubieAtIndex:0];
        [self.workingMemory unlockCubiesInRange:NSMakeRange(4, CubieCouldBeLockMaxNum-4)];
        [self reloadRulesAccordingToCurrentStateOfRubiksCube];
    }
    
    return _workingMemory.magicCubeState;
}


- (void)prepareReasoning{
    // To begin with, check the state from 'Init' state
    // and load the rules.
    [self checkStateFromInit:YES];
}


- (MCRule *)reasoning{
    [self checkStateFromInit:NO];
    
    NSLog(@"State:%@", _workingMemory.magicCubeState);
    
    // Check special rules firstly.
    for (NSString *key in [self.specialRules allKeys])
    {
        if ([self applyPatternWihtPatternName:key ofType:Special]) {
            //--------------------------
            NSLog(@"Rules:%@", key);
            self.workingMemory.agendaPattern = [self.specialPatterns objectForKey:key];
            return [self.specialRules objectForKey:key];
        }
    }
    
    // If no special rules match the state, check general rules.
    for (NSString *key in [self.rules allKeys])
    {
        if ([self applyPatternWihtPatternName:key ofType:General]) {
            //--------------------------
            NSLog(@"Rules:%@", key);
            self.workingMemory.agendaPattern = [self.patterns objectForKey:key];
            return [self.rules objectForKey:key];
        }
    }
    return nil;
}


- (void)closeReasoning{
    [_workingMemory clearExceptMagicCubeData];
}

@end
