//
//  UAModalDisplayPanelView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

/**
 *  @file
 *  开源项目UAModalPanel，介绍可以看下面的网址
 *  English:
 *  @see	https://github.com/UrbanApps/UAModalPanel
 *  中文：
 *  @see    http://www.oschina.net/p/uamodalpanel
 *  简单来说，UAModalPanel提供了一个内容丰富，功能强大的模式面板，用户可以自定义模式面板的形式和内容
 */

#import <Foundation/Foundation.h>
#import "UARoundedRectView.h"

// Logging Helpers
#ifdef UAMODALVIEW_DEBUG
#define UADebugLog( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define UADebugLog( s, ... ) 
#endif

@class UAModalPanel;

@protocol UAModalPanelDelegate
@optional
- (void)willShowModalPanel:(UAModalPanel *)modalPanel;
- (void)didShowModalPanel:(UAModalPanel *)modalPanel;
- (BOOL)shouldCloseModalPanel:(UAModalPanel *)modalPanel;
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel;
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel;
@end

typedef void (^UAModalDisplayPanelEvent)(UAModalPanel* panel);
typedef void (^UAModalDisplayPanelAnimationComplete)(BOOL finished);

@interface UAModalPanel : UIView {	
	NSObject<UAModalPanelDelegate>	*delegate;
	
	UIView		*contentContainer;
	UIView		*roundedRect;
	UIButton	*closeButton;
	UIView		*contentView;
	
	CGPoint		startEndPoint;
	
	CGFloat		x_outerMargin;
    CGFloat		y_outerMargin;
	CGFloat		innerMargin;
	UIColor		*borderColor;
	CGFloat		borderWidth;
	CGFloat		cornerRadius;
	UIColor		*contentColor;
	BOOL		shouldBounce;
    BOOL		isShowColseBtn;
	
}

@property (nonatomic, assign) NSObject<UAModalPanelDelegate>	*delegate;

@property (nonatomic, retain) UIView		*contentContainer;
@property (nonatomic, retain) UIView		*roundedRect;
@property (nonatomic, retain) UIButton		*closeButton;
@property (nonatomic, retain) UIView		*contentView;

// Margin between edge of container frame and panel. Default = 20.0
@property (nonatomic, assign) CGFloat		x_outerMargin;
// Margin between edge of container frame and panel. Default = 20.0
@property (nonatomic, assign) CGFloat		y_outerMargin;
// Margin between edge of panel and the content area. Default = 20.0
@property (nonatomic, assign) CGFloat		innerMargin;
// Border color of the panel. Default = [UIColor whiteColor]
@property (nonatomic, retain) UIColor		*borderColor;
// Border width of the panel. Default = 1.5f
@property (nonatomic, assign) CGFloat		borderWidth;
// Corner radius of the panel. Default = 4.0f
@property (nonatomic, assign) CGFloat		cornerRadius;
// Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
@property (nonatomic, retain) UIColor		*contentColor;
// Shows the bounce animation. Default = YES
@property (nonatomic, assign) BOOL			shouldBounce;
// Shows the colse btn. Default = YES
@property (nonatomic, assign) BOOL          isShowColseBtn;
@property (readwrite, copy)	UAModalDisplayPanelEvent onClosePressed;

- (void)show;
- (void)showFromPoint:(CGPoint)point;
- (void)hide;
- (void)hideWithOnComplete:(UAModalDisplayPanelAnimationComplete)onComplete;

- (CGRect)roundedRectFrame;
- (CGRect)closeButtonFrame;
- (CGRect)contentViewFrame;

@end
