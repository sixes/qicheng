//
//  LoginViewController.m
//  qicheng
//
//  Created by tony on 13-11-11.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginInfo.h"
#import "LoginViewController.h"
#import "MainUIViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ( _textFieldIp == textField )
//    {
//        return YES;
//    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)onTapOutside
{
    [_textFieldIp resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    [_textFieldModuleIdx resignFirstResponder];
    [_textFieldPort resignFirstResponder];
}

- (void)loadView
{
    UIImage *imgBg = [UIImage imageNamed:@"bg3.jpg"]; 
    self.view = [[UIImageView alloc] initWithImage:imgBg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width,[AppDelegate shareAppDelegate].height )];
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOutside)];
    [self.view addGestureRecognizer:tgr];
    [tgr release];
    
    _btnLogin           = [UIButton buttonWithType:UIButtonTypeCustom];
    _lblColon           = [[UILabel alloc] init];
    _lblLoginIp         = [[UILabel alloc] init];
    _lblModuleIdx       = [[UILabel alloc] init];
    _lblPassword        = [[UILabel alloc] init];
    _textFieldIp        = [[UITextField alloc] init];
    _textFieldModuleIdx = [[UITextField alloc] init];
    _textFieldPassword  = [[UITextField alloc] init];
    _textFieldPort      = [[UITextField alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    static const NSString *pStr = @"地址 ";
    CGSize ipStrSize = [pStr sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblLoginIp setText:(NSString*)pStr];
    [_lblLoginIp setTextColor:[UIColor grayColor]];
    [_lblLoginIp setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblLoginIp setFrame:CGRectMake(5, [AppDelegate shareAppDelegate].height * 2 / 3, ipStrSize.width, ipStrSize.height)];
    [_lblLoginIp setBackgroundColor:[UIColor clearColor]];
    
    NSString *strIp     = DEFAULT_LOGIN_IP;
    NSString *strLastIp = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_LOGIN_IP];
    if ( [strLastIp length] > 0 )
    {
        strIp = strLastIp;
    }
    int ipW = [AppDelegate shareAppDelegate].width - 15 * 2 - 100;
    int ipY = [AppDelegate shareAppDelegate].height / 3 - 20;
    [_textFieldIp setFrame:CGRectMake(15, ipY,ipW, 40)];
    [_textFieldIp setTextColor:[UIColor blackColor]];
    [_textFieldIp setBackgroundColor:[UIColor whiteColor]];
    [_textFieldIp setText:strIp];
    [_textFieldIp setPlaceholder:@"域名/IP地址"];
    [_textFieldIp setAdjustsFontSizeToFitWidth:YES];
    [_textFieldIp setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldIp setLeftView:_lblLoginIp];
    _textFieldIp.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldIp.borderStyle        = UITextBorderStyleRoundedRect;
    _textFieldIp.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _textFieldIp.keyboardType       = UIKeyboardTypeASCIICapable;
    _textFieldIp.returnKeyType      = UIReturnKeyNext;
    [_textFieldIp setDelegate:self];
    [self.view addSubview:_textFieldIp];
    
    static const NSString* strColon = @":";
    CGSize colonStrSize = [strColon sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblColon setText:(NSString*)strColon];
    [_lblColon setTextColor:[UIColor blackColor]];
    [_lblColon setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblColon setTextAlignment:NSTextAlignmentCenter];
    [_lblColon setFrame:CGRectMake(_textFieldIp.frame.origin.x + _textFieldIp.frame.size.width + 5, [AppDelegate shareAppDelegate].height / 3 - 15, colonStrSize.width, colonStrSize.height)];
    [_lblColon setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lblColon];

    NSString *strPort     = (NSString*)DEFAULT_LOGIN_PORT;
    NSString *strLastPort = [[NSUserDefaults standardUserDefaults] stringForKey:(NSString*)USER_DEFAULT_KEY_LOGIN_PORT];
    if ( [strLastPort length] > 0 )
    {
        strPort = strLastPort;
    }
    CGSize portStrSize = [strPort sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_textFieldPort setFrame:CGRectMake(_lblColon.frame.origin.x + _lblColon.frame.size.width + 5,ipY,80,40)];
    [_textFieldPort setTextColor:[UIColor blackColor]];
    [_textFieldPort setBackgroundColor:[UIColor whiteColor]];
    [_textFieldPort setText:strPort];
    [_textFieldPort setPlaceholder:@"端口"];
    _textFieldPort.borderStyle           = UITextBorderStyleRoundedRect;
    _textFieldPort.clearButtonMode       = UITextFieldViewModeWhileEditing;
    _textFieldPort.keyboardType          = UIKeyboardTypeDecimalPad;
    _textFieldPort.returnKeyType         = UIReturnKeyDone;
    _textFieldPort.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldPort setDelegate:self];
    [_textFieldPort setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldPassword addTarget:self action:@selector(onPassWordDone:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_textFieldPort];

    static const NSString *strModuleIdxName = @"模块地址 ";
    CGSize idxStrSize = [strModuleIdxName sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblModuleIdx setText:(NSString*)strModuleIdxName];
    [_lblModuleIdx setTextColor:[UIColor grayColor]];
    [_lblModuleIdx setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblModuleIdx setFrame:CGRectMake(5, [AppDelegate shareAppDelegate].height * 2 / 3, idxStrSize.width, idxStrSize.height)];
    [_lblModuleIdx setBackgroundColor:[UIColor clearColor]];
    
    NSString *strIdx     = (NSString*)DEFAULT_LOGIN_MODULEINDEX;
    NSString *strLastIdx = [[NSUserDefaults standardUserDefaults] stringForKey:(NSString*)USER_DEFAULT_KEY_LOGIN_MODULEINDEX];
    if ( [strLastIdx length] > 0 )
    {
        strIdx = strLastIdx;
    }
    [_textFieldModuleIdx setFrame:CGRectMake(15,_textFieldIp.frame.origin.y + _textFieldIp.frame.size.height + 5, [AppDelegate shareAppDelegate].width - 15 * 2, 40)];
    [_textFieldModuleIdx setTextColor:[UIColor blackColor]];
    [_textFieldModuleIdx setBackgroundColor:[UIColor whiteColor]];
    [_textFieldModuleIdx setText:strIdx];
    [_textFieldModuleIdx setPlaceholder:(NSString*)DEFAULT_LOGIN_MODULEINDEX];
    _textFieldModuleIdx.borderStyle           = UITextBorderStyleRoundedRect;
    _textFieldModuleIdx.clearButtonMode       = UITextFieldViewModeWhileEditing;
    _textFieldModuleIdx.keyboardType          = UIKeyboardTypeDecimalPad;
    _textFieldModuleIdx.returnKeyType         = UIReturnKeyDone;
    _textFieldModuleIdx.contentVerticalAlignment    = UIControlContentVerticalAlignmentCenter;
    [_textFieldModuleIdx setDelegate:self];
    [_textFieldModuleIdx setLeftView:_lblModuleIdx];
    [_textFieldModuleIdx setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldPassword addTarget:self action:@selector(onPassWordDone:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_textFieldModuleIdx];

    static const NSString *pPsw = @"密码 ";
    CGSize pswStrSize = [pPsw sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblPassword setText:pPsw];
    [_lblPassword setTextColor:[UIColor grayColor]];
    [_lblPassword setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblPassword setFrame:CGRectMake(20, 200 + ipStrSize.height, pswStrSize.width, pswStrSize.height)];
    [_lblPassword setBackgroundColor:[UIColor clearColor]];

    NSString *strPwd     = DEFAULT_LOGIN_PASSWORD;
    NSString *strLastPwd = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_LOGIN_PASSWORD];
    if ( [strLastPwd length] > 0 )
    {
        strPwd = strLastPwd;
    }
    [_textFieldPassword setFrame:CGRectMake(15,_textFieldModuleIdx.frame.origin.y + _textFieldModuleIdx.frame.size.height + 5, [AppDelegate shareAppDelegate].width - 15 * 2, 40)];
    [_textFieldPassword setTextColor:[UIColor blackColor]];
    [_textFieldPassword setBackgroundColor:[UIColor whiteColor]];
    [_textFieldPassword setText:strPwd];
    [_textFieldPassword setPlaceholder:@"默认密码为1234"];
    _textFieldPassword.borderStyle           = UITextBorderStyleRoundedRect;
    _textFieldPassword.clearButtonMode       = UITextFieldViewModeWhileEditing;
    _textFieldPassword.keyboardType          = UIKeyboardTypeDecimalPad;
    _textFieldPassword.returnKeyType         = UIReturnKeyDone;
    _textFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldPassword setSecureTextEntry:YES];
    [_textFieldPassword setDelegate:self];
    [_textFieldPassword setLeftView:_lblPassword];
    [_textFieldPassword setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldPassword addTarget:self action:@selector(onPassWordDone:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_textFieldPassword];
    
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin setFrame:CGRectMake(15,_textFieldPassword.frame.origin.y + _textFieldPassword.frame.size.height + 10, [AppDelegate shareAppDelegate].width - 15 * 2, 45)];
    [_btnLogin setBackgroundColor:[UIColor lightGrayColor]];
    [_btnLogin addTarget:self action:@selector(onBtnLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnLogin];
}


- (void)didLoginSuccess
{
    [CLoginInfo shareLoginInfo].bLogined = YES;
    if ( ! [AppDelegate shareAppDelegate].mainUIViewController )
    {
        [AppDelegate shareAppDelegate].mainUIViewController = [[MainUIViewController alloc] init];
    }
   // [self presentViewController:[AppDelegate shareAppDelegate].mainUIViewController animated:YES completion:nil];
    
    
    //[[AppDelegate shareAppDelegate].navController presentViewController:[AppDelegate shareAppDelegate].mainUIViewController animated:YES completion:nil];
    if ( [self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)] )
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        [self.parentViewController dismissModalViewControllerAnimated:NO];
    }
    [CLoginInfo shareLoginInfo].bShowLoginView = NO;
    //[[AppDelegate shareAppDelegate].navController popToRootViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onPassWordDone:(id)sender
{
    UITextField * tf = (UITextField *)sender;
    [tf resignFirstResponder];
}

-(void)onBtnLogin:(id)sender
{
    NSLog(@"login tap");
    UIButton *btn = (UIButton*)sender;
   if ( [_textFieldIp.text length] < 1 )
   {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"地址不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
   }
   if ( [_textFieldPassword.text length] < 1 )
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
   if ( [_textFieldPort.text length] < 1 )
   {
       UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"端口不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
   }
   if ( [_textFieldModuleIdx.text length] < 1 )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"模块地址不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    } 


    //NSLog(@"psw:%@",[CLoginInfo shareLoginInfo].loginPassword);
    [[AppDelegate shareAppDelegate] onTapLogin:_textFieldIp.text  psw:_textFieldPassword.text port:_textFieldPort.text moduleIdx:_textFieldModuleIdx.text];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_lblLoginIp release];
    [_lblModuleIdx release];
    [_textFieldIp release];
    [_lblPassword release];
    [_textFieldPassword release];
    [_btnLogin release];
    [_lblColon release];
    [_textFieldPort release];
    [_textFieldModuleIdx release];
}

- (void)dealloc
{
    [_lblLoginIp release];
    [_lblModuleIdx release];
    [_textFieldIp release];
    [_lblPassword release];
    [_textFieldPassword release];
    [_btnLogin release];
    [_lblColon release];
    [_textFieldPort release];
    [_textFieldModuleIdx release];
    [super dealloc];
}
@end
