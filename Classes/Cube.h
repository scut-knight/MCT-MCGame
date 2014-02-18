//
//  TestCube.h
//  MCGame
//
//  Created by kwan terry on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MCMobileObject.h"
#import "MCRay.h"
#import "CubeFace.h"
#import "Global.h"

@class MCParticleSystem;
@class MCCollider;

/**
 *	场景对象之立方体
 */
@interface Cube :MCMobileObject{
    MCParticleSystem * particleEmitter;
    NSMutableArray *cube6faces;
    NSMutableArray *cube6faces_locksign;
    NSMutableArray *cube6faces_direction_indicator;
    //CubeFace *faces[6];
    int index;
    /**
     *	是否需要锁住，不让转动
     */
    BOOL _isLocked;
    int index_selectedFace;
    /**
     *	是否需要显示指示箭头
     */
    BOOL _isNeededToShowSpaceDirection;
    /**
     *	指示轴方向
     */
    AxisType indicator_axis;
    /**
     *	旋转方向，也是指示箭头的朝向
     */
    LayerRotationDirectionType indicator_direction;
}

@property (assign) int index;
@property (assign) int index_selectedFace;
@property (assign) BOOL isLocked;
@property (assign) BOOL isNeededToShowSpaceDirection;
@property (assign) AxisType indicator_axis;
@property (assign) LayerRotationDirectionType indicator_direction;
@property (nonatomic,retain)NSMutableArray *cube6faces;
@property (nonatomic,retain)NSMutableArray *cube6faces_locksign;
@property (nonatomic,retain)NSMutableArray *cube6faces_direction_indicator;

-(id)init;
- (id) initWithState:(NSDictionary*)states;
- (void) flashWithState:(NSDictionary*)states;
- (void) dealloc;
- (void)awake;
- (void)update;
-(void)render;
//魔方输入时


@end
