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
#import "SceneViewController.h"
#import "SettingViewController.h"
#import "SetDeviceNameViewController.h"
#import "TimerViewController.h"
#import "ChangePasswodViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>
{
    
    ChangePasswodViewController *_changePasswordViewController;
    FunctionViewController *_functionViewController;
    LoginViewController *_loginViewController;
    MainUIViewController *_mainUIViewController;
    SceneViewController *_sceneViewController;
    SetDeviceNameViewController *_setDeviceNameViewController;
    SettingViewController *_settingViewController;
    TimerViewController *_timerViewController;
    
    AsyncSocket *_socket;
    BOOL _bConnected;
    NSTimer * _timer;
    NSMutableData *_readData;
    CGFloat _width;
    CGFloat _height;

    NSCharacterSet * _recvTailSet;
    
    UINavigationController *_navController;
    
    BOOL _biPad;
}

@property (nonatomic,assign) BOOL biPad;
@property (assign) CGFloat height;
@property (assign) CGFloat width;
@property (nonatomic,retain) NSMutableData *readData;
@property (nonatomic,assign) ChangePasswodViewController *changePasswordViewController;
@property (nonatomic,assign) FunctionViewController *functionViewController;
@property (nonatomic,assign) LoginViewController *loginViewController;
@property (nonatomic,assign) MainUIViewController *mainUIViewController;
@property (nonatomic,assign) UINavigationController *navController;
@property (nonatomic,assign) SceneViewController *sceneViewController;
@property (nonatomic,assign) SetDeviceNameViewController    *setDeviceNameViewController;
@property (nonatomic,assign) SettingViewController *settingViewController;
@property (nonatomic,assign) TimerViewController *timerViewController;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSCharacterSet *recvTailSet;

- (void)didLoginSuccess;
+ (AppDelegate*) shareAppDelegate;

- (BOOL)onTapLogin:(NSString*)loginIp psw:(NSString*)loginPassWord port:(NSString*)port moduleIdx:(NSString*)idx;

//request
- (void)changePassword:(NSString*)password;
- (void)clearCounter;
- (void)enableAlarm;
- (void)disableAlarm;
- (void)openCurtain;
- (void)stopCurtain;
- (void)closeCurtain;
- (void)queryAlarmIsOpen;
- (void)queryAllAlarmCount;
- (void)queryAllRelayStatus;
- (void)queryAllSensorStatus;
- (void)queryAllTimerStatus;
- (void)querySysDateTime;
- (void)queryTemperature;
- (void)set5TimerAtChannel:(NSUInteger)channel;
- (void)setSysDateTime;
- (void)openRelayAtIndex:(NSUInteger)index;
- (void)closeRelayAtIndex:(NSUInteger)index;

//response
- (void)didChangePassword;
- (void)didClearCounter;
- (void)didEnableAlarm;
- (void)didDisableAlarm;
- (void)didCloseCurtain;
- (void)didOpenCurtain;
- (void)didSet5Timer;
- (void)didSetSysDateTime;
- (void)didStopCurtain;
- (void)didOpenRelayAtIndex:(NSInteger)index;
- (void)didCloseRelayAtIndex:(NSInteger)index;
- (void)didUpdateTemp;

- (void)prepareSendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)sendDataWithFunctionName:(NSString *)name data:(NSData *)aData;


- (void)didReceiveData:(NSMutableData *)data;
- (void)didReceiveDataWithFunctionName:(NSString *)name data:(NSString *)aData;

- (NSString *)ToHex:(long long int)tmpid;

- (void)logout;
@end
