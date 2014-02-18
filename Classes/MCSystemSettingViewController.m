//
//  MCSystemSettingViewController.m
//  MCGame
//
//  Created by kwan terry on 13-6-3.
//
//

#import "MCSystemSettingViewController.h"
#import "MCStringDefine.h"
#import "CoordinatingController.h"
#import <AVFoundation/AVFoundation.h>
#import "MCSoundBoard.h"
#import "SoundSettingController.h"
#import "MCFonts.h"

@interface MCSystemSettingViewController ()

@end

@implementation MCSystemSettingViewController

/**
 *	从插件管理包中加载nib文件
 *
 *	@param	nibNameOrNil	界面文件
 *	@param	nibBundleOrNil	nib所在的包
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置两个滑动条
    [soundEffectSlider setValue:[[[SoundSettingController sharedsoundSettingController] _RotateEffectValume] floatValue]];
    [soundEffectSlider addTarget:self action:@selector(effectsVolume:) forControlEvents:UIControlEventValueChanged];
    
    [musicSlider setValue:[[[SoundSettingController sharedsoundSettingController] _BackGroundMusicValume] floatValue]];
    [musicSlider addTarget:self action:@selector(musicVolume:) forControlEvents:UIControlEventValueChanged];
    
    // set fonts
    [settingLabel setFont:[MCFonts customFontWithSize:50]];
    [soundEffectLabel setFont:[MCFonts customFontWithSize:25]];
    [musicLabel setFont:[MCFonts customFontWithSize:25]];
    [magicCubeSkinLabel setFont:[MCFonts customFontWithSize:25]];
    
    // default color 
    [_selectColorItemOne setEnabled:NO];
}

/**
 *	处理内存警告。处理方法是转发给父类。
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	调节音乐音量大小
 *
 *	@param	sender	音乐滑动条
 */
- (void) musicVolume:(id)sender
{
	SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting setBackgroundPlayer_Volume:[(UISlider*)sender value]];
}

/**
 *	调节音乐开关。该方法没有被用到。
 *
 *	@param	sender	音乐开关
 */
- (void) musicSwitch:(id)sender
{
	//soundMgr.backgroundMusicVolume = ((UISlider *)sender).value;
    SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting loopBackGroundAudioFlipSwitch];
}

/**
 *	调节音效音量大小
 *
 *	@param	sender	音效滑动条
 */
- (void) effectsVolume:(id)sender
{
	SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting setRotateEffectVolume:[(UISlider*)sender value]];
}

/**
 *	调节音效开关。该方法没有被用到。
 *
 *	@param	sender	音效开关
 */
- (void) effectsSwitch:(id)sender
{
	SoundSettingController * soundsetting = [SoundSettingController sharedsoundSettingController];
    [soundsetting rotateSoundFlipSwitch];
}

/**
 *	回到主菜单
 *
 *	@param	sender	回退按钮
 */
-(void)goBackMainMenu:(id)sender{
    CoordinatingController *tmp = [CoordinatingController sharedCoordinatingController];
    [tmp requestViewChangeByObject:kSystemSetting2MainMenu];
}

/**
 *	选择魔方皮肤颜色，三选一。
 *  你能选择魔方皮肤的颜色，但是你不能改变魔方皮肤的颜色。而且更坑爹的是，事实上只有一套配色文件。
 *  也就是说，1.0版本开发者并没有真正实现这个功能。
 *
 *	@param	sender	颜色选择标签
 */
- (IBAction)selectOneColor:(id)sender {
    NSInteger tag = [sender tag];
    
    [_selectColorItemOne setEnabled:YES];
    [_selectColorItemTwo setEnabled:YES];
    [_selectColorItemThree setEnabled:YES];
    
    switch (tag) {
        case 0:
            [_selectColorItemOne setEnabled:NO];
            break;
        case 1:
            [_selectColorItemTwo setEnabled:NO];
            break;
        case 2:
            [_selectColorItemThree setEnabled:NO];
            break;
        default:
            break;
    }
}

#pragma mark - touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
};
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{};
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{};
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{};


- (void)dealloc {
    [soundEffectSlider release];
    [musicSlider release];
    [settingLabel release];
    [soundEffectLabel release];
    [musicLabel release];
    [magicCubeSkinLabel release];
    [_selectColorItemOne release];
    [_selectColorItemTwo release];
    [_selectColorItemThree release];
    [super dealloc];
}

/**
 *	如果视图加载失败，调用该方法，注意把各变量release后设置为nil
 */
- (void)viewDidUnload {
    [soundEffectSlider release];
    soundEffectSlider = nil;
    [musicSlider release];
    musicSlider = nil;
    [settingLabel release];
    settingLabel = nil;
    [soundEffectLabel release];
    soundEffectLabel = nil;
    [musicLabel release];
    musicLabel = nil;
    [magicCubeSkinLabel release];
    magicCubeSkinLabel = nil;
    [_selectColorItemOne release];
    _selectColorItemOne = nil;
    [_selectColorItemTwo release];
    _selectColorItemTwo = nil;
    [_selectColorItemThree release];
    _selectColorItemThree = nil;
    [super viewDidUnload];
}
@end
