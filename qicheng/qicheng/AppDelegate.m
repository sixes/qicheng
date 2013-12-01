//
//  AppDelegate.m
//  qicheng
//
//  Created by tony on 13-11-11.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginInfo.h"
#import "Config.h"
#import "MainUIViewController.h"
#import "DeviceData.h"

@implementation AppDelegate

@synthesize height      = _height;
@synthesize readData    = _readData;
@synthesize width       = _width;
@synthesize functionViewController  = _functionViewController;
@synthesize loginViewController     = _loginViewController;
@synthesize mainUIViewController    = _mainUIViewController;
@synthesize navController           = _navController;
@synthesize sceneViewController     = _sceneViewController;
@synthesize settingViewController   = _settingViewController;
@synthesize timerViewController     = _timerViewController;

@synthesize recvTailSet = _recvTailSet;
+(AppDelegate*) shareAppDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( viewController != _settingViewController && viewController != _timerViewController )
    {
        NSLog(@"hide bar");
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
}
-(BOOL)onTapLogin:(NSString *)loginIp psw:(NSString *)loginPassWord port:(NSString*)port moduleIdx:(NSString*)idx
{
    NSLog(@"ip:%@ pwd:%@ f:%s l:%d",loginIp,loginPassWord,__FUNCTION__,__LINE__);
    if ( ! _socket )
    {
        [[CLoginInfo shareLoginInfo] setLoginPassword:loginPassWord];
        [[CLoginInfo shareLoginInfo] setLoginModuleIdx:idx];
        [[CLoginInfo shareLoginInfo] setLoginIp:loginIp];
        [[CLoginInfo shareLoginInfo] setLoginPort:port];
        
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *error;
       // [_socket connectToHost:@"192.168.1.254" withTimeout:2 onPort:50000 error:&error];
        
        [_socket connectToHost:loginIp onPort:[port intValue] withTimeout:2 error:&error];
        [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    NSString *errDesp;
    switch ( err.code ) {
        case 2:
        {
            errDesp = @"连接超时";
       }
        break;
            
        default:
            errDesp = [err localizedDescription];
            break;
    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"连接已断开"
                                                    message:errDesp
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)didLoginSuccess
{
//    if ( ! _mainUIViewController )
//    {
//        _mainUIViewController = [[MainUIViewController alloc] init];
//    }
    //[self presentModalViewController:_mainUIViewController animate:YES];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"%s L:%d connected!!!",__FUNCTION__,__LINE__);
    if ( NO == [_socket isConnected] )
    {
        //assert(false);
    }
    [_socket readDataWithTimeout:-1 tag:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:(id)[CLoginInfo shareLoginInfo].loginIp forKey:(NSString*)USER_DEFAULT_KEY_LOGIN_IP];
    [[NSUserDefaults standardUserDefaults] setObject:(id)[CLoginInfo shareLoginInfo].loginPort forKey:(NSString*)USER_DEFAULT_KEY_LOGIN_PORT];
    [[NSUserDefaults standardUserDefaults] setObject:(id)[CLoginInfo shareLoginInfo].loginModuleIdx forKey:(NSString*)USER_DEFAULT_KEY_LOGIN_MODULEINDEX];
    [[NSUserDefaults standardUserDefaults] setObject:(id)[CLoginInfo shareLoginInfo].loginPassword forKey:(NSString*)USER_DEFAULT_KEY_LOGIN_PASSWORD];
    
    [[NSUserDefaults standardUserDefaults] setObject:(id)@"thisone" forKey:@"test1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[[AppDelegate shareAppDelegate] didLoginSuccess];
    
    
    //这里登录后的6个必查状态的发送请求，现在间隔必须在1秒多以上，不然设备不会返回数据
    //用tcp & upd debug查看过数据，发送的6个数据都可以正确地接收到。
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(queryAllAlarmCount) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(queryAlarmIsOpen) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.4 target:self selector:@selector(querySysDateTime) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.6 target:self selector:@selector(queryAllRelayStatus) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:5.8 target:self selector:@selector(queryAllTimerStatus) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(queryAllSensorStatus) userInfo:nil repeats:NO];
    
    [[AppDelegate shareAppDelegate].loginViewController didLoginSuccess];
   // [_navController popToRootViewControllerAnimated:YES];
};

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)didReceiveData:(NSMutableData *)data
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSUInteger functionNameIdx = [PROTOCOL_RECV_HEAD length] + LENGTH_MODULE_ADDR + LENGTH_DATA_LENGTH;
    if ( functionNameIdx >= [msg length] )
    {
        assert(false);
    }
    NSString *functionName = [msg substringWithRange:NSMakeRange(functionNameIdx, LENGTH_FUNCTION_NAME)];
    if ( functionNameIdx + 1 >= [msg length] )
    {
        assert(false);
    }
    NSString *realData = [msg substringWithRange:NSMakeRange(functionNameIdx + 1, [msg length] - functionNameIdx - 1 - [PROTOCOL_RECV_TAIL length])];
    
    [msg release];
    [self didReceiveDataWithFunctionName:functionName data:realData];
}

- (void)didReceiveDataWithFunctionName:(NSString *)name data:(NSString *)msg
{
    NSLog(@"f:%s,L:%d,functionName:%@,data:%@",__FUNCTION__,__LINE__,name,msg);
    
    if ( [name length] < 1 )
    {
        assert(false);
        return ;
    }
    //这里解密...to be done
    const char * fName = [name UTF8String];
    switch ( fName[0] )
    {
        case FUNCTION_INDEX_INCORRECT_INSTRUCTION:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                            message:@"指令错误"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
            break;
        case FUNCTION_INDEX_INCORRECT_PASSWORD:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                            message:@"密码错误,请重新登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
           // [_socket setDelegate:Nil];
            [_socket disconnect];
           // [_socket release];
           // [self.navController pushViewController:self.loginViewController animated:YES];
        }
            break;
        case FUNCTION_INDEX_QUERY_SYS_DATETIME:
            {
                //0d0a10 0a1703 03
                if ( LENGTH_QUERY_SYS_DATETIME == [msg length] )
                {
                    NSUInteger year     = strtoul([[msg substringWithRange:NSMakeRange(0,2)] UTF8String],0,16);
                    NSUInteger month    = strtoul([[msg substringWithRange:NSMakeRange(2,2)] UTF8String],0,16);
                    NSUInteger day      = strtoul([[msg substringWithRange:NSMakeRange(4,2)] UTF8String],0,16);

                    NSUInteger hour     = strtoul([[msg substringWithRange:NSMakeRange(6,2)] UTF8String],0,16);
                    NSUInteger min      = strtoul([[msg substringWithRange:NSMakeRange(8,2)] UTF8String],0,16);
                    NSUInteger sec      = strtoul([[msg substringWithRange:NSMakeRange(10,2)] UTF8String],0,16);
                    //最后两位表示星期几,忽略
               
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat: @"yy-MM-dd HH:mm:ss"]; 

                    NSString *strDate = [NSString stringWithFormat:@"%2d-%2d-%2d %2d:%2d:%2d",year,month,day,hour,min,sec];
                    NSDate *destDate= [dateFormatter dateFromString:strDate];

                    NSLog(@"device date:%@",[dateFormatter stringFromDate:destDate]);    
                    [dateFormatter release];
                }
                else
                {
                    assert(false);
                }
            }
            break;
        case FUNCTION_INDEX_QUERY_ALL_RELAY_STATUS:
            {
                if ( LENGTH_QUERY_ALL_RELAY_STATUS == [msg length] )
                {
                    NSUInteger data = strtoul([[msg substringWithRange:NSMakeRange(0,LENGTH_QUERY_ALL_RELAY_STATUS)] UTF8String],0,16);
                    NSUInteger relay7status = data & ( 1 << 7 );
                    NSUInteger relay6status = data & ( 1 << 6 );
                    NSUInteger relay5status = data & ( 1 << 5 );
                    NSUInteger relay4status = data & ( 1 << 4 );
                    NSUInteger relay3status = data & ( 1 << 3 );
                    NSUInteger relay2status = data & ( 1 << 2 );
                    NSUInteger relay1status = data & ( 1 << 1 );
                    NSUInteger relay0status = data & ( 1 );

                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay0status] atIndexedSubscript:0];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay1status] atIndexedSubscript:1];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay2status] atIndexedSubscript:2];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay3status] atIndexedSubscript:3];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay4status] atIndexedSubscript:4];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay5status] atIndexedSubscript:5];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay6status] atIndexedSubscript:6];
                    [[CDeviceData shareDeviceData].relayStatus setObject:(id)[NSNumber numberWithUnsignedLong:relay7status] atIndexedSubscript:7];
                }
                else
                {
                    assert(false);
                }
            }
            break;
        case FUNCTION_INDEX_QUERY_ALL_ALARM_COUNT:
            {
                //0000ffff0000ffff
                if ( LENGTH_QUERY_ALL_ALARM_COUNT == [msg length] )
                {
                    
                    NSUInteger alarm0count = strtoul([[msg substringWithRange:NSMakeRange(0,4)] UTF8String],0,16);   
                    NSUInteger alarm1count = strtoul([[msg substringWithRange:NSMakeRange(4,4)] UTF8String],0,16);
                    NSUInteger alarm2count = strtoul([[msg substringWithRange:NSMakeRange(8,4)] UTF8String],0,16);
                    NSUInteger alarm3count = strtoul([[msg substringWithRange:NSMakeRange(12,4)] UTF8String],0,16);

                    [[CDeviceData shareDeviceData].alarmCount setObject:(id)[NSNumber numberWithUnsignedLong:alarm0count] atIndexedSubscript:0];
                    [[CDeviceData shareDeviceData].alarmCount setObject:(id)[NSNumber numberWithUnsignedLong:alarm1count] atIndexedSubscript:1];
                    [[CDeviceData shareDeviceData].alarmCount setObject:(id)[NSNumber numberWithUnsignedLong:alarm2count] atIndexedSubscript:2];
                    [[CDeviceData shareDeviceData].alarmCount setObject:(id)[NSNumber numberWithUnsignedLong:alarm3count] atIndexedSubscript:3];
                }
                else
                {
                    assert(false);
                }
            }
            break;
        case FUNCTION_INDEX_QUERY_ALARM_IS_OPEN:
            {
                //设备故障,未测试
                if ( LENGTH_QUERY_ALARM_IS_OPEN == [msg length] )
                {
                    
                    NSUInteger value = strtoul([[msg substringWithRange:NSMakeRange(0,LENGTH_QUERY_ALARM_IS_OPEN)] UTF8String],0,16);   
                    if ( value > 0 )
                    {
                        NSLog(@"alarm is opened");
                        [CDeviceData shareDeviceData].bAlarmOpen = YES;
                    }                    
                    else
                    {
                        NSLog(@"alarm is closed");
                        [CDeviceData shareDeviceData].bAlarmOpen = NO;
                    }
                    
                }
                else
                {
                    assert(false);
                }                
            }
            break;   
        case FUNCTION_INDEX_QUERY_ALL_TIMER_STATUS:
            {
                //assert(false);
                NSLog(@"need to impl FUNCTION_NAME_QUERY_ALL_TIMER_STATUS");
                if ( LENGTH_QUERY_ALL_TIMER_STATUS == [msg length] )
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"HH:mm";
                    for (int i = 0; i != 9; ++i)
                    {
                        //该通道定时器状态是否开启
                        int openValue = 0;
                        if ( [[msg substringWithRange:NSMakeRange(0 + 26 * i, 1)] intValue] > 0 )
                        {
                            openValue = 1;
                        }
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setValue:[NSNumber numberWithUnsignedInt:openValue] forKey:(id)@"isOpenTimer"];
                        
                        NSMutableArray *openDeviceArray = [[NSMutableArray alloc] initWithCapacity:5];
                        for (int j = 0 ; j != 5; ++j)
                        {
                            int openTheDevice = 0;
                            if ( [[msg substringWithRange:NSMakeRange(1 + 26 * i + j, 1)] intValue] > 0 )
                            {
                                openTheDevice = 1;
                            }
                    
                            [openDeviceArray setObject:[NSNumber numberWithUnsignedInt:openTheDevice] atIndexedSubscript:j];
                        }
                        [dict setValue:openDeviceArray forKey:@"isOpenDevice"];
                        
                        NSMutableArray *dateArray = [[NSMutableArray alloc] initWithCapacity:5];
                        for (int k = 0; k != 5; ++k)
                        {
                            //NSUInteger hour = strtoul([[msg substringWithRange:NSMakeRange(2 + 26 * i + k * 5,2)] UTF8String],0,16);
                            //NSUInteger min = strtoul([[msg substringWithRange:NSMakeRange(2 + 26 * i + k * 5 + 2,2)] UTF8String],0,16);
                            NSString *strH = [msg substringWithRange:NSMakeRange(2 + 26 * i + k * 5,2)];
                            NSString *strM = [msg substringWithRange:NSMakeRange(2 + 26 * i + k * 5 + 2,2)];
                            NSString *strDate = [NSString stringWithFormat:@"%@:%@",strH,strM];
                            [dateArray setObject:strDate atIndexedSubscript:k];
                        }
                        [dict setValue:dateArray forKey:@"dateArr"];
                        
                        [[CDeviceData shareDeviceData].channelTimerStatus setObject:dict atIndexedSubscript:i];
                        //[[CDeviceData shareDeviceData].timerDict setValue:[NSNumber numberWithUnsignedChar:openValue] forKey:@"isOpen"];
                    }
                }
                else
                {
                    assert(false);
                }
            }
            break; 
        case FUNCTION_INDEX_QUERY_ALL_SENSOR_STATUS:
            {
                if ( LENGTH_QUERY_ALL_SENSOR_STATUS == [msg length] )
                {
                    
                    NSUInteger value = strtoul([[msg substringWithRange:NSMakeRange(0,LENGTH_QUERY_ALL_SENSOR_STATUS)] UTF8String],0,16);   
                    NSUInteger sensor0status = value & ( 1 );
                    NSUInteger sensor1status = value & ( 1 << 2 );
                    NSUInteger sensor2status = value & ( 1 << 3 );
                    NSUInteger sensor3status = value & ( 1 << 4 );
                    
                    [[CDeviceData shareDeviceData].sensorStatus setObject:(id)[NSNumber numberWithUnsignedLong:sensor0status] atIndexedSubscript:0];
                    [[CDeviceData shareDeviceData].sensorStatus setObject:(id)[NSNumber numberWithUnsignedLong:sensor1status] atIndexedSubscript:1];
                    [[CDeviceData shareDeviceData].sensorStatus setObject:(id)[NSNumber numberWithUnsignedLong:sensor2status] atIndexedSubscript:2];
                    [[CDeviceData shareDeviceData].sensorStatus setObject:(id)[NSNumber numberWithUnsignedLong:sensor3status] atIndexedSubscript:3];
                }
                else
                {
                    assert(false);
                }
            }
            break;
        case FUNCTION_INDEX_OPEN_CURTAIN:
            {
                [self didOpenCurtain];
            }   
            break; 
        case FUNCTION_INDEX_STOP_CURTAIN:
            {
                [self didStopCurtain];
            }   
            break; 
        case FUNCTION_INDEX_CLOSE_CURTAIN:
            {
                [self didCloseCurtain];
            }   
            break;
        case FUNCTION_INDEX_OPEN_RELAY:
        {
            [self didOpenRelayAtIndex:[msg integerValue]];
        }
            break;
        case FUNCTION_INDEX_CLOSE_RELAY:
        {
            [self didCloseRelayAtIndex:[msg integerValue]];
        }
            break;
        case FUNCTION_INDEX_QUERY_TEMPERATURE:
        {
            if ( LENGTH_QUERY_TEMPERATURE == [msg length] )
            {
                int factor = 1;
                if ( NSOrderedSame == [msg compare:@"-" options:NSLiteralSearch range:NSMakeRange(0, [@"-" length])] )
                {
                    factor = -1;
                }
                NSUInteger value = strtoul([[msg substringWithRange:NSMakeRange(1,2)] UTF8String],0,16);
                [CDeviceData shareDeviceData].insideTemp = [NSNumber numberWithInt:factor * value];
                
                factor = 1;
                if ( NSOrderedSame == [msg compare:@"-" options:NSLiteralSearch range:NSMakeRange(3, [@"-" length])] )
                {
                    factor = -1;
                }
                value = strtoul([[msg substringWithRange:NSMakeRange(4,2)] UTF8String],0,16);
                [CDeviceData shareDeviceData].outsideTemp = [NSNumber numberWithInt:factor * value];
                
                [self didUpdateTemp];
            }
            else
            {
                assert(false);
            }
        }
            break;
        case FUNCTION_INDEX_ENABLE_ALARM:
        {
            [CDeviceData shareDeviceData].bAlarmOpen = YES;
            [self didEnableAlarm];
        }
            break;
        case FUNCTION_INDEX_DISABLE_ALARM:
        {
            [CDeviceData shareDeviceData].bAlarmOpen = NO;
            [self didDisableAlarm];
        }
            break;
        case FUNCTION_INDEX_SET_5TIMER:
        {
            [self didSet5Timer];
        }
            break;
        default:
            break;
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    //NSLog(@"__FUNCTION__:%s,__LINE__:%d",__FUNCTION__,__LINE__);
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"#"];
    //1. 完整的一帧 2、完整的多帧 3、几个帆加片断
    if ( NSOrderedSame == [msg compare:PROTOCOL_RECV_HEAD options:NSLiteralSearch range:NSMakeRange(0, [PROTOCOL_RECV_HEAD length])] )
    {
        NSRange rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(0, [msg length])];
        NSUInteger idx = 0;
        for ( ; NSNotFound != rret.location; )
        {
            NSData *oneFrame = [[msg substringWithRange:NSMakeRange(idx, rret.location + 1 - idx)] dataUsingEncoding:NSASCIIStringEncoding];
            [[AppDelegate shareAppDelegate] didReceiveData:oneFrame];
            
            idx += rret.location + 1;
            
            if ( idx < [msg length] )
            {
                rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(idx, [msg length] - idx)];
            }
            else
            {
                break;
            }
        }
        if ( idx < [msg length] )
        {
            rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(idx, [msg length] - idx)];
            [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
            NSData *leftData = [[msg substringWithRange:NSMakeRange(idx, [msg length] - idx)] dataUsingEncoding:NSASCIIStringEncoding];
            [[AppDelegate shareAppDelegate].readData appendData:leftData];
        }
    }
    else
    {
        NSRange rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(0, [msg length])];
        NSUInteger idx = 0;
        if ( NSNotFound == rret.location )
        {
            if ( [AppDelegate shareAppDelegate].readData == nil )
            {
                [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
            }
            [[AppDelegate shareAppDelegate].readData appendData:data];
        }
        else
        {
            for ( ; NSNotFound != rret.location; )
            {
                NSData *oneFrame = [[msg substringWithRange:NSMakeRange(idx, rret.location + 1 - idx)] dataUsingEncoding:NSASCIIStringEncoding];
                if ( [AppDelegate shareAppDelegate].readData == nil )
                {
                    [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
                }
                [[AppDelegate shareAppDelegate].readData appendData:oneFrame];
                [[AppDelegate shareAppDelegate] didReceiveData:[AppDelegate shareAppDelegate].readData];
                [[AppDelegate shareAppDelegate].readData release];
                [AppDelegate shareAppDelegate].readData = nil;
                idx += rret.location + 1;
                
                if ( idx < [msg length] )
                {
                    rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(idx, [msg length] - idx)];
                }
                else
                {
                    break;
                }
            }
            if ( idx < [msg length] )
            {
                rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(idx, [msg length] - idx)];
                [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
                NSData *leftData = [[msg substringWithRange:NSMakeRange(idx, [msg length] - idx)] dataUsingEncoding:NSASCIIStringEncoding];
                [[AppDelegate shareAppDelegate].readData appendData:leftData];
            }
        }

    }
    
    //waiting for next package
    [_socket readDataWithTimeout:-1 tag:0];
    
    
    
    // return ;
    
    // BOOL bNextFrame = NO;
    // BOOL bFrameStart = NO;
    // if ( NSOrderedSame == [msg compare:PROTOCOL_RECV_HEAD options:NSLiteralSearch range:NSMakeRange(0,[PROTOCOL_RECV_HEAD length])] )
    // {
    //     bFrameStart = YES;
    //     if ( NSOrderedSame == [msg compare:PROTOCOL_RECV_TAIL options:NSLiteralSearch range:NSMakeRange([data length] - [PROTOCOL_RECV_TAIL length], [PROTOCOL_RECV_TAIL length])] )
    //     {
    //         bNextFrame = YES; 
    //         //读完数据了
    //         //WARNING!!! 需要判断是否接收了两帧以上的数据
            
    //         NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"#"];
    //         NSRange rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(0, [msg length])];
    //         NSUInteger idx = 0;
    //         for ( ; rret.location != NSNotFound; )
    //         {
    //             if ( 5 == idx )
    //             {
    //                 assert(false);
    //             }
    //             NSString *wholeFrame = [msg substringWithRange:NSMakeRange(idx, rret.location + 1)];
    //             idx += rret.location + 1;
    //             NSData *wholdData = [wholeFrame dataUsingEncoding:NSASCIIStringEncoding];
    //             [[AppDelegate shareAppDelegate] didReceiveData:wholdData];
                
    //             if ( idx < [msg length] )
    //             {
    //                 rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(idx, [msg length] - idx)];
    //             }
    //             else
    //             {
    //                 break;
    //             }
    //         }
    //        // [[AppDelegate shareAppDelegate] didReceiveData:data];
    //         if ( idx < [msg length] )
    //         {
    //             NSData *leftData = [[msg substringWithRange:NSMakeRange(idx, [msg length] - idx)] dataUsingEncoding:NSASCIIStringEncoding];
    //             if ( [AppDelegate shareAppDelegate].readData == nil )
    //             {
    //                 [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
    //             }
    //             [[AppDelegate shareAppDelegate].readData appendData:leftData];
    //         }
    //     }
    // }

    // if ( NO == bNextFrame )
    // {
    //      if ( YES == bFrameStart )
    //     {
    //         [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc]initWithCapacity:[msg length] * 2];
    //     }   
        
    //     if ( NSOrderedSame == [msg compare:PROTOCOL_RECV_TAIL options:NSLiteralSearch range:NSMakeRange([data length] - [PROTOCOL_RECV_TAIL length], [PROTOCOL_RECV_TAIL length])] )
    //     {
    //          //读完数据了
            
    //         NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"#"];
    //         NSRange rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(0, [msg length])];
    //         NSUInteger idx = 0;
    //         for ( ; rret.location != NSNotFound; )
    //         {
    //             if ( 5 == idx )
    //             {
    //                 assert(false);
    //             }
    //             NSString *wholeFrame = [msg substringWithRange:NSMakeRange(idx, rret.location + 1)];
    //             idx += rret.location + 1;
    //             NSData *wholdData = [wholeFrame dataUsingEncoding:NSASCIIStringEncoding];
    //             if ( [AppDelegate shareAppDelegate].readData == nil )
    //             {
    //                 [AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
    //             }
    //             [[AppDelegate shareAppDelegate].readData appendData:wholdData];
    //             [[AppDelegate shareAppDelegate] didReceiveData:[AppDelegate shareAppDelegate].readData];
    //             [[AppDelegate shareAppDelegate].readData release];
    //             [AppDelegate shareAppDelegate].readData = nil;
    //             if ( idx < [msg length] )
    //             {
    //                 rret = [msg rangeOfCharacterFromSet:cSet options:NSLiteralSearch range:NSMakeRange(idx + 1, [msg length] - idx - 1)];
    //             }
    //             else
    //             {
    //                 break;
    //             }
    //         }
            
    //         //要把剩下的数据保存起来
    //         if ( idx < [msg length] )
    //         {
    //             NSData *leftData = [[msg substringWithRange:NSMakeRange(idx, [msg length] - idx)] dataUsingEncoding:NSASCIIStringEncoding];
    //             [[AppDelegate shareAppDelegate].readData appendData:leftData];
    //         }
            
    //        // [[AppDelegate shareAppDelegate] didReceiveData:[AppDelegate shareAppDelegate].readData];
    //        // [[AppDelegate shareAppDelegate].readData release];
    //     }    
    // }
    // [msg release];
    // //waiting for next package
    // [_socket readDataWithTimeout:-1 tag:0];
    // return ;

    // if ( NSOrderedSame == [msg compare:PROTOCOL_RECV_HEAD options:NSLiteralSearch range:NSMakeRange(0,[PROTOCOL_RECV_HEAD length])])
    // {
    //     if ( NSOrderedSame == [msg compare:[CLoginInfo shareLoginInfo].loginModuleIdx options:NSNumericSearch range:NSMakeRange(1, 2)])
    //     {
    //         if ( [msg length] < 5 )
    //         {
    //             assert(false);
    //             //[AppDelegate shareAppDelegate].readData = [[NSMutableData alloc] init];
    //             //[[AppDelegate shareAppDelegate].readData appendData:data];
    //         }
    //         else
    //         {
    //             NSString *size = [msg substringWithRange:NSMakeRange(3, 2)];
    //             NSUInteger dataLength = strtoul([size UTF8String],0,16);
    //             NSUInteger totalLength = dataLength + 3 + 2 + 1;
    //             NSUInteger leftLength = totalLength - [data length];
                
    //             [AppDelegate shareAppDelegate].readData = [[[NSMutableData alloc]initWithCapacity:totalLength] autorelease];
    //             [[AppDelegate shareAppDelegate].readData appendData:data];
                
    //             if ( leftLength > 0 )
    //             {
    //                 [_socket readDataToLength:leftLength withTimeout:-1 buffer:[AppDelegate shareAppDelegate].readData bufferOffset:[data length] tag:0];
    //             }
    //             else
    //             {
    //                 //读完数据了
    //                 [[AppDelegate shareAppDelegate] didReceiveData:[AppDelegate shareAppDelegate].readData];
                    
    //                 //waiting for next package
    //                 [_socket readDataWithTimeout:-1 tag:0];
    //             }
    //         }
    //     }
    // }
    // else if ( NSOrderedSame == [msg compare:PROTOCOL_RECV_TAIL options:NSLiteralSearch range:NSMakeRange([data length] - 1, [PROTOCOL_RECV_TAIL length])] )
    // {
    //     //读完数据了
    //     [[AppDelegate shareAppDelegate] didReceiveData:[AppDelegate shareAppDelegate].readData];
        
    //     //waiting for next package
    //     [_socket readDataWithTimeout:-1 tag:0];
    // }
    // else
    // {
    //     //有可能跑到这里吗？如果数据长的话，可能会多次才能读完
    //     assert(false);
    //     [_socket readDataWithTimeout:-1 tag:0];
    // }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    
    _bConnected = NO;
    [_socket release];
    _socket = nil;

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"连接已断开"
                                                        message:@"点确定重新登录"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    //[alert show];
    [alert release];
    if ( nil == [AppDelegate shareAppDelegate].loginViewController )
    {
        [AppDelegate shareAppDelegate].loginViewController = [[LoginViewController alloc] init];
    }
    if ( YES == [CLoginInfo shareLoginInfo].bLogined )
    {
        [_navController pushViewController:[AppDelegate shareAppDelegate].loginViewController animated:YES];
    }
    

    
    [CLoginInfo shareLoginInfo].bLogined = NO;
    NSLog(@"bingoooooooo");
}

- (void)openCurtain
{
    [self sendDataWithFunctionName:FUNCTION_NAME_OPEN_CURTAIN data:nil];
}

- (void)stopCurtain
{
    [self sendDataWithFunctionName:FUNCTION_NAME_STOP_CURTAIN data:nil];
}

- (void)closeCurtain
{
    [self sendDataWithFunctionName:FUNCTION_NAME_CLOSE_CURTAIN data:nil];
}

- (void)queryAllSensorStatus
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALL_SENSOR_STATUS data:nil];
}

- (void)queryAllTimerStatus
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALL_TIMER_STATUS data:nil];
}

- (void)queryAlarmIsOpen
{
   // NSLog(@"%@ %s",[NSDate description],__FUNCTION__);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];      //毫秒
    NSLog(@"Date%@ %s", [dateFormatter stringFromDate:[NSDate date]],__FUNCTION__);
    
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALARM_IS_OPEN data:nil];
}

- (void)querySysDateTime
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_SYS_DATETIME data:nil];
}

- (void)queryTemperature
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_TEMPERATURE data:nil];
}

- (void)queryAllRelayStatus
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALL_RELAY_STATUS data:nil];
}

- (void)queryAllAlarmCount
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];      //毫秒
    NSLog(@"Date%@ %s", [dateFormatter stringFromDate:[NSDate date]],__FUNCTION__);
    
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALL_ALARM_COUNT data:nil];
}

- (void)sendDataWithFunctionName:(NSString *)name data:(NSData *)aData
{
    if ( [name length] < 1 )
    {
        assert(false);
        return;
    }
    
    NSUInteger dataLength   = [aData length];
    NSUInteger totalLength  = [PROTOCOL_SEND_HEAD length] + LENGTH_MODULE_ADDR + [[CLoginInfo shareLoginInfo].loginPassword length]
                            + LENGTH_FUNCTION_NAME + dataLength + [RPOTOCOL_SEND_TAIL length];
    NSMutableData *prepareData = [NSMutableData dataWithCapacity:totalLength];
    [prepareData appendData:[PROTOCOL_SEND_HEAD dataUsingEncoding:NSASCIIStringEncoding]];
    [prepareData appendData:[[CLoginInfo shareLoginInfo].loginModuleIdx dataUsingEncoding:NSASCIIStringEncoding]];
    [prepareData appendData:[[CLoginInfo shareLoginInfo].loginPassword dataUsingEncoding:NSASCIIStringEncoding]];
    [prepareData appendData:[name dataUsingEncoding:NSASCIIStringEncoding]];
    [prepareData appendData:aData];
    [prepareData appendData:[RPOTOCOL_SEND_TAIL dataUsingEncoding:NSASCIIStringEncoding]];
    [self prepareSendData:prepareData withTimeout:10 tag:0];
}

- (void)prepareSendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    //这里可以加密...to be done
    //NSString *msg = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //NSLog(@"%s,line:%d,data:%@",__FUNCTION__,__LINE__,msg);
    //[_socket writeData:[@"$011234s#" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:timeout tag:tag];
    [_socket writeData:data withTimeout:timeout tag:tag];
    //[msg release];
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    assert(false);
    return 10.0;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ( ver < 4.0 )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误信息"
                                                        message:@"该应用不支持4.0以下版本"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        exit(0);
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _width  = [[UIScreen mainScreen] bounds].size.width;
    _height = [[UIScreen mainScreen] bounds].size.height;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    //_recvTailSet = [NSCharacterSet characterSetWithCharactersInString:PROTOCOL_RECV_TAIL];

    NSString *strIp     = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString*)USER_DEFAULT_KEY_LOGIN_IP];
    NSString *strPort   = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString*)USER_DEFAULT_KEY_LOGIN_PORT];
    NSString *strPwd    = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString*)USER_DEFAULT_KEY_LOGIN_PASSWORD];
    NSString *strIdx    = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString*)USER_DEFAULT_KEY_LOGIN_MODULEINDEX];
    
    _mainUIViewController = [[MainUIViewController alloc] init];
    _navController = [[UINavigationController alloc] initWithRootViewController:_mainUIViewController];
    [_navController setToolbarHidden:YES];
    [_navController setNavigationBarHidden:YES];
    [_navController setDelegate:self];
    [self.window setRootViewController:_navController];

    _loginViewController = [[LoginViewController alloc] init];
    [_navController pushViewController:_loginViewController animated:NO];
    
    if ( [strIp length] > 0 && [strPort length] > 0 && [strPwd length] > 0 && [strIdx length] > 0 )
    {
        [self onTapLogin:strIp psw:strPwd port:strPort moduleIdx:strIdx];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ( NO == [_socket isConnected] )
    {
        [_socket release];
        _socket = nil;
        //[self onTapLogin:[CLoginInfo shareLoginInfo].loginIp psw:[CLoginInfo shareLoginInfo].loginPassword port:[CLoginInfo shareLoginInfo].loginPort moduleIdx:[CLoginInfo shareLoginInfo].loginModuleIdx];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didCloseCurtain
{
    [self.functionViewController didCloseCurtain];
}

- (void)didOpenCurtain
{
    [self.functionViewController didOpenCurtain];
}

- (void)didStopCurtain
{
    [self.functionViewController didStopCurtain];
}

- (void)openRelayAtIndex:(NSUInteger)index
{
    NSString *str = [NSString stringWithFormat:@"%2lu",(unsigned long)index];
    NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding];
    [self sendDataWithFunctionName:FUNCTION_NAME_OPEN_RELAY data:data];
}

- (void)didOpenRelayAtIndex:(NSInteger)index
{
    [self.functionViewController didOpenRelayAtIndex:index];
}

- (void)closeRelayAtIndex:(NSUInteger)index
{
    NSString *str = [NSString stringWithFormat:@"%2lu",(unsigned long)index];
    NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding];
    [self sendDataWithFunctionName:FUNCTION_NAME_CLOSE_RELAY data:data];
}

- (void)didCloseRelayAtIndex:(NSInteger)index
{
    [self.functionViewController didCloseRelayAtIndex:index];
}

- (void)didUpdateTemp
{
    [self.functionViewController didUpdateTemp];
}

- (void)enableAlarm
{
    [self sendDataWithFunctionName:FUNCTION_NAME_ENABLE_ALARM data:nil];
}

- (void)disableAlarm
{
    [self sendDataWithFunctionName:FUNCTION_NAME_DISABLE_ALARM data:nil];
}

- (void)didEnableAlarm
{
    [self.functionViewController didEnableAlarm];
}

- (void)didDisableAlarm
{
    [self.functionViewController didDisableAlarm];
}

- (void)set5TimerAtChannel:(NSUInteger)channel
{
    if ( channel > 7 )
    {
        assert(false);
        return;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSString *strChannel = [NSString stringWithFormat:@"%2lu",(unsigned long)channel];
    [data appendData:[strChannel dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSDictionary *dict = [[CDeviceData shareDeviceData].channelTimerStatus objectAtIndexedSubscript:channel];
    NSNumber *numIsOpen = [dict objectForKey:@"isOpenTimer"];
    NSString *strOpen = [NSString stringWithFormat:@"%2d",[numIsOpen intValue]];
    [data appendData:[strOpen dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSMutableArray *openDevice = [dict objectForKey:@"isOpenDevice"];
    NSMutableArray *date = [dict objectForKey:@"dateArr"];
    for (int i = 0 ; i != 5; ++i )
    {
        NSNumber *numOpen = [openDevice objectAtIndexedSubscript:i];
        NSString *strOpen = [NSString stringWithFormat:@"%2d",[numOpen intValue]];
        [data appendData:[strOpen dataUsingEncoding:NSASCIIStringEncoding]];
        
        NSString *strDate = [date objectAtIndexedSubscript:i];
        NSString *hour = [strDate substringWithRange:NSMakeRange(0, 2)];
        NSString *min = [strDate substringWithRange:NSMakeRange(3, 2)];
        NSString *hr16 = [self ToHex:[hour intValue]];
        NSString *min16 = [self ToHex:[min intValue]];
        [data appendData:[hr16 dataUsingEncoding:NSASCIIStringEncoding]];
        [data appendData:[min16 dataUsingEncoding:NSASCIIStringEncoding]];
    }
    [self sendDataWithFunctionName:FUNCTION_NAME_SET_5_TIMER data:data];
}

- (void)didSet5Timer
{
    
}

-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[NSString stringWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}



@end
