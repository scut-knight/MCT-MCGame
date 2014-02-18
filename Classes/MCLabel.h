//
//  MCLabel.h
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//

#import "MCSceneObject.h"
#import "MCTexturedQuad.h"
/**
 *	简单的MCSeneObject类，实现了一个带文字的按钮。
 *  应用在主场景的文字的显示中。
 */
@interface MCLabel : MCSceneObject{
    /**
     *	按钮纹理
     */
    MCTexturedQuad *labelQuad;

}
-(id)initWithNstring:(NSString*)string;

-(void)awake;
- (void)update;
-(void)dealloc;


@end
