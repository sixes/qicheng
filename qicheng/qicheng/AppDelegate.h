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
#import "FunctionViewController.h"
#import "LoginViewController.h"
#import "MainUIViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoginViewController *_loginViewController;
    MainUIViewController *_mainUIViewController;
    FunctionViewController *_functionViewController;

    AsyncSocket *_socket;
    BOOL _bConnected;
    NSTimer * _timer;
    NSMutableData *_readData;
    CGFloat _width;
    CGFloat _height;

    NSCharacterSet * _recvTailSet;
}

@property (assign) CGFloat height;
@property (assign) CGFloat width;
@property (nonatomic,retain) NSMutableData *readData;
@property (nonatomic,assign) FunctionViewController *functionViewController;
@property (nonatomic,assign) LoginViewController *loginViewController;
@property (nonatomic,assign) MainUIViewController *mainUIViewController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSCharacterSet *recvTailSet;

- (void)didLoginSuccess;
+ (AppDelegate*) shareAppDelegate;

- (BOOL)onTapLogin:(NSString*)loginIp psw:(NSString*)loginPassWord;

//request
- (void)openCurtain;
- (void)stopCurtain;
- (void)closeCurtain;
- (void)queryAlarmIsOpen;
- (void)queryAllAlarmCount;
- (void)queryAllRelayStatus;
- (void)queryAllSensorStatus;
- (void)queryAllTimerStatus;
- (void)querySysDateTime;
- (void)openRelayAtIndex:(NSUInteger)index;
- (void)closeRelayAtIndex:(NSUInteger)index;

//response
- (void)didCloseCurtain;
- (void)didOpenCurtain;
- (void)didStopCurtain;
- (void)didOpenRelayAtIndex:(NSInteger)index;
- (void)didCloseRelayAtIndex:(NSInteger)index;

- (void)prepareSendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)sendDataWithFunctionName:(NSString *)name data:(NSData *)aData;


- (void)didReceiveData:(NSMutableData *)data;
- (void)didReceiveDataWithFunctionName:(NSString *)name data:(NSString *)aData;

@end
