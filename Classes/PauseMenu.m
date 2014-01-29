//
//  PauseMenu.m
//  MCGame
//
//  Created by kwan terry on 13-3-4.
//
//

#import "PauseMenu.h"

/**
 *	竞速模式下的暂停对话框 顶部的黑色框坐标
 */
#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@interface PauseMenu ()

@end

@implementation PauseMenu
@synthesize viewLoadedFromXib;
@synthesize pauseSelectType;

/**
 *	初始化对话框视图
 *
 *	@param	frame	对话框大小边界
 *	@param	title	对话框标题
 *
 *	@return	暂停对话框
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		
        self.x_outerMargin = 344;
        self.y_outerMargin = 175;
        self.isShowColseBtn = YES;
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin =  10.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 8.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 16;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = YES;
        
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:40.0f];
       
        pauseSelectType = kPauseSelect_default;
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:UAGradientBackgroundStyleLinear];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: UAGradientLineModeBottom];
        
        // The noise layer opacity. Default = 0.4
        [[self titleBar] setNoiseOpacity:0.8];
        
        // The header label, a UILabel with the same frame as the titleBar
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
        [[NSBundle mainBundle] loadNibNamed:@"mypausemenu" owner:self options:nil];
        [self.contentView addSubview:viewLoadedFromXib];
    }
    
    
   

    
	return self;
}

- (void)dealloc {
	[viewLoadedFromXib release];
    [super dealloc];
}

/**
 *	加载子视图
 */
- (void)layoutSubviews {
	[super layoutSubviews];
	
	[viewLoadedFromXib setFrame:self.contentView.bounds];
}

/**
 *	按下继续按钮
 *
 *	@param	sender	继续按钮
 */
- (IBAction)goOnBtnPressed:(id)sender{
    pauseSelectType = kPauseSelect_GoOn;
    // 下面的部分可以重构掉 TODO
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    }
};

/**
 *	按下重新开始按钮
 *
 *	@param	sender	重新开始按钮
 */
- (IBAction)restartBtnPressed:(id)sender{
    pauseSelectType = kPauseSelect_Restart;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    }
};

/**
 *	按下保存并返回按钮
 *
 *	@param	sender	保存并返回按钮
 */
- (IBAction)goBackMainMenuBtnPressed:(id)sender{
//    CoordinatingController *coorCol = [CoordinatingController sharedCoordinatingController];
//    sceneController *tmp = [coorCol currentController];
//    InputController *inputCol = [tmp inputController];
//    if ([inputCol respondsToSelector:@selector(mainMenuPlayBtnUp)]) {
//        [inputCol performSelector:@selector(mainMenuPlayBtnUp)];
//    }
    pauseSelectType = kPauseSelect_GoBack;
    // Using Delegates
	if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    }

};

/**
 *	需要用来处理触屏事件。目前不做任何处理
 *
 *	@param	touches	触控点集合
 *	@param	event	UI事件
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
