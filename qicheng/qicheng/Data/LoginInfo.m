//
//  CLoginInfo.m
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "LoginInfo.h"

@implementation CLoginInfo

@synthesize loginDomain     = _strDomain;
@synthesize loginIp         = _strIp;
@synthesize loginModuleIdx  = _strModuleIdx;
@synthesize loginPasswod    = _strPassword;
@synthesize loginPort       = _strProt;

static CLoginInfo * _shareLoginInfo;

+ (CLoginInfo *)shareLoginInfo
{
    if ( ! _shareLoginInfo )
    {
        _shareLoginInfo = [[CLoginInfo alloc] initWithModuleIdx:@"01" password:@"1234"];
        
    }
    return _shareLoginInfo;
}

- (id)initWithModuleIdx:(NSString *)idx password:(NSString *)psw
{
    if ( self = [super init] )
    {
        _strModuleIdx   = idx;
        _strPassword    = psw;
    }
    return self
    ;
}
@end
