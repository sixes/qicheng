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
#import "MainUIViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoginViewController *_loginViewController;
    MainUIViewController *_mainUIViewController;
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
@property (nonatomic,assign) LoginViewController *loginViewController;
@property (nonatomic,assign) MainUIViewController *mainUIViewController;
@property (strong, nonatomic) UIWindow *window;

- (void)didLoginSuccess;
+ (AppDelegate*) shareAppDelegate;

- (BOOL)onTapLogin:(NSString*)loginIp psw:(NSString*)loginPassWord;


- (void)queryAlarmIsOpen;
- (void)queryAllAlarmCount;
- (void)queryAllRelayStatus;
- (void)queryAllSensorStatus;
- (void)queryAllTimerStatus;
- (void)querySysDateTime;


- (void)prepareSendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)sendDataWithFunctionName:(NSString *)name data:(NSData *)aData;


- (void)didReceiveData:(NSMutableData *)data;
- (void)didReceiveDataWithFunctionName:(NSString *)name data:(NSString *)aData;

@end
