//
//  MCTexturedButton.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCButton.h"
#import "MCParticleSystem.h"
/**
 *	纹理按钮。
 *  继承自MCButton，在MCButton上添加了纹理。
 */
@interface MCTexturedButton : MCButton {
	MCTexturedQuad * upQuad;
	MCTexturedQuad * downQuad;
    BOOL isNeedToAddParticle;
    MCParticleSystem *particleEmitter;
}
@property (nonatomic,assign) BOOL isNeedToAddParticle;

- (id) initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey;
- (void) dealloc;
- (void)awake;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;
- (void)update;

// 6 methods


@end

