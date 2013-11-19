//
//  AppDelegate.m
//  qicheng
//
//  Created by tony on 13-11-11.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "AppDelegate.h"
#import "CLoginInfo.h"

@implementation AppDelegate

@synthesize height  = _height;
@synthesize readData= _readData;
@synthesize width   = _width;


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
        NSLog(@"@%",[_socket isConnected]);
        [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
       // [_socket writeData:[@"123" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0 ];
        
        
    }
   //
    [_socket writeData:[@"$011234s#" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:10 tag:0];
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    [_socket release];
    _socket = nil;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    NSLog(@"connected!!!");
    [_socket readDataWithTimeout:-1 tag:0];
    
  //  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
};

- (void)onTimer
{
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
   // [_socket readDataWithTimeout:-1 tag:0];
}

- (void)didReceiveData:(NSMutableData *)data
{
    NSString *msg = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    
    NSLog(@"%s %d,receive msg = %@",__FUNCTION__,__LINE__,msg);
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"__FUNCTION__:%s,__LINE__:%d",__FUNCTION__,__LINE__);
    [[AppDelegate shareAppDelegate] didReceiveData:[AppDelegate shareAppDelegate].readData];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    
    NSLog(@"%s %d,msg = %@",__FUNCTION__,__LINE__,msg);
    

    BOOL bWait2Read = YES;
    if ( NSOrderedSame == [msg compare:@"!" options:NSLiteralSearch range:NSMakeRange(0,1)])
    {
        if ( NSOrderedSame == [msg compare:[CLoginInfo shareLoginInfo].loginModuleIdx options:NSNumericSearch range:NSMakeRange(1, 2)])
        {
            bWait2Read = NO;
            NSString *size = [msg substringWithRange:NSMakeRange(3, 2)];
            
            
            NSUInteger dataLength = strtoul([size UTF8String],0,16);
            NSLog(@"data size:%d",dataLength);

            NSUInteger totalLength = dataLength + 3 + 2 + 1;
            NSUInteger leftLength = totalLength - [data length];

            //NSMutableData* allData = [NSMutableData dataWithLength:totalLength];
            //[allData appendData:data];

            [AppDelegate shareAppDelegate].readData = [NSMutableData initWithLength:totalLength];
            [[AppDelegate shareAppDelegate].readData appendData:data];
            [_socket readDataToLength:leftLength withTimeout:-1 buffer:[AppDelegate shareAppDelegate].readData bufferOffset:[data length] tag:0];
            // NSData *szData = [size dataUsingEncoding:NSASCIIStringEncoding];
            // Byte * szBytes = (Byte *)[szData bytes];
            // int total = 0;
            // for (int i = 0; i != [szData length]; ++i)
            // {
            //     switch ( szBytes[i] )
            //     {
            //         case 'f':
            //             total += 15 * pow(16.0, [szData length] - i - 1);
            //             break;
                        
            //         default:
            //             break;
            //     }
            // }
            
        }
    }
    if ( bWait2Read )
    {
        [_socket readDataWithTimeout:-1 tag:0];
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    _bConnected = NO;
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
    _loginViewController = [[LoginViewController alloc] init];
    [self.window addSubview:_loginViewController.view];
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

@end
