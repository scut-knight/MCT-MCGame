//
//  LearnPagePauseMenu.h
//  MCGame
//
//  Created by kwan terry on 13-6-18.
//
//
#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "sceneController.h"
#import "InputController.h"
#import "CoordinatingController.h"

/**
 *	学习模式的暂停对话框的选项类型
 */
typedef enum _LearnPagePauseSelectType {
    kLearnPagePauseSelect_GoOn  = 0,
    kLearnPagePauseSelect_GoBack,
    kLearnPagePauseSelect_Restart,
    kLearnPagePauseSelect_default
} LearnPagePauseSelectType;

/**
 *	学习模式的暂停菜单
 */
@interface LearnPagePauseMenu : UATitledModalPanel{
    LearnPagePauseSelectType learnPagePauseSelectType;
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) LearnPagePauseSelectType learnPagePauseSelectType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)goOnBtnPressed:(id)sender;
- (IBAction)restartBtnPressed:(id)sender;
- (IBAction)goBackMainMenuBtnPressed:(id)sender;

@end
