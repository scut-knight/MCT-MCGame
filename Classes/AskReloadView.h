//
//  AskReloadView.h
//  MCGame
//
//  Created by kwan terry on 13-3-9.
//
//

#import "UATitledModalPanel.h"
#import "MCConfiguration.h"

/**
 *	每次重载场景时弹出的对话框
 */
@interface AskReloadView : UATitledModalPanel{
    AskReloadType askReloadType;
    IBOutlet UIView	*viewLoadedFromXib;

}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) AskReloadType askReloadType;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (IBAction)loadLastTimeBtnPressed:(id)sender;
- (IBAction)reloadBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;

@end
