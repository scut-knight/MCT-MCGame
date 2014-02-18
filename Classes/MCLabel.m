//
//  MCLabel.m
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//

#import "MCLabel.h"

@implementation MCLabel
/**
 *	加载与名字对应的纹理标签
 *
 *	@param	string	纹理名字
 *
 */
-(id)initWithNstring:(NSString*)string{
    self =[super init];
    if(self!=nil){
        labelQuad = [[MCMaterialController sharedMaterialController] quadFromAtlasKey:string];
        [labelQuad retain];
    }
    return self;
}

-(void)awake{
    self.mesh = labelQuad;
}

- (void)update{
    [super update];
}

- (void)dealloc{
    [labelQuad release];
	[super dealloc];
};
@end
