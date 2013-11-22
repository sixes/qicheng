//
//  CDeviceData.h
//  qicheng
//
//  Created by tony on 13-11-17.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDeviceData : NSObject
{
	NSString *_strSysDateTime;
	NSDate _sysDateTime;

	NSMutableArray _relayStatus;
	NSMutableArray _alarmCount;
	NSMutableArray _sensorStatus;
	BOOL _bAlarmOpen;

	NSUInteger relay7status;
    NSString *_strDomain;
    NSString *_strIp;
    NSString *_strModuleIdx;
    NSString *_strPassword;
    NSString *_strProt;
}

@property (nonatomic,retain) NSMutableArray relayStatus;
@property (nonatomic,retain) NSMutableArray alarmCount;
@property (nonatomic,retain) NSMutableArray sensorStatus;
@property (nonatomic,copy) NSString *originalSysDateTime;
@property (nonatomic,assign) NSDate sysDateTime;


@property (nonatomic,copy) NSString *loginDomain;
@property (nonatomic,copy) NSString *loginIp;
@property (nonatomic,copy) NSString *loginModuleIdx;
@property (nonatomic,copy) NSString *loginPasswod;
@property (nonatomic,copy) NSString *loginPort;

+ (CDeviceData *)shareDeviceData;
- (id)initWithRelayStatusCount:(NSUInteger) relayStatusCount alarmCount:(NSUInteger)aCount sensorStatusCount:(NSUInteger)ssCount;
@end
