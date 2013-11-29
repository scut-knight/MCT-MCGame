//
//  MCCubieColorConstraintUtil.h
//  MCGame
//
//  Created by Aha on 13-6-9.
//
//

#import <Foundation/Foundation.h>
#import "MCCubieDelegate.h"
/**
 *	立方体外表颜色处理
 *  这个类不产生实例，仅仅作为一组相关函数的集合
 */
@interface MCCubieColorConstraintUtil : NSObject

+ (NSMutableArray *)avaiableColorsOfCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation;


+ (void)fillRightFaceColorAtCubie:(NSObject<MCCubieDelegate> *)cubie inOrientation:(FaceOrientationType)orientation;

+ (NSArray *)getFaceOrientationsInColokWiseOrderAtCornerPosition:(struct Point3i)point;

@end
