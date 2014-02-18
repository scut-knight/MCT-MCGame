//
//  CompositeRotationUtil.h
//  MCGame
//
//  Created by Aha on 13-5-13.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"
/**
 *	结合两个动作标记来构成复合旋转
 *  这个类不产生实例，仅仅作为一组相关函数的集合
 */
@interface MCCompositeRotationUtil : NSObject

//all situations but not Bw+Bw=Bw2...
+ (BOOL)isSingmasterNotation:(SingmasterNotation)first andSingmasterNotation:(SingmasterNotation)second equalTo:(SingmasterNotation)target;

//all situations but not Bw+Bw=Bw2...
+ (BOOL)isSingmasterNotation:(SingmasterNotation)part PossiblePartOfSingmasterNotation:(SingmasterNotation)target;

@end
