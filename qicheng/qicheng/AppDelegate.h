//
//  AppDelegate.h
//  qicheng
//
//  Created by tony on 13-11-11.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncSocket/AsyncUdpSocket.h"
#import "AsyncSocket/AsyncSocket.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoginViewController *_loginViewController;
    
    AsyncSocket *_socket;
    BOOL _bConnected;
    NSTimer * _timer;
    
    CGFloat _width;
    CGFloat _height;
}

@property (assign) CGFloat width;
@property (assign) CGFloat height;
@property (strong, nonatomic) UIWindow *window;
+(AppDelegate*) shareAppDelegate;
-(BOOL)onTapLogin:(NSString*)loginIp psw:(NSString*)loginPassWord;
@end
