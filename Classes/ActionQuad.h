//
//  ActionQuad.h
//  MCGame
//
//  Created by kwan terry on 13-3-26.
//
//

#import <Foundation/Foundation.h>
#import "MCSceneObject.h"
/**
 *	显示动作名的区域
 */
@interface ActionQuad : MCSceneObject{
    MCTexturedQuad *aQuad;
    NSString * name;
}
@property (nonatomic,retain)NSString * name;
-(id)initWithNstring:(NSString*)string;

-(void)awake;
- (void)update;
-(void)dealloc;
@end
