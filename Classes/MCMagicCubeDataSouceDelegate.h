//
//  MCMagicCubeDataSouceDelegate.h
//  MagicCubeModel
//
//  Created by Aha on 13-6-2.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCubieDelegate.h"
/**
 *	魔方所需的数据获取
 */
@protocol MCMagicCubeDataSouceDelegate <NSObject>

/// get coordinate of cube having the colors combination
- (struct Point3i)coordinateValueOfCubieWithColorCombination:(ColorCombinationType)combination;

/// get the cubie having the colors combination
- (NSObject<MCCubieDelegate> *)cubieWithColorCombination:(ColorCombinationType)combination;

/// get the cube in the specified position
- (NSObject<MCCubieDelegate> *)cubieAtCoordinateX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z;

/// get the cube in the specified position
- (NSObject<MCCubieDelegate> *)cubieAtCoordinatePoint3i:(struct Point3i)point;

/**
 *	返回中央立方块的朝向
 *
 *	@param	orientation	当前朝向
 *
 *	@return	原来的朝向
 */
- (FaceOrientationType)centerMagicCubeFaceInOrientation:(FaceOrientationType)orientation;

/**
 * Using color mapping dictionary,
 * you can get the real color corresponding to face color type.
 */
- (NSString *)getRealColor:(FaceColorType)color;


- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity;


- (BOOL)isFinished;

@end
