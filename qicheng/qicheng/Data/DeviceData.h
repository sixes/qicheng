//
//  CDeviceData.h
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const CURTAIN_OPEN_NAME = @"开启";
static NSString* const CURTAIN_STOP_NAME = @"关闭";
static NSString* const CURTAIN_CLOSE_NAME = @"停";

@interface CDeviceData : NSObject
{
	NSString *_strSysDateTime;
	NSDate *_sysDateTime;


	NSMutableArray *_alarmCount;
	NSMutableArray *_sensorName;
	NSMutableArray *_sensorStatus;
	NSMutableArray *_relayName;
	NSMutableArray *_relayStatus;
	
	BOOL _bAlarmOpen;
    NSNumber *_outsideTemp;
    NSNumber *_insideTemp;

	NSUInteger relay7status;
    NSString *_strCurtainStatus;
    NSString *_strCurtainStatusName;
    NSString *_strDomain;
    NSString *_strIp;
    NSString *_strModuleIdx;
    NSString *_strPassword;
    NSString *_strProt;
    
    //TIMER
    NSMutableArray *_channelTimerStatus;            //该通道定时器功能是否开启
    NSMutableArray *_channelOpenWhenTimerExpires;   //定时器到期后,是否开启设备
    NSMutableArray *_channelTimerDate;              //定时器定时
    
    NSMutableDictionary *_timerDict;
}

@property (nonatomic,assign) BOOL bAlarmOpen;
@property (nonatomic,retain) NSMutableDictionary *timerDict;
@property (nonatomic,retain) NSNumber *insideTemp;
@property (nonatomic,retain) NSNumber *outsideTemp;
@property (nonatomic,retain) NSMutableArray *channelTimerStatus;
@property (nonatomic,retain) NSMutableArray *channelOpenWhenTimerExpires;
@property (nonatomic,retain) NSMutableArray *channelTimerDate;
@property (nonatomic,retain) NSMutableArray *relayName;
@property (nonatomic,retain) NSMutableArray *relayStatus;
@property (nonatomic,retain) NSMutableArray *alarmCount;
@property (nonatomic,retain) NSMutableArray *sensorName;
@property (nonatomic,retain) NSMutableArray *sensorStatus;
@property (nonatomic,copy) NSString *curtainStatus;
@property (nonatomic,copy) NSString *originalSysDateTime;
@property (nonatomic,retain) NSDate *sysDateTime;


@property (nonatomic,copy) NSString *loginDomain;
@property (nonatomic,copy) NSString *loginIp;
@property (nonatomic,copy) NSString *loginModuleIdx;
@property (nonatomic,copy) NSString *loginPasswod;
@property (nonatomic,copy) NSString *loginPort;

+ (CDeviceData *)shareDeviceData;
- (id)initWithRelayStatusCount:(NSUInteger) relayStatusCount alarmCount:(NSUInteger)aCount sensorStatusCount:(NSUInteger)ssCount;

- (void)setCurtainStatus:(NSString*)status;
- (NSString*)getCurtainStatus;
@end
