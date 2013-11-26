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

@synthesize height  = _height;
@synthesize readData= _readData;
@synthesize width   = _width;
@synthesize functionViewController = _functionViewController;
@synthesize loginViewController = _loginViewController;
@synthesize mainUIViewController = _mainUIViewController;
@synthesize recvTailSet = _recvTailSet;
+(AppDelegate*) shareAppDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

-(BOOL)onTapLogin:(NSString *)loginIp psw:(NSString *)loginPassWord
{
    NSLog(@"ip:%@%@",loginIp,loginPassWord);
    if ( ! _socket )
    {
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *error;
       // [_socket connectToHost:@"192.168.1.254" withTimeout:2 onPort:50000 error:&error];
        
        [_socket connectToHost:@"192.168.1.254" onPort:50000 withTimeout:2 error:&error];

        
        _bConnected = [_socket isConnected];
       // NSLog(@"@%",[_socket isConnected]);
        [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
       // [_socket writeData:[@"123" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0 ];
        
        
    }
   //
   // [_socket writeData:[@"$011234s#" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:10 tag:0];
   // [_socket writeData:[@"$011234a00#" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:10 tag:0];
   // [_socket writeData:[@"$011234b00#" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:10 tag:0];
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    
}

- (void)didLoginSuccess
{
    if ( ! _mainUIViewController )
    {
        _mainUIViewController = [[MainUIViewController alloc] init];
    }
    //[self presentModalViewController:_mainUIViewController animate:YES];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"%s L:%d connected!!!",__FUNCTION__,__LINE__);
    [_socket readDataWithTimeout:-1 tag:0];
    
    //[[AppDelegate shareAppDelegate] didLoginSuccess];
    [[AppDelegate shareAppDelegate].loginViewController didLoginSuccess];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(queryAllAlarmCount) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(queryAlarmIsOpen) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.4 target:self selector:@selector(querySysDateTime) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.6 target:self selector:@selector(queryAllRelayStatus) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:5.8 target:self selector:@selector(queryAllTimerStatus) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(queryAllSensorStatus) userInfo:nil repeats:NO];
};

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
   // [_socket readDataWithTimeout:-1 tag:0];
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
            assert(false);
            break;
        case FUNCTION_INDEX_INCORRECT_PASSWORD:
            assert(false);
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
                //01
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

                
                }
                else
                {
                    assert(false);
                }
            }
            break;
        case FUNCTION_INDEX_QUERY_ALARM_IS_OPEN:
            {
                if ( LENGTH_QUERY_ALARM_IS_OPEN == [msg length] )
                {
                    
                    NSUInteger value = strtoul([[msg substringWithRange:NSMakeRange(0,LENGTH_QUERY_ALARM_IS_OPEN)] UTF8String],0,16);   
                    if ( value > 0 )
                    {
                        NSLog(@"alarm is opened");
                    }                    
                    else
                    {
                        NSLog(@"alarm is closed"); 
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
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALARM_IS_OPEN data:nil];
}

- (void)querySysDateTime
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_SYS_DATETIME data:nil];
}

- (void)queryAllRelayStatus
{
    [self sendDataWithFunctionName:FUNCTION_NAME_QUERY_ALL_RELAY_STATUS data:nil];
}

- (void)queryAllAlarmCount
{
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
    NSUInteger totalLength  = [PROTOCOL_SEND_HEAD length] + LENGTH_MODULE_ADDR + [[CLoginInfo shareLoginInfo].loginPasswod length]
                            + LENGTH_FUNCTION_NAME + dataLength + [RPOTOCOL_SEND_TAIL length];
    NSMutableData *prepareData = [NSMutableData dataWithCapacity:totalLength];
    [prepareData appendData:[PROTOCOL_SEND_HEAD dataUsingEncoding:NSASCIIStringEncoding]];
    [prepareData appendData:[[CLoginInfo shareLoginInfo].loginModuleIdx dataUsingEncoding:NSASCIIStringEncoding]];
    [prepareData appendData:[[CLoginInfo shareLoginInfo].loginPasswod dataUsingEncoding:NSASCIIStringEncoding]];
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _width  = [[UIScreen mainScreen] bounds].size.width;
    _height = [[UIScreen mainScreen] bounds].size.height;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    //[[_loginViewController alloc] init];
    _recvTailSet = [NSCharacterSet characterSetWithCharactersInString:PROTOCOL_RECV_TAIL];
    _loginViewController = [[LoginViewController alloc] init];
    if ( [self.window respondsToSelector:@selector(setRootViewController:)] )
    {
        [self.window setRootViewController:_loginViewController];
    }
    else
    {
        [self.window addSubview:_loginViewController.view];
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
@end
