//
//  CDeviceData.m
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "DeviceData.h"
#import "Config.h"
#import "LoginInfo.h"

@implementation CDeviceData


@synthesize bAlarmOpen      = _bAlarmOpen;
@synthesize curtainStatus   = _strCurtainStatus;
@synthesize insideTemp      = _insideTemp;
@synthesize loginDomain     = _strDomain;
@synthesize loginIp         = _strIp;
@synthesize loginModuleIdx  = _strModuleIdx;
@synthesize loginPasswod    = _strPassword;
@synthesize loginPort       = _strProt;
@synthesize outsideTemp     = _outsideTemp;
@synthesize relayName       = _relayName;
@synthesize relayStatus     = _relayStatus;
@synthesize sensorStatus    = _sensorStatus;
@synthesize sensorName      = _sensorName;
@synthesize timerDict       = _timerDict;
@synthesize channelTimerStatus          = _channelTimerStatus;
@synthesize channelOpenWhenTimerExpires = _channelOpenWhenTimerExpires;
@synthesize channelTimerDate            = _channelTimerDate;

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
        _alarmCount     = [[NSMutableArray alloc] initWithCapacity:aCount];
        _relayName      = [[NSMutableArray alloc] initWithCapacity:relayStatusCount];
        _relayStatus    = [[NSMutableArray alloc] initWithCapacity:relayStatusCount];
        _sensorName     = [[NSMutableArray alloc] initWithCapacity:ssCount];   
        _sensorStatus   = [[NSMutableArray alloc] initWithCapacity:ssCount];
        
        _channelTimerStatus             = [[NSMutableArray alloc] initWithCapacity:9];
        _channelOpenWhenTimerExpires    = [[NSMutableArray alloc] initWithCapacity:5];
        _channelTimerDate               = [[NSMutableArray alloc] initWithCapacity:5];
        
        _timerDict      = [[NSDictionary alloc] init];
        
        self.outsideTemp    = [NSNumber numberWithInt:999];
        self.insideTemp     = [NSNumber numberWithInt:999];
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_KEY_DEVICE_NAME];
        if ( dict )
        {
            for (int i = 0; i != relayStatusCount; ++i)
            {
                [_relayName addObject:[dict objectForKey:[NSString stringWithFormat:@"%d",i]]];
            }
        }
        else
        {
            for (int i = 0; i != relayStatusCount; ++i)
            {
                [_relayName addObject:[NSString stringWithFormat:@"继电器%d",i + 1]];
            }
        }
       
       
        for (int i = 0; i != ssCount; ++i)
        {
            [_sensorName addObject:[NSString stringWithFormat:@"传感器%d",i + 1]];
        }
    }
    return self;
}

- (void)setCurtainStatus:(NSString*)status
{
    if ( NSOrderedSame == [status compare:FUNCTION_NAME_OPEN_CURTAIN options:NSLiteralSearch range:NSMakeRange(0, [FUNCTION_NAME_OPEN_CURTAIN length])] )
    {
        _strCurtainStatusName = (NSString*)CURTAIN_OPEN_NAME;
    }
    else if ( NSOrderedSame == [status compare:FUNCTION_NAME_CLOSE_CURTAIN options:NSLiteralSearch range:NSMakeRange(0, [FUNCTION_NAME_CLOSE_CURTAIN length])] )
    {
        _strCurtainStatusName = (NSString*)CURTAIN_CLOSE_NAME;
    }
    else if ( NSOrderedSame == [status compare:FUNCTION_NAME_STOP_CURTAIN options:NSLiteralSearch range:NSMakeRange(0, [FUNCTION_NAME_STOP_CURTAIN length])] )
    {
        _strCurtainStatusName = (NSString*)CURTAIN_STOP_NAME;
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
