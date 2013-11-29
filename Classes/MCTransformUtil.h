//
//  MCTransformUtil.h
//  MagicCubeModel
//
//  Created by Aha on 13-3-12.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCBasicElement.h"
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCWorkingMemory.h"
/**
 *	协助魔方转向的类，比如生成转换动作，描述目前状态
 *  其中大量提及了SingmasterNotation等在Global.h定义的枚举类
 *  这个类不产生实例，仅仅作为一组相关函数的集合
 *  @see Global.h
 */
@interface MCTransformUtil : NSObject

+ (FaceOrientationType)getContraryOrientation:(FaceOrientationType)orientation;

+ (NSString *)getRotationTagFromSingmasterNotation:(SingmasterNotation)notation;

+ (SingmasterNotation)getSingmasterNotationFromAxis:(AxisType)axis layer:(int)layer direction:(LayerRotationDirectionType)direction;


+ (SingmasterNotation)getContrarySingmasterNotation:(SingmasterNotation)notation;


+ (SingmasterNotation)getPathToMakeCenterCubieAtPosition:(struct Point3i)coordinate inOrientation:(FaceOrientationType)orientation;


// Transfer SingmasterNotation to RotateNotationType containing axis, layer, direction and RotationType(Single, Double or Trible)
+ (struct RotateNotationType)getRotateNotationTypeWithSingmasterNotation:(SingmasterNotation)notation;


// By delivering pattern node to this function,
// we can get the node content.
// Notice! The type of this node must be 'PatternNode'.
+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node
              accordingToWorkingMemory:(MCWorkingMemory *)workingMemory;

//Return the negative sentence of the string returned by
//"+ (NSString *)getContenFromPatternNode:(MCTreeNode *)node"
+ (NSString *)getNegativeSentenceOfContentFromPatternNode:(MCTreeNode *)node
                                 accordingToWorkingMemory:(MCWorkingMemory *)workingMemory;

//Expand the tree node at three occasions:
//@1     not                    or
//        |                    /  \
//       and        ->       not   not
//      /   \                 |     |
//  child  child            child  child
//-----------------------------------------
//@2     not                    and
//        |                    /  \
//       or        ->        not   not
//      /   \                 |     |
//  child  child            child  child
//-----------------------------------------
//@3 not-not-child  ->  child
+ (void)convertToTreeByExpandingNotSentence:(MCTreeNode *)node;


// E.g BColor transfer to XXX(where)XXX colors cubie
+ (NSString *)getConcreteDescriptionOfCubie:(ColorCombinationType)identity fromMgaicCube:(NSObject<MCMagicCubeDataSouceDelegate> *)mc;

// E.g (0, 0, 1) transfers to front center
+ (NSString *)getPositionDescription:(Point3i)position;

// E.g UpColor - @"U"
+ (NSString *)getStringTagOfFaceColor:(FaceColorType)faceColor;

// Only transfer U, D, F, B, L and R(can be appended ' or 2)
+ (SingmasterNotation)singmasternotationFromStringTag:(NSString *)tag;

@end
