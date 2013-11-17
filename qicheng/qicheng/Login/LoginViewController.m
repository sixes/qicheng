//
//  LoginViewController.m
//  qicheng
//
//  Created by tony on 13-11-11.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "AppDelegate.h"
#import "CLoginInfo.h"
#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if ( self ) {
        _lblLoginIp         = [[UILabel alloc] init];
        _textFieldIp        = [[UITextField alloc] init];
        _lblPassword        = [[UILabel alloc] init];
        _textFieldPassword   = [[UITextField alloc] init];
        _btnLogin           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _bg                 = [[UIImageView alloc] init];
    }
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


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( _textFieldIp == textField ) {
        return YES;
    }
    return YES;
}

- (BOOL) textFieldShouldReturn : (UITextField *)textField
{
    //if (_textFieldIp == textField) {
        [textField resignFirstResponder];
    //}
    
    return YES;
}

- (void)onTapOutside
{
    [_textFieldIp resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOutside)];
    [self.view addGestureRecognizer:tgr];
    [tgr release];
    
    
    UIImage *imgBg = [UIImage imageNamed:@"bg3.jpg"];
    [_bg setImage:imgBg];
    [_bg setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    [self.view addSubview:_bg];
    
    NSString *pStr = @"地址 ";
    CGSize ipStrSize = [pStr sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblLoginIp setText:pStr];
    [_lblLoginIp setTextColor:[UIColor grayColor]];
    [_lblLoginIp setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblLoginIp setFrame:CGRectMake(5, [AppDelegate shareAppDelegate].height * 2 / 3, ipStrSize.width, ipStrSize.height)];
    [_lblLoginIp setBackgroundColor:[UIColor clearColor]];
    //[self.view addSubview:_lblLoginIp];
    
    [_textFieldIp setFrame:CGRectMake(15, [AppDelegate shareAppDelegate].height / 3, [AppDelegate shareAppDelegate].width - 15 * 2, 30)];
    [_textFieldIp setTextColor:[UIColor blackColor]];
    [_textFieldIp setBackgroundColor:[UIColor whiteColor]];
    [_textFieldIp setText:@"192.168.1.254:50000"];
    [_textFieldIp setPlaceholder:@"192.168.1.254:50000"];
    [_textFieldIp setAdjustsFontSizeToFitWidth:YES];
    
    [_textFieldIp setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldIp setLeftView:_lblLoginIp];
    _textFieldIp.borderStyle        = UITextBorderStyleRoundedRect;
    _textFieldIp.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _textFieldIp.keyboardType       = UIKeyboardAppearanceDefault;
    _textFieldIp.returnKeyType      = UIReturnKeyNext;
    [_textFieldIp setDelegate:self];
    
    [self.view addSubview:_textFieldIp];
    
    NSString *pPsw = @"密码 ";
    CGSize pswStrSize = [pPsw sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblPassword setText:pPsw];
    [_lblPassword setTextColor:[UIColor grayColor]];
    [_lblPassword setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_lblPassword setFrame:CGRectMake(20, 200 + ipStrSize.height, pswStrSize.width, pswStrSize.height)];
    [_lblPassword setBackgroundColor:[UIColor clearColor]];
    //[self.view addSubview:_lblPassword];
    
    
    
    [_textFieldPassword setFrame:CGRectMake(15,_textFieldIp.frame.origin.y + _textFieldIp.frame.size.height + 5, [AppDelegate shareAppDelegate].width - 15 * 2, 30)];
    [_textFieldPassword setTextColor:[UIColor blackColor]];
    [_textFieldPassword setBackgroundColor:[UIColor whiteColor]];
    //[textFieldPassword setText:@"192.168.1.92:50000"];
    //[textFieldPassword setPlaceholder:@"192.168.1.92:50000"];
    _textFieldPassword.borderStyle           = UITextBorderStyleRoundedRect;
    _textFieldPassword.clearButtonMode       = UITextFieldViewModeWhileEditing;
    _textFieldPassword.keyboardType          = UIKeyboardTypeDecimalPad;
    _textFieldPassword.returnKeyType         = UIReturnKeyDone;
    [_textFieldPassword setSecureTextEntry:YES];
    [_textFieldPassword setDelegate:self];
    
    [_textFieldPassword setLeftView:_lblPassword];
    [_textFieldPassword setLeftViewMode:UITextFieldViewModeAlways];
    //[_textFieldPassword addTarget:self action:@selector(onPassWordDone:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_textFieldPassword];
    
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlContentHorizontalAlignmentCenter];
    [_btnLogin setFrame:CGRectMake(15,_textFieldPassword.frame.origin.y + _textFieldPassword.frame.size.height + 10, [AppDelegate shareAppDelegate].width - 15 * 2, 35)];
    [_btnLogin setBackgroundColor:[UIColor lightGrayColor]];
    [_btnLogin addTarget:self action:@selector(onBtnLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnLogin];
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
   // _textFieldIp.text
    
    //it should save at the time login successes,not here...to be done
    [[CLoginInfo shareLoginInfo] setLoginPasswod:_textFieldPassword.text];
    NSLog(@"psw:%@",[CLoginInfo shareLoginInfo].loginPasswod);
    [[AppDelegate shareAppDelegate] onTapLogin:_textFieldIp.text  psw:_textFieldPassword.text];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
