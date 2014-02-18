//
//  QuadCurveMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenuItem.h"

@protocol QuadCurveMenuDelegate;

/**
 *	曲面菜单，就是求解模式下的纹理选择器
 */
@interface QuadCurveMenu : UIView <QuadCurveMenuItemDelegate>
{
    
    int _flag;
    NSTimer *_timer;
    id<QuadCurveMenuDelegate> _delegate;

    
}

@property (nonatomic, copy) NSArray *menusArray;
@property (nonatomic) BOOL isProtection;
@property (nonatomic, retain) NSTimer *closeTimer;
@property (nonatomic, retain) NSTimer *animationProtectionTimer;
@property (nonatomic, getter = isExpanding) BOOL expanding;
@property (nonatomic, assign) id<QuadCurveMenuDelegate> delegate;

@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;

- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray;

- (void)setExpanding:(BOOL)expanding;


@end

/**
 *  @class
 *
 *	纹理选择器协议，根据菜单来选择颜色
 */
@protocol QuadCurveMenuDelegate <NSObject>
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectColor:(FaceColorType)color;
@end