//
//  PopChangeUserViewController.m
//  UserManagerSystem2
//
//  Created by yellow Dai on 13-1-3.
//  Copyright (c) 2013年 SCUT. All rights reserved.
//

#import "PopChangeUserViewController.h"

@interface PopChangeUserViewController ()

@end

@implementation PopChangeUserViewController
@synthesize picker;

/**
 *  初始化了用户管理控制类
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userManagerController = [MCUserManagerController allocWithZone:NULL];
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
    [self setPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/**
 *  响应正常的朝向
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 *	画面加载完成后，选择器(picker)重新加载所有组件
 *
 *	@param	animated	是否需要动画，不需要动画
 */
-(void)viewWillAppear:(BOOL)animated
{
    [picker reloadAllComponents];
}

#pragma mark -
#pragma mark picker data source methods

/**
 *	picker的组件个数
 *
 *	@param	pickerView	picker视图
 *
 *	@return	1，只有一个组件
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**
 *	某个组件有多少行内容
 *
 *	@param	pickerView	picker视图
 *	@param	component	组件编号，从0开始
 *
 *	@return	所有的用户数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [userManagerController.userModel.allUser count];
}

#pragma mark -
#pragma mark picker delegate merhods

/**
 *	加载picker中每一行的内容
 *
 *	@param	pickerView	picker视图
 *	@param	row	行数，从0开始
 *	@param	component	组件序号，从0开始
 *
 *	@return	一个字符串作为行的内容
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    MCUser *user = [userManagerController.userModel.allUser objectAtIndex:row];
    return user.name;
}

/**
 *	选中某行后的处理方式。在这里就是改变当前用户为选中用户。
 *
 *	@param	pickerView	picker视图
 *	@param	row	行序号，从0开始
 *	@param	component	组件序号，从0开始
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([userManagerController.userModel.allUser count] != 0) {
        MCUser *user = [userManagerController.userModel.allUser objectAtIndex:row];
        NSString *name = [[NSString alloc] initWithString:user.name];
        [userManagerController changeCurrentUser:name];
        [name release];
    }
}


- (void)dealloc {
    [picker release];
    [super dealloc];
}
@end
