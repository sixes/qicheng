//
//  SetDeviceNameViewController.m
//  qicheng
//
//  Created by tony on 13-12-9.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "SetDeviceNameViewController.h"
#import "AppDelegate.h"
#import "DeviceData.h"
#import "LoginInfo.h"

@interface SetDeviceNameViewController ()

@end

@implementation SetDeviceNameViewController

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
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOutside)];
    [self.view addGestureRecognizer:tgr];
    [tgr release];
    
    _lbl0       = [[UILabel alloc] init];
    _lbl1       = [[UILabel alloc] init];
    _lbl2       = [[UILabel alloc] init];
    _lbl3       = [[UILabel alloc] init];
    _lbl4       = [[UILabel alloc] init];
    _lbl5       = [[UILabel alloc] init];
    _lbl6       = [[UILabel alloc] init];
    _lbl7       = [[UILabel alloc] init];
    
    _tf0        = [[UITextField alloc] init];
    _tf1        = [[UITextField alloc] init];
    _tf2        = [[UITextField alloc] init];
    _tf3        = [[UITextField alloc] init];
    _tf4        = [[UITextField alloc] init];
    _tf5        = [[UITextField alloc] init];
    _tf6        = [[UITextField alloc] init];
    _tf7        = [[UITextField alloc] init];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnClear  = [UIButton buttonWithType:UIButtonTypeCustom];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect lbl0Rt,lbl1Rt,lbl2Rt,lbl3Rt,lbl4Rt,lbl5Rt,lbl6Rt,lbl7Rt;
    CGRect tf0Rt,tf1Rt,tf2Rt,tf3Rt,tf4Rt,tf5Rt,tf6Rt,tf7Rt;
    CGRect btnConfirmRt,btnClearRt;
    if ( [AppDelegate shareAppDelegate].biPad )
    {
        ;
    }
    else
    {
        lbl0Rt  = CGRectMake(20, 80, 20, 40);
        tf0Rt   = CGRectMake(50, 80, 100, 40);
        lbl1Rt  = CGRectMake(20, 140, 20, 40);
        tf1Rt   = CGRectMake(50, 140, 100, 40);
        lbl2Rt  = CGRectMake(20, 200, 20, 40);
        tf2Rt   = CGRectMake(50, 200, 100, 40);
        lbl3Rt  = CGRectMake(20, 260, 20, 40);
        tf3Rt   = CGRectMake(50, 260, 100, 40);
        
        lbl4Rt  = CGRectMake(170, 80, 20, 40);
        tf4Rt   = CGRectMake(200, 80, 100, 40);
        lbl5Rt  = CGRectMake(170, 140, 20, 40);
        tf5Rt   = CGRectMake(200, 140, 100, 40);
        lbl6Rt  = CGRectMake(170, 200, 20, 40);
        tf6Rt   = CGRectMake(200, 200, 100, 40);
        lbl7Rt  = CGRectMake(170, 260, 20, 40);
        tf7Rt   = CGRectMake(200, 260, 100, 40);
        
        btnConfirmRt    = CGRectMake(170, 330, 120, 40);
        btnClearRt      = CGRectMake(20, 330, 120, 40);
    }
    static NSString * const pStr = @"0";
    [_lbl0 setText:(NSString*)pStr];
    [_lbl0 setTextColor:[UIColor grayColor]];
    [_lbl0 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl0 setFrame:lbl0Rt];
    [_lbl0 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl0];
    
    [_tf0 setFrame:tf0Rt];
    [_tf0 setTextColor:[UIColor blackColor]];
    [_tf0 setBackgroundColor:[UIColor whiteColor]];
    [_tf0 setAdjustsFontSizeToFitWidth:YES];
    _tf0.borderStyle        = UITextBorderStyleRoundedRect;
    _tf0.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf0.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf0.returnKeyType      = UIReturnKeyNext;
    _tf0.tag                = 0;
    [_tf0 setDelegate:self];
    [self.view addSubview:_tf0];
    
    
    static NSString * const pStr1 = @"1";
    [_lbl1 setText:pStr1];
    [_lbl1 setTextColor:[UIColor grayColor]];
    [_lbl1 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl1 setFrame:lbl1Rt];
    [_lbl1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl1];
    
    [_tf1 setFrame:tf1Rt];
    [_tf1 setTextColor:[UIColor blackColor]];
    [_tf1 setBackgroundColor:[UIColor whiteColor]];
    [_tf1 setAdjustsFontSizeToFitWidth:YES];
    _tf1.borderStyle        = UITextBorderStyleRoundedRect;
    _tf1.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf1.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf1.returnKeyType      = UIReturnKeyNext;
    _tf1.tag                = 1;
    [_tf1 setDelegate:self];
    [self.view addSubview:_tf1];
    
    
    static NSString * const pStr2 = @"2";
    [_lbl2 setText:pStr2];
    [_lbl2 setTextColor:[UIColor grayColor]];
    [_lbl2 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl2 setFrame:lbl2Rt];
    [_lbl2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl2];
    
    [_tf2 setFrame:tf2Rt];
    [_tf2 setTextColor:[UIColor blackColor]];
    [_tf2 setBackgroundColor:[UIColor whiteColor]];
    [_tf2 setAdjustsFontSizeToFitWidth:YES];
    _tf2.borderStyle        = UITextBorderStyleRoundedRect;
    _tf2.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf2.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf2.returnKeyType      = UIReturnKeyNext;
    _tf2.tag                = 2;
    [_tf2 setDelegate:self];
    [self.view addSubview:_tf2];
    
    
    static NSString * const pStr3 = @"3";
    [_lbl3 setText:pStr3];
    [_lbl3 setTextColor:[UIColor grayColor]];
    [_lbl3 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl3 setFrame:lbl3Rt];
    [_lbl3 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl3];
    
    [_tf3 setFrame:tf3Rt];
    [_tf3 setTextColor:[UIColor blackColor]];
    [_tf3 setBackgroundColor:[UIColor whiteColor]];
    [_tf3 setAdjustsFontSizeToFitWidth:YES];
    _tf3.borderStyle        = UITextBorderStyleRoundedRect;
    _tf3.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf3.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf3.returnKeyType      = UIReturnKeyNext;
    _tf3.tag                = 3;
    [_tf3 setDelegate:self];
    [self.view addSubview:_tf3];
    
    
    static NSString * const pStr4 = @"4";
    [_lbl4 setText:pStr4];
    [_lbl4 setTextColor:[UIColor grayColor]];
    [_lbl4 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl4 setFrame:lbl4Rt];
    [_lbl4 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl4];
    
    [_tf4 setFrame:tf4Rt];
    [_tf4 setTextColor:[UIColor blackColor]];
    [_tf4 setBackgroundColor:[UIColor whiteColor]];
    [_tf4 setAdjustsFontSizeToFitWidth:YES];
    _tf4.borderStyle        = UITextBorderStyleRoundedRect;
    _tf4.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf4.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf4.returnKeyType      = UIReturnKeyNext;
    _tf4.tag                = 4;
    [_tf4 setDelegate:self];
    [self.view addSubview:_tf4];
    
    
    static NSString * const pStr5 = @"5";
    [_lbl5 setText:pStr5];
    [_lbl5 setTextColor:[UIColor grayColor]];
    [_lbl5 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl5 setFrame:lbl5Rt];
    [_lbl5 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl5];
    
    [_tf5 setFrame:tf5Rt];
    [_tf5 setTextColor:[UIColor blackColor]];
    [_tf5 setBackgroundColor:[UIColor whiteColor]];
    [_tf5 setAdjustsFontSizeToFitWidth:YES];
    _tf5.borderStyle        = UITextBorderStyleRoundedRect;
    _tf5.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf5.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf5.returnKeyType      = UIReturnKeyNext;
    _tf5.tag                = 5;
    [_tf5 setDelegate:self];
    [self.view addSubview:_tf5];
    
    
    static NSString * const pStr6 = @"6";
    [_lbl6 setText:pStr6];
    [_lbl6 setTextColor:[UIColor grayColor]];
    [_lbl6 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl6 setFrame:lbl6Rt];
    [_lbl6 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl6];
    
    [_tf6 setFrame:tf6Rt];
    [_tf6 setTextColor:[UIColor blackColor]];
    [_tf6 setBackgroundColor:[UIColor whiteColor]];
    [_tf6 setAdjustsFontSizeToFitWidth:YES];
    _tf6.borderStyle        = UITextBorderStyleRoundedRect;
    _tf6.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf6.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf6.returnKeyType      = UIReturnKeyNext;
    _tf6.tag                = 6;
    [_tf6 setDelegate:self];
    [self.view addSubview:_tf6];
    
    
    static NSString * const pStr7 = @"7";
    [_lbl7 setText:pStr7];
    [_lbl7 setTextColor:[UIColor grayColor]];
    [_lbl7 setFont:[UIFont boldSystemFontOfSize:30.0]];
    [_lbl7 setFrame:lbl7Rt];
    [_lbl7 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_lbl7];
    
    [_tf7 setFrame:tf7Rt];
    [_tf7 setTextColor:[UIColor blackColor]];
    [_tf7 setBackgroundColor:[UIColor whiteColor]];
    [_tf7 setAdjustsFontSizeToFitWidth:YES];
    _tf7.borderStyle        = UITextBorderStyleRoundedRect;
    _tf7.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _tf7.keyboardType       = UIKeyboardTypeNamePhonePad;
    _tf7.returnKeyType      = UIReturnKeyNext;
    _tf7.tag                = 7;
    [_tf7 setDelegate:self];
    [self.view addSubview:_tf7];
    
    

    [_btnClear setTitle:@"清空" forState:UIControlStateNormal];
    [_btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnClear setFrame:btnClearRt];
    [_btnClear setBackgroundColor:[UIColor blueColor]];
    [_btnClear addTarget:self action:@selector(onBtnClear) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnClear];
    
    [_btnConfirm setTitle:@"保存" forState:UIControlStateNormal];
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConfirm setFrame:btnConfirmRt];
    [_btnConfirm setBackgroundColor:[UIColor blueColor]];
    [_btnConfirm addTarget:self action:@selector(onBtnConfirm) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnConfirm];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_KEY_DEVICE_NAME];
    if ( dict )
    {
        [_tf0 setText:[dict objectForKey:@"0"]];
        [_tf1 setText:[dict objectForKey:@"1"]];
        [_tf2 setText:[dict objectForKey:@"2"]];
        [_tf3 setText:[dict objectForKey:@"3"]];
        [_tf4 setText:[dict objectForKey:@"4"]];
        [_tf5 setText:[dict objectForKey:@"5"]];
        [_tf6 setText:[dict objectForKey:@"6"]];
        [_tf7 setText:[dict objectForKey:@"7"]];
    }
}

- (void)onBtnClear
{
    for (UIView *view in [self.view subviews])
    {
        if ( [view isKindOfClass:[UITextField class]] )
        {
            UITextField *tf = (UITextField*)view;
            tf.text = @"";
        }
    }
}
- (void)onBtnConfirm
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (UIView *view in [self.view subviews])
    {
        if ( [view isKindOfClass:[UITextField class]] )
        {
            UITextField *tf = (UITextField*)view;
            NSString *name = (NSString*)[[CDeviceData shareDeviceData].relayName objectAtIndexedSubscript:tf.tag];
            if ( [tf.text length] > 0 )
            {
                name = tf.text;
            }
            [dict setValue:name forKey:[NSString stringWithFormat:@"%d",tf.tag]];
            [[CDeviceData shareDeviceData].relayName setObject:name atIndexedSubscript:tf.tag];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:USER_DEFAULT_KEY_DEVICE_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示信息"
                                                    message:@"保存成功"
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

- (void)dealloc
{
    [_lbl0 release];
    [_lbl1 release];
    [_lbl2 release];
    [_lbl3 release];
    [_lbl4 release];
    [_lbl5 release];
    [_lbl6 release];
    [_lbl7 release];
    //to be done
    [super dealloc];
}



















@end
