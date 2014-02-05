//
//  QuadCurveMenuItem.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 lunaapp.com. All rights reserved.
//

#import "QuadCurveMenuItem.h"
static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}
@implementation QuadCurveMenuItem

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize nearPoint = _nearPoint;
@synthesize farPoint = _farPoint;
@synthesize delegate  = _delegate;
@synthesize faceColor = _faceColor;

#pragma mark - initialization & cleaning up

/**
 *	以图像进行初始化
 *
 *	@param	img	初始化时的图像
 *	@param	himg	高亮时的图像
 *	@param	color	画面颜色
 *	@param	frame	图像区域
 */
- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       presentColor:(FaceColorType)color
          withFrame:(CGRect)frame;
{
    if (self = [self initWithFrame:frame])
    {
        _faceColor = color;
        [self setBackgroundImage:img forState:UIControlStateNormal];
        [self setBackgroundImage:himg forState:UIControlStateHighlighted];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - UIView's methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesBegan:)])
    {
       [_delegate quadCurveMenuItemTouchesBegan:self];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // if move out of 2x rect, cancel highlighted.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
    {
        self.highlighted = NO;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highlighted = NO;
    // if stop in the area of 2x rect, response to the touches event.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
    {
        if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesEnd:)])
        {
            [_delegate quadCurveMenuItemTouchesEnd:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highlighted = NO;
}


#pragma mark - instant methods
/**
 *	设置高亮显示，比如在被触碰时会有明显的高亮显示
 *
 *	@param	highlighted	是否高亮
 */
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}


@end
