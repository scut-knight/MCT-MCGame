//
//  PopChangeUserViewController.h
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCUserManagerController.h"

/**
 *	用户数据更改弹出对话框
 */
@interface PopChangeUserViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource>
{
    /**
     *	用户管理控制类
     */
    MCUserManagerController *userManagerController;
}
@property (retain, nonatomic) IBOutlet UIPickerView *picker;

@end
