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

@synthesize curtainStatus   = _strCurtainStatus;
@synthesize loginDomain     = _strDomain;
@synthesize loginIp         = _strIp;
@synthesize loginModuleIdx  = _strModuleIdx;
@synthesize loginPasswod    = _strPassword;
@synthesize loginPort       = _strProt;

static CDeviceData * _shareDeviceData;

+ (CDeviceData *)shareDeviceData
{
    if ( ! _shareDeviceData )
    {
        _shareDeviceData = [[CDeviceData alloc] initWithRelayStatusCount:COUNT_RELAY alarmCount:COUNT_ALARM sensorStatusCount:COUNT_SENSOR];
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

- (void)setCurtainStatus:(NSString*)status
{
    if ( NSOrderedSame == [status compare:FUNCTION_NAME_OPEN_CURTAIN options:NSLiteralSearch range:NSMakeRange(0, [FUNCTION_NAME_OPEN_CURTAIN length])] ) )
    {
        _strCurtainStatusName = CURTAIN_OPEN_NAME;
    }
    else if ( NSOrderedSame == [status compare:FUNCTION_NAME_CLOSE_CURTAIN options:NSLiteralSearch range:NSMakeRange(0, [FUNCTION_NAME_CLOSE_CURTAIN length])] ) )
    {
        _strCurtainStatusName = CURTAIN_CLOSE_NAME;
    }
    else if ( NSOrderedSame == [status compare:FUNCTION_NAME_STOP_CURTAIN options:NSLiteralSearch range:NSMakeRange(0, [FUNCTION_NAME_STOP_CURTAIN length])] ) )
    {
        _strCurtainStatusName = CURTAIN_STOP_NAME;
    }
    else
    {
        assert(false);
    }
    _strCurtainStatus = status;
}
- (NSString*)getCurtainStatus
{
    return _strCurtainStatusName;
}
@end
