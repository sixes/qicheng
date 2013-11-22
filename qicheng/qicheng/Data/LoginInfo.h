//
//  CLoginInfo.h
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLoginInfo : NSObject
{
    NSString *_strDomain;
    NSString *_strIp;
    NSString *_strModuleIdx;
    NSString *_strPassword;
    NSString *_strProt;
}

@property (nonatomic,copy) NSString *loginDomain;
@property (nonatomic,copy) NSString *loginIp;
@property (nonatomic,copy) NSString *loginModuleIdx;
@property (nonatomic,copy) NSString *loginPasswod;
@property (nonatomic,copy) NSString *loginPort;

+ (CLoginInfo *)shareLoginInfo;
- (id)initWithModuleIdx:(NSString *)idx password:(NSString *)psw;
@end
