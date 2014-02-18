//
//  MCExplanationSystem.m
//  MagicCubeModel
//
//  Created by Aha on 13-6-1.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import "MCExplanationSystem.h"

@implementation MCExplanationSystem

@synthesize accordanceMsgs;
@synthesize workingMemory;




/**
 *	使用MCWorkingMemory构造并返回一个MCExplanationSystem实例
 */
+ (MCExplanationSystem *)explanationSystemWithWorkingMemory:(MCWorkingMemory *)wm{
    return [[[MCExplanationSystem alloc] initExplanationSystemWithWorkingMemory:wm] autorelease];
}

/**
 *  MCExplanationSystem构造函数
 */
- (id)initExplanationSystemWithWorkingMemory:(MCWorkingMemory *)wm{
    if (self = [super init]) {
        self.workingMemory = wm;
        
        // Allocate accordance messages of the pattern of the applied rule
        self.accordanceMsgs = [NSMutableArray arrayWithCapacity:DEFAULT_PATTERN_ACCORDANCE_MESSAGE_NUM];
        
    }
    return self;
}


- (void)dealloc{    
    [accordanceMsgs release];
    [workingMemory release];
    [super dealloc];
}

/**
 *	调用一些子函数来翻译目标模式(wokingMemory.agendaPattern)
 *
 *	@return	accordanceMsgs的一个副本,或者是nil如果目标模式为nil
 */
- (NSArray *)translateAgendaPattern{
    //Before apply pattern, clear accrodance messages firstly.
    [self.accordanceMsgs removeAllObjects];
    
    // apply
    MCPattern *targetPattern = self.workingMemory.agendaPattern;
    if (targetPattern != nil) {
        [self treeNodesApply:targetPattern.root withDeep:0];
    }
    else{
        NSLog(@"Error! Explanation system receives nil pattern.");
        return nil;
    }
    
    
    return [NSArray arrayWithArray:self.accordanceMsgs];
}

/**
 *	根据所给的root节点类型进行解析。
 *  
 *  如果是PatternNode，那么直接调用MCTransformUtil getContenFromPatternNode:root
 accordingToWorkingMemory:self.workingMemory进行解析。
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
 * @see MCInferenceEngine#treeNodesApply:
 *
 * 这几个方法享有同样的命名，都是作用在语法树上的，只是层次不同
 */
- (NSInteger)treeNodesApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    switch (root.type) {
        case ExpNode:
        {
            switch (root.value) {
                case And:
                    return [self andNodeApply:root withDeep:deep];
                case Or:
                    return [self orNodeApply:root withDeep:deep];
                case Not:
                    return [self notNodeApply:root withDeep:deep];
                default:
                    break;
            }
        }
            break;
            
        case PatternNode:
        {
            switch (root.value) {
            //if root.result == YES && deep == 0, just break and return YES
                case Home:
                {
                    if (root.result == YES && deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                    
                case Check:
                {
                    if (root.result == YES && deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                    
                case CubiedBeLocked:
                {
                    if (root.result == YES && deep == 0) {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:root
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                }
                    break;
                    // PatternNode
                default:
                    return NO;
            }
        }
            break;
            
        default:
            return NO;
    }
    return YES;
}

/**
 *	处理and表达式
 *  
 *  注意，即使子节点是相应的PatternNode，也必须符合对应的条件其节点信息才能加入到accordanceMsgs
 */
- (BOOL)andNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        
        //Being a 'and' node,
        //it will be failed whenever one of its child is failed.
        // 逻辑短路
        if (![self treeNodesApply:node withDeep: deep+1]) {
            return NO;
        }
        
        //While this node is true, we store some accordance messages
        //for several occasions.
        switch (node.type) {
            case ExpNode:
                if (node.value == Not) {
                    //Notice that the node is 'Not' node.
                    //You should get the negative sentence by invoking
                    //'getNegativeSentenceOfContentFromPatternNode'
                    NSString *msg = [MCTransformUtil getNegativeSentenceOfContentFromPatternNode:[node.children objectAtIndex:0]
                                                                        accordingToWorkingMemory:self.workingMemory];
                    if (msg != nil) {
                        [self.accordanceMsgs addObject:msg];
                    }
                }
                break;
                
            case PatternNode:
            {
                switch (node.value) {
                    case Home | Check:
                    {
                        NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                         accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                    }
                        break;
                    case CubiedBeLocked:
                    {
                        // 有唯一子节点，并且这个子节点的值为0
                        if ([node.children count] == 0 ||
                            [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                            NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                             accordingToWorkingMemory:self.workingMemory];
                            if (msg != nil) {
                                [self.accordanceMsgs addObject:msg];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }
    return YES;
}

/**
 *	处理or表达式
 *
 *  注意，即使子节点是相应的PatternNode，也必须符合对应的条件其节点信息才能加入到accordanceMsgs
 */

- (BOOL)orNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    for (MCTreeNode *node in root.children) {
        if ([self treeNodesApply:node withDeep:deep+1]) {
            // 即使第一个表达式返回YES，仍需检验下一个表达式
            
            //While this node is true, we store some accordance messages
            //for several occasions.
            switch (node.type) {
                case ExpNode:
                    if (node.value == Not) {
                        //Notice that the node is 'Not' node.
                        //You should get the negative sentence by invoking
                        //'getNegativeSentenceOfContentFromPatternNode'
                        //The result maybe nil.
                        NSString *msg = [MCTransformUtil getNegativeSentenceOfContentFromPatternNode:[node.children objectAtIndex:0]
                                                                            accordingToWorkingMemory:self.workingMemory];
                        if (msg != nil) {
                            [self.accordanceMsgs addObject:msg];
                        }
                        
                    }
                    break;
                    
                case PatternNode:
                {
                    switch (node.value) {
                        case Home | Check:
                        {
                            NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                             accordingToWorkingMemory:self.workingMemory];
                            if (msg != nil) {
                                [self.accordanceMsgs addObject:msg];
                            }
                        }
                            break;
                        case CubiedBeLocked:
                        {
                            if ([node.children count] == 0 ||
                                [(MCTreeNode *)[node.children objectAtIndex:0] value] == 0) {
                                NSString *msg = [MCTransformUtil getContenFromPatternNode:node
                                                                 accordingToWorkingMemory:self.workingMemory];
                                if (msg != nil) {
                                    [self.accordanceMsgs addObject:msg];
                                }
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            return YES;
        }
    }
    return NO;
}

/**
 *	解析Not节点。仅仅是将deep加一，再调用treeNodesApply并取函数返回结果的反
 *
 *	@param	root	目前的根节点
 *	@param	deep	目前深度
 *
 *	@return	解析的返回值
 */
- (BOOL)notNodeApply:(MCTreeNode *)root withDeep:(NSInteger)deep{
    return ![self treeNodesApply:[root.children objectAtIndex:0] withDeep:deep+1];
}

@end
