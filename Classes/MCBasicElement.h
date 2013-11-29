//
//  MCBasicElement.h
//  MagicCubeModel
//
//  Created by Aha on 12-12-29.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

/**
 *	@class MCTreeNode
 *  普通的树结点
 *  其孩子节点储存在一个NSMuatableArray里(也就是说子节点的个数可以是不定的)
 *  具有NodeType类型的type属性。NodeType类型请见Gloabl.h
 *  还有一个NSInteger类型的value属性
 */
//the tree node
@interface MCTreeNode : NSObject

@property (retain, nonatomic)NSMutableArray *children;
@property (nonatomic)NodeType type;
@property (nonatomic)NSInteger value;
@property (nonatomic)NSInteger result;

-(id)initNodeWithType:(NodeType)type;

-(void)addChild:(MCTreeNode *)node;

@end

/**
 *	@class MCPattern
 *	解析一个pattern，描述了语法树，具有错误定义的功能
 *
 *  关于解析pattern请参照Global.h中领域特定语言部分
 *  此处定义的parseBTerm | BExp | BFactor 并无特定意义，类似于foo，bar，只是编程界的黑话
 *  建议使用更加清晰易懂的名字
 *  关于term、exp、factor这几个结拜兄弟的来源故事：
 *  @see http://stackoverflow.com/questions/8055605/identity-expression-factor-and-term
 */
//pattern
@interface MCPattern : NSObject

//This node tree is the content of the pattern.
//Every node will store the information indicating the relationship between children nodes,
//judging criteria to check the state of rubik's cube.
@property(retain, nonatomic)MCTreeNode *root;

@property(nonatomic)BOOL errorFlag;
@property(nonatomic)NSInteger errorPosition;


//init this
- (id)initWithString:(NSString *)patternStr;

@end

/**
 *  @class MCState
 *  带有下一个状态的MCPattern
 */
//state
@interface MCState : MCPattern

@property(retain, nonatomic)NSString *afterState;

- (id)initWithPatternStr:(NSString *)patternStr andAfterState:(NSString *)state;

@end

/**
 *  @class MCRule
 *  在处理tokens的部分类似于MCPattern，但是解析的部分不一样
 *  关于解析pattern请参照Global.h中领域特定语言部分
 *  @see MCPattern
 */
//rule
@interface MCRule : NSObject

@property(retain, nonatomic)MCTreeNode *root;
@property(nonatomic)BOOL errorFlag;
@property(nonatomic)NSInteger errorPosition;

- (id)initWithString:(NSString *)patternStr;

@end
