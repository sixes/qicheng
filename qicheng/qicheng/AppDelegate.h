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
    NSMutableData *_readData;
    CGFloat _width;
    CGFloat _height;
}

@property (assign) CGFloat height;
@property (assign) CGFloat width;
@property (nonatomic,retain) NSMutableData *readData;

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate*) shareAppDelegate;
- (BOOL)onTapLogin:(NSString*)loginIp psw:(NSString*)loginPassWord;
- (void)didReceiveData:(NSMutableData *)data;
- (void)didReceiveDataWithFunctionName:(NSString *)name data:(NSString *)aData;
@end
