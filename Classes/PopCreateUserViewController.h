//
//  PopCreateUserViewController.h
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCUserManagerController.h"

/**
 *	创建用户弹出对话框
 */
@interface PopCreateUserViewController : UIViewController{
    /**
     *	用户管理控制器
     */
    MCUserManagerController *userManagerController;
}

@property (retain, nonatomic) IBOutlet UITextField *inputName;
@property (retain, nonatomic) IBOutlet UIButton *createBtn;

- (IBAction)createBtnPress:(id)sender;

@end
