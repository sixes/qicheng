//
//  CLoginInfo.h
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const DEFAULT_LOGIN_IP 					= @"192.168.1.254";
static NSString * const DEFAULT_LOGIN_MODULEINDEX 			= @"01";
static NSString * const DEFAULT_LOGIN_PASSWORD 				= @"1234";
static NSString * const DEFAULT_LOGIN_PORT 					= @"50000";

static NSString * const USER_DEFAULT_KEY_DEVICE_NAME        = @"qicheng_device_name";
static NSString * const USER_DEFAULT_KEY_LOGIN_IP 			= @"qicheng_login_ip";
static NSString * const USER_DEFAULT_KEY_LOGIN_PORT 		= @"qicheng_login_port";
static NSString * const USER_DEFAULT_KEY_LOGIN_PASSWORD 	= @"qicheng_login_password";
static NSString * const USER_DEFAULT_KEY_LOGIN_MODULEINDEX	= @"qicheng_login_moduleIndex";


@interface CLoginInfo : NSObject
{
    BOOL _bLogined;
    BOOL _bShowLoginView;
    
    NSString *_strDomain;
    NSString *_strIp;
    NSString *_strModuleIdx;
    NSString *_strPassword;
    NSString *_strProt;
}
@property (nonatomic,assign) BOOL bLogined;
@property (nonatomic,assign) BOOL bShowLoginView;
@property (nonatomic,copy) NSString *loginDomain;
@property (nonatomic,copy) NSString *loginIp;
@property (nonatomic,copy) NSString *loginModuleIdx;
@property (nonatomic,copy) NSString *loginPassword;
@property (nonatomic,copy) NSString *loginPort;

+ (CLoginInfo *)shareLoginInfo;
- (id)initWithModuleIdx:(NSString *)idx password:(NSString *)psw;
@end
