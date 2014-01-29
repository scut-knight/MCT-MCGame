//
//  AskReloadView.m
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "AskReloadView.h"

/**
 *	AskReloadView 顶部的黑色框坐标
 */
#define BLACK_BAR_COMPONENTS				{ 0.171875, 0.2421875, 0.3125, 0.8, 0.07, 0.07, 0.07, 1.0 }

@implementation AskReloadView
@synthesize askReloadType,viewLoadedFromXib;

/**
 *	初始化对话框视图
 *
 *	@param	frame	对话框大小边界
 *	@param	title	对话框标题
 *
 *	@return	加载对话框
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		
        self.x_outerMargin = 344;
        self.y_outerMargin = 200;
        self.isShowColseBtn = YES;
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin =  8.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 8.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 16;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = YES;
        askReloadType = kAskReloadView_Default;
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:48.0f];
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:UAGradientBackgroundStyleLinear];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: UAGradientLineModeBottom];
        
        // The noise layer opacity. Default = 0.4
        [[self titleBar] setNoiseOpacity:0.8];
        
        // The header label, a UILabel with the same frame as the titleBar
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
        
        
        [[NSBundle mainBundle] loadNibNamed:@"myaskreloadview" owner:self options:nil];
        [viewLoadedFromXib setAlpha:0.5];
        [self.contentView addSubview:viewLoadedFromXib];
        [self.contentView setAlpha:0.5];
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
 *	按下继续上次按钮
 *
 *	@param	sender	继续上次按钮对象
 */
- (IBAction)loadLastTimeBtnPressed:(id)sender{
    askReloadType = kAskReloadView_LoadLastTime;
    // 这个函数可以抽取出来。TODO NSObject<UAModalPanelDelegate>	delegate
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
 *	@param	sender	重新开始按钮对象
 */
- (IBAction)reloadBtnPressed:(id)sender{askReloadType = kAskReloadView_Reload;
    if ([delegate respondsToSelector:@selector(shouldCloseModalPanel:)]) {
		if ([delegate shouldCloseModalPanel:self]) {
			UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
    }
};

/**
 *	按下关闭按钮
 *
 *	@param	sender	关闭按钮对象
 */
- (IBAction)cancelBtnPressed:(id)sender{
    
    askReloadType = kAskReloadView_Cancel;

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
