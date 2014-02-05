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
 *	求解模式的暂停对话框的选项类型
 */
typedef enum _SolvePagePauseSelectType {
    kSolvePagePauseSelect_GoOn  = 0,
    kSolvePagePauseSelect_GoBack_Directly,
    kSolvePagePauseSelect_GoBack_AndSave,
    kSolvePagePauseSelect_Clean_State,
    kSolvePagePauseSelect_default
} SolvePagePauseSelectType;

/**
 *	求解模式的暂停菜单
 */
@interface SolvePagePauseMenu : UATitledModalPanel{
    SolvePagePauseSelectType solvePagePauseSelectType;
    IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) SolvePagePauseSelectType solvePagePauseSelectType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)goOnBtnPressed:(id)sender;
- (IBAction)saveAndReturnBtnPressed:(id)sender;
- (IBAction)returnDirectoryBtnPressed:(id)sender;
- (IBAction)cleanBtnPressed:(id)sender;

@end
