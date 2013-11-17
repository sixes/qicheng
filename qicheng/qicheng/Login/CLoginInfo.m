//
//  CLoginInfo.m
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "CLoginInfo.h"

@implementation CLoginInfo

@synthesize loginDomain     = _strDomain;
@synthesize loginIp         = _strIp;
@synthesize loginPasswod    = _strPassword;
@synthesize loginPort       = _strProt;

static CLoginInfo * _shareLoginInfo;

+ (CLoginInfo *)shareLoginInfo
{
    if ( ! _shareLoginInfo )
    {
        _shareLoginInfo = [[CLoginInfo alloc] init];
    }
    return _shareLoginInfo;
}
@end
