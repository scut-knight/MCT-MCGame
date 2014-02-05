//
//  QuadCurveMenu.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import "QuadCurveMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

/**
 *	实现旋转动画的辅助函数
 *
 *	@param	point	旋转前的点
 *	@param	center	选择器的中点
 *	@param	angle	旋转角度
 *
 *	@return	旋转结束后的对应点
 */
static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle)
{
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);    
}

@interface QuadCurveMenu ()
- (void)_expand;
- (void)_close;
- (void)_setMenu;
- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p;
- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p;
@end

@implementation QuadCurveMenu

@synthesize nearRadius, endRadius, farRadius, timeOffset, rotateAngle, menuWholeAngle, startPoint;
@synthesize expanding = _expanding;
@synthesize delegate = _delegate;
@synthesize menusArray = _menusArray;
@synthesize closeTimer = _closeTimer;
@synthesize animationProtectionTimer = _animationProtectionTimer;
@synthesize isProtection = _isProtection;

#pragma mark - initialization & cleaning up
- (id)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		
		self.nearRadius = K_QUADCURVE_MENU_DEFAULT_NEAR_RADIUS;
		self.endRadius = K_QUADCURVE_MENU_DEFAULT_END_RADIUS;
		self.farRadius = K_QUADCURVE_MENU_DEFAULT_FAR_RADIUS;
		self.timeOffset = K_QUADCURVE_MENU_DEFAULT_TIME_OFFSET;
		self.rotateAngle = K_QUADCURVE_MENU_DEFAULT_ROTATE_ANGLE;
		self.menuWholeAngle = K_QUADCURVE_MENU_DEFAULT_WHOLE_ANGLE;
		self.startPoint = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        self.center = self.startPoint;
        
        // layout menus
        self.menusArray = aMenusArray;
        
        
        // init flag
        _isProtection = NO;
    }
    return self;
}

- (void)dealloc{
    [_menusArray release];
    [_timer release];
    [_closeTimer release];
    [_animationProtectionTimer release];
    [super dealloc];
}

#pragma mark - QuadCurveMenuItem delegates
- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item{
    return;
}

/**
 *	当一个颜色选择器的菜单项被选中之后，该选项爆开，而其他选项缩小而消失。
 *
 *	@param	item	被选中的菜单项
 */
- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item{
    
    if (!_isProtection) {
        // blowup the selected menu button
        CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center];
        [item.layer addAnimation:blowup forKey:@"blowup"];
        
        // If animation ends, remove views
        self.closeTimer = [NSTimer timerWithTimeInterval:(K_QUADCURVE_MENU_DEFAULT_SELECT_ANIM_LAST_TIME - 0.05)
                                                  target:self
                                                selector:@selector(didClosed)
                                                userInfo:nil
                                                 repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_closeTimer forMode:NSRunLoopCommonModes];
        
        // Animation protection time
        _isProtection = YES;
        
        self.animationProtectionTimer = [NSTimer timerWithTimeInterval:K_QUADCURVE_MENU_DEFAULT_SELECT_ANIM_LAST_TIME
                                                                target:self
                                                              selector:@selector(stopProtection)
                                                              userInfo:nil
                                                               repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_animationProtectionTimer forMode:NSRunLoopCommonModes];
        
        
        // shrink other menu buttons
        for (int i = 0; i < [_menusArray count]; i ++)
        {
            QuadCurveMenuItem *otherItem = [_menusArray objectAtIndex:i];
            CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
            [otherItem setEnabled:NO];
            if (otherItem.tag == item.tag) {
                continue;
            }
            [otherItem.layer addAnimation:shrink forKey:@"shrink"];
            
        }
        
        if ([_delegate respondsToSelector:@selector(quadCurveMenu:didSelectColor:)])
        {
            [_delegate quadCurveMenu:self didSelectColor:item.faceColor];
        } 
    }
    
}

#pragma mark - instant methods

- (void)_setMenu {
	int count = [_menusArray count];
    for (int i = 0; i < count; i ++)
    {
        QuadCurveMenuItem *item = [_menusArray objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = startPoint;
        CGPoint endPoint = CGPointMake(startPoint.x + endRadius * sinf(i * menuWholeAngle / count), startPoint.y - endRadius * cosf(i * menuWholeAngle / count));
        item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, rotateAngle);
        CGPoint nearPoint = CGPointMake(startPoint.x + nearRadius * sinf(i * menuWholeAngle / count), startPoint.y - nearRadius * cosf(i * menuWholeAngle / count));
        item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, rotateAngle);
        CGPoint farPoint = CGPointMake(startPoint.x + farRadius * sinf(i * menuWholeAngle / count), startPoint.y - farRadius * cosf(i * menuWholeAngle / count));
        item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, rotateAngle);
        item.center = item.startPoint;
        item.delegate = self;
        [item setEnabled:YES];
		[self addSubview:item];
    }
}


- (void)setExpanding:(BOOL)expanding{
	
	if (!_isProtection && !_timer) {
        if (expanding) {
            [self _setMenu];
        }
        
        
        // expand or close animation
        _flag = expanding ? 0 : ([_menusArray count] - 1);
        SEL selector = expanding ? @selector(_expand) : @selector(_close);
        
        // Adding timer to runloop to make sure UI event won't block the timer from firing
        _timer = [[NSTimer timerWithTimeInterval:timeOffset target:self selector:selector userInfo:nil repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        _isProtection = YES;
        
        
        
        if (!expanding) {
            // Animation protection time
            self.animationProtectionTimer = [NSTimer timerWithTimeInterval:(K_QUADCURVE_MENU_DEFAULT_CLOSE_ANIM_LAST_TIME + timeOffset * [_menusArray count])
                                                                    target:self
                                                                  selector:@selector(stopProtection)
                                                                  userInfo:nil
                                                                   repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_animationProtectionTimer forMode:NSRunLoopCommonModes];
            
            self.closeTimer = [NSTimer timerWithTimeInterval:(K_QUADCURVE_MENU_DEFAULT_CLOSE_ANIM_LAST_TIME + timeOffset * ([_menusArray count] - 1))
                                                      target:self
                                                    selector:@selector(didClosed)
                                                    userInfo:nil
                                                     repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_closeTimer forMode:NSRunLoopCommonModes];
        }
        else{
            // Animation protection time
            self.animationProtectionTimer = [NSTimer timerWithTimeInterval:(K_QUADCURVE_MENU_DEFAULT_OPEN_ANIM_LAST_TIME + timeOffset * [_menusArray count])
                                                                    target:self
                                                                  selector:@selector(stopProtection)
                                                                  userInfo:nil
                                                                   repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_animationProtectionTimer forMode:NSRunLoopCommonModes];
            _expanding = YES;
        }
    }
}

#pragma mark - private methods
- (void)_expand{
	
    if (_flag == [_menusArray count])
    {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
    QuadCurveMenuItem *item = (QuadCurveMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = K_QUADCURVE_MENU_DEFAULT_OPEN_ANIM_LAST_TIME;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.1],
                                [NSNumber numberWithFloat:.2], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = K_QUADCURVE_MENU_DEFAULT_OPEN_ANIM_LAST_TIME;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = K_QUADCURVE_MENU_DEFAULT_OPEN_ANIM_LAST_TIME;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    animationgroup.removedOnCompletion = YES;
    
    item.center = item.endPoint;
    
    _flag ++;
    
}

- (void)_close{
    if (_flag == -1)
    {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
     QuadCurveMenuItem *item = (QuadCurveMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = K_QUADCURVE_MENU_DEFAULT_CLOSE_ANIM_LAST_TIME;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0], 
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil]; 
        
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = K_QUADCURVE_MENU_DEFAULT_CLOSE_ANIM_LAST_TIME;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = K_QUADCURVE_MENU_DEFAULT_CLOSE_ANIM_LAST_TIME;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    animationgroup.removedOnCompletion = YES;
    _flag --;
}

- (void)stopProtection{
    _isProtection = NO;
}

- (void)didClosed{
    [self removeFromSuperview];
    _expanding = NO;
}

- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = K_QUADCURVE_MENU_DEFAULT_SELECT_ANIM_LAST_TIME;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.removedOnCompletion = YES;
    
    return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = K_QUADCURVE_MENU_DEFAULT_SELECT_ANIM_LAST_TIME;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.removedOnCompletion = YES;
    
    return animationgroup;
}

- (void)setCenter:(CGPoint)center{
    if (!_isProtection) {
        [super setCenter:center];
    }
}


- (void)setMenusArray:(NSArray *)menusArray{
    if (_menusArray == menusArray) {
        return;
    }
    
    [_menusArray release];
    
    _menusArray = [menusArray copy];
    
    // remove all subviews
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
}


@end
