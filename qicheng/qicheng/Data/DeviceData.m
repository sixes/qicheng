//
//  CDeviceData.m
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "DeviceData.h"
#import "Config.h"

@implementation CDeviceData

@synthesize relayStatus     = _relayStatus;

@synthesize loginDomain     = _strDomain;
@synthesize loginIp         = _strIp;
@synthesize loginModuleIdx  = _strModuleIdx;
@synthesize loginPasswod    = _strPassword;
@synthesize loginPort       = _strProt;

static CDeviceData * _shareDeviceData;

+ (CDeviceData *)shareLoginInfo
{
    if ( ! _shareDeviceData )
    {
        _shareDeviceData = [[CDeviceData alloc] init];
        [self initWithRelayStatusCount:COUNT_RELAY alarmCount:COUNT_ALARM sensorStatusCount:COUNT_SENSOR];
    }
    return _shareDeviceData;
}

- (id)initWithRelayStatusCount:(NSUInteger) relayStatusCount alarmCount:(NSUInteger)aCount sensorStatusCount:(NSUInteger)ssCount
{
    if ( self = [super init] )
    {
        _relayStatus = [[NSMutableArray alloc] initWithCapacity:relayStatusCount];
        _alarmCount = [[NSMutableArray alloc] initWithCapacity:aCount];
        _sensorStatus = [[NSMutableArray alloc] initWithCapacity:ssCount];
    }
    return self;
}
@end
