//
//  FinishView.h
//  MCGame
//
//  Created by kwan terry on 13-5-22.
//
//

#import "UATitledModalPanel.h"
#import "MCConfiguration.h"

@interface FinishView : UATitledModalPanel <UIPopoverControllerDelegate>{
    FinishViewType finishViewType;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, assign) FinishViewType finishViewType;
@property (retain, nonatomic) IBOutlet UITextField *userNameEditField;
@property (retain, nonatomic) UIPopoverController *changeUserPopover;
@property (retain, nonatomic) IBOutlet UILabel *learningTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *learningStepCountLabel;
@property (nonatomic) long lastingTime;
@property (nonatomic) NSInteger stepCount;
@property (retain, nonatomic) IBOutlet UIButton *changeUserBtn;
@property (retain, nonatomic) IBOutlet UIView *knowledgePanel;
@property (retain, nonatomic) IBOutlet UIView *userNameEditPanel;

@property (retain, nonatomic) IBOutlet UILabel *celebrationLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *learningTimeTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *learningStepTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *knowledgeTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *knowLedgeTextView;


- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (IBAction)goBackBtnPressed:(id)sender;

- (IBAction)oneMoreBtnPressed:(id)sender;

- (IBAction)goCountingBtnPressed:(id)sender;

- (IBAction)shareBtnPressed:(id)sender;

- (IBAction)changeUserBtn:(id)sender;

@end
