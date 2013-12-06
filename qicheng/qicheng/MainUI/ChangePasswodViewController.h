//
//  ChangePasswodViewController.h
//  qicheng
//
//  Created by tony on 13-12-5.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswodViewController : UIViewController <UITextFieldDelegate>
{
    UILabel *_lblOldPassword;
    UILabel *_lblNewPassword;
    UILabel *_lblConfirmPassword;
    
    UITextField *_tfOldPassword;
    UITextField *_tfNewPassword;
    UITextField *_tfConfirmPassword;
    
    UIButton *_btnConfirm;
}

- (void)didChangePassword;
@end
