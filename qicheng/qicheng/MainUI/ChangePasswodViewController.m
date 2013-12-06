//
//  ChangePasswodViewController.m
//  qicheng
//
//  Created by tony on 13-12-5.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "ChangePasswodViewController.h"
#import "AppDelegate.h"
#import "DeviceData.h"
#import "LoginInfo.h"

@interface ChangePasswodViewController ()

@end

@implementation ChangePasswodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)onTapOutside
{
    for (UIView *view in [self.view subviews])
    {
        if ( [view isKindOfClass:[UITextField class]] )
        {
            [view resignFirstResponder];
        }
    }
}

- (void)loadView
{
    UIImage *bgImg = [UIImage imageNamed:@"bg_main_ui.jpg"];
    self.view = [[UIImageView alloc] initWithImage:bgImg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    [self.view setUserInteractionEnabled:YES];
    
    _lblOldPassword = [[UILabel alloc] init];
    _lblNewPassword = [[UILabel alloc] init];
    _lblConfirmPassword = [[UILabel alloc] init];
    
    _tfOldPassword = [[UITextField alloc] init];
    _tfNewPassword = [[UITextField alloc] init];
    _tfConfirmPassword = [[UITextField alloc] init];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOutside)];
    [self.view addGestureRecognizer:tgr];
    [tgr release];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
}

- (void)dealloc
{
    [_lblOldPassword release];
    [_lblNewPassword release];
    [_lblConfirmPassword release];
    
    [_tfOldPassword release];
    [_tfNewPassword release];
    [_tfConfirmPassword release];
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    static const NSString *pStr = @"旧密码";
    CGSize ipStrSize = [pStr sizeWithFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lblOldPassword setText:(NSString*)pStr];
    [_lblOldPassword setTextColor:[UIColor grayColor]];
    [_lblOldPassword setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblOldPassword setFrame:CGRectMake(25, 80, ipStrSize.width, ipStrSize.height)];
    [_lblOldPassword setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lblOldPassword];
    
    [_tfOldPassword setFrame:CGRectMake(100,80,200, 40)];
    [_tfOldPassword setTextColor:[UIColor blackColor]];
    [_tfOldPassword setBackgroundColor:[UIColor whiteColor]];
    [_tfOldPassword setAdjustsFontSizeToFitWidth:YES];
    _tfOldPassword.borderStyle        = UITextBorderStyleRoundedRect;
    _tfOldPassword.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tfOldPassword.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tfOldPassword.returnKeyType      = UIReturnKeyNext;
    _tfOldPassword.secureTextEntry    = YES;
    [_tfOldPassword setDelegate:self];
    [self.view addSubview:_tfOldPassword];
    
    
    
    static const NSString *pNewPasswordStr = @"新密码";
    CGSize pNewPasswordStrSize = [pNewPasswordStr sizeWithFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lblNewPassword setText:(NSString*)pNewPasswordStr];
    [_lblNewPassword setTextColor:[UIColor grayColor]];
    [_lblNewPassword setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblNewPassword setFrame:CGRectMake(25, 130, pNewPasswordStrSize.width, pNewPasswordStrSize.height)];
    [_lblNewPassword setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lblNewPassword];
    
    [_tfNewPassword setFrame:CGRectMake(100,130,200, 40)];
    [_tfNewPassword setTextColor:[UIColor blackColor]];
    [_tfNewPassword setBackgroundColor:[UIColor whiteColor]];
    [_tfNewPassword setAdjustsFontSizeToFitWidth:YES];
    _tfNewPassword.borderStyle        = UITextBorderStyleRoundedRect;
    _tfNewPassword.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tfNewPassword.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tfNewPassword.returnKeyType      = UIReturnKeyNext;
    _tfNewPassword.secureTextEntry    = YES;
    [_tfNewPassword setDelegate:self];
    [self.view addSubview:_tfNewPassword];
    
    
    static const NSString *pConPasswordStr = @"确认密码";
    CGSize pConPasswordStrSize = [pConPasswordStr sizeWithFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lblConfirmPassword setText:(NSString*)pConPasswordStr];
    [_lblConfirmPassword setTextColor:[UIColor grayColor]];
    [_lblConfirmPassword setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblConfirmPassword setTextAlignment:NSTextAlignmentLeft];
    [_lblConfirmPassword setFrame:CGRectMake(5, 180, pConPasswordStrSize.width, pConPasswordStrSize.height)];
    [_lblConfirmPassword setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lblConfirmPassword];
    
    [_tfConfirmPassword setFrame:CGRectMake(100,180,200, 40)];
    [_tfConfirmPassword setTextColor:[UIColor blackColor]];
    [_tfConfirmPassword setBackgroundColor:[UIColor whiteColor]];
    [_tfConfirmPassword setAdjustsFontSizeToFitWidth:YES];
    _tfConfirmPassword.borderStyle        = UITextBorderStyleRoundedRect;
    _tfConfirmPassword.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tfConfirmPassword.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tfConfirmPassword.returnKeyType      = UIReturnKeyNext;
    _tfConfirmPassword.secureTextEntry    = YES;
    [_tfConfirmPassword setDelegate:self];
    [self.view addSubview:_tfConfirmPassword];
    
    [_btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConfirm setFrame:CGRectMake(15,230, [AppDelegate shareAppDelegate].width - 35, 45)];
    [_btnConfirm setBackgroundColor:[UIColor lightGrayColor]];
    [_btnConfirm addTarget:self action:@selector(onBtnConfirmPassword:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnConfirm];
}

- (void)onBtnConfirmPassword:(id)sender
{
    if ( [_tfOldPassword.text length] < 1 )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"旧密码不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    if ( NO == [_tfOldPassword.text isEqualToString:[CLoginInfo shareLoginInfo].loginPassword] )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"原密码错误"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    if ( [_tfNewPassword.text length] < 1 || [_tfConfirmPassword.text length] < 1 )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"密码不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    if ( NO == [_tfConfirmPassword.text isEqualToString:_tfNewPassword.text] )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"两次密码不一样"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    if ( 4 != [_tfConfirmPassword.text length] )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"密码为4位数字或者英文字符"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    [[AppDelegate shareAppDelegate] changePassword:(NSString*)_tfNewPassword.text];
}

- (void)didChangePassword
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示信息"
                                                    message:@"密码修改成功"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
