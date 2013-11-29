//
//  MCMagicCubeProtocol.h
//  MCGame
//
//  Created by Aha on 13-5-16.
//
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MCCubieDelegate.h"
#import "MCMagicCubeDataSouceDelegate.h"
#import "MCMagicCubeOperationDelegate.h"
/**
 *	魔方应该遵守的协议（combine MCMagicCubeDataSourceDelegate with MCMagicCubeOperationDelegate）
 */
@protocol MCMagicCubeDelegate <MCMagicCubeDataSouceDelegate, MCMagicCubeOperationDelegate>

@end
