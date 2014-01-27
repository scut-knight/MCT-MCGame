//
//  MCStepCounter.h
//  MCGame
//
//  Created by kwan terry on 13-2-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MCSceneObject.h"
/**
 *	虽然名字叫做计步器，但是该类现在并不负责计步的操作。
 *  该类作为MCMultiDigitCounter的一部分，负责计步器图层的渲染。
 */
@interface MCStepCounter : MCSceneObject{
    MCTexturedQuad *m_numberQuad[10];
}

- (void)setNumberQuad:(NSInteger)index;
//inside function;
- (id) initWithUpKeyS:(NSString*[])Keys;
- (void)awake;
- (void)update;
- (void)reset;
- (void)setNumberQuad:(NSInteger)index;
- (void)dealloc;


@end
