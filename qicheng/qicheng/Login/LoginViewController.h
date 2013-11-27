//
//  LoginViewController.h
//  qicheng
//
//  Created by tony on 13-11-11.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UILabel *_lblLoginIp;
    UITextField *_textFieldIp;
    
    UILabel *_lblPassword;
    UITextField *_textFieldPassword;
    UIButton *_btnLogin;
    
    UIImageView *_bg;

    UILabel *_lblColon;
    UITextField *_textFieldPort;
    UITextField *_textFieldModuleIdx;
    UILabel *_lblModuleIdx;
}

- (void)didLoginSuccess;
@end
