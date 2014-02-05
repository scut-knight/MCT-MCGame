//
//  PopCreateUserViewController.m
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "PopCreateUserViewController.h"
#import "MCUserManagerController.h"

@interface PopCreateUserViewController ()

@end

@implementation PopCreateUserViewController
@synthesize inputName;
@synthesize createBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userManagerController = [MCUserManagerController sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setInputName:nil];
    [self setCreateBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/**
 *	响应所有方向的屏幕转动
 *
 *	@param	interfaceOrientation	屏幕朝向
 *
 *	@return	永远为YES
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [inputName release];
    [createBtn release];
    [super dealloc];
}

/**
 *	按下创建按钮，通过userManagerController来创建用户
 *
 *	@param	sender	创建按钮
 */
- (void)createBtnPress:(id)sender
{
    [userManagerController createNewUser:inputName.text];
}
@end
