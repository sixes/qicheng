//
//  FunctionViewController.m
//  qicheng
//
//  Created by tony on 13-11-24.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "FunctionViewController.h"
#import "AppDelegate.h"
#import "iCarousel.h"
#import "MenuItemView.h"
#import "DeviceData.h"
#import "Config.h"
@interface FunctionViewController ()

@end

@implementation FunctionViewController

@synthesize bFilpped = _bFlipped;
@synthesize carousel = _carousel;
@synthesize items = _items;
@synthesize curtainArray = _curtainArray;

- (void)loadView
{
    UIImage *bgImg = [UIImage imageNamed:@"bg_main_ui.jpg"];
    self.view = [[UIImageView alloc] initWithImage:bgImg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    [self.view setUserInteractionEnabled:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 40, 260, 300) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < 6; i++)
    {
        [_items addObject:[NSNumber numberWithInt:i]];
    }
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 310, 320, 220)];
   // _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = iCarouselTypeCoverFlow2;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [self.view addSubview:_carousel];

    _btnBack2Main   = [[UIButton alloc] init];
    _btnBack        = [[UIButton alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.curtainArray = [[NSMutableArray alloc] initWithCapacity:1];
    [self.curtainArray addObject:@"窗帘"];
    
    _currentIdx = 0;
    _bFlipped = NO;

    UIImage *back2MainImage = [UIImage imageNamed:@"home.png"];
    NSString *pressedPath = [[NSBundle mainBundle] pathForResource:@"home_pressed" ofType:@"png"];
    UIImage *back2MainImagePressed = [UIImage imageWithContentsOfFile:pressedPath];
    [_btnBack2Main setBackgroundImage:back2MainImage forState:UIControlStateNormal];
    [_btnBack2Main setBackgroundImage:back2MainImagePressed forState:UIControlStateHighlighted];
    [_btnBack2Main setFrame:CGRectMake(0,0,back2MainImage.size.width,back2MainImage.size.height)];
    [_btnBack2Main addTarget:self action:@selector(onTapBack2Main) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBack2Main];

    NSString *backNormal = [[NSBundle mainBundle] pathForResource:@"general_back_normal" ofType:@"png"];
    UIImage *backImage = [UIImage imageWithContentsOfFile:backNormal];
    NSString *backPressed = [[NSBundle mainBundle] pathForResource:@"general_back_pressed" ofType:@"png"];
    UIImage *backPressedImg = [UIImage imageWithContentsOfFile:backPressed];
    [_btnBack setBackgroundImage:backImage forState:UIControlStateNormal];
    [_btnBack setBackgroundImage:backPressedImg forState:UIControlStateHighlighted];
    [_btnBack setFrame:CGRectMake(0,0,backImage.size.width,backImage.size.height)];
    [_btnBack addTarget:self action:@selector(onTapBack) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack setHidden:YES];
    [self.view addSubview:_btnBack];
}

- (void)onTapBack2Main
{
    if ( self.bFilpped == NO )
    {
        NSLog(@"yes");
    }
    
    if ( ! [AppDelegate shareAppDelegate].mainUIViewController )
    {
        [AppDelegate shareAppDelegate].mainUIViewController = [[MainUIViewController alloc] init];
    }
    
    //[self dismissViewControllerAnimated:YES completion:Nil];
   // [self presentViewController:[AppDelegate shareAppDelegate].mainUIViewController animated:YES completion:nil];
    [[AppDelegate shareAppDelegate].navController popToRootViewControllerAnimated:YES];
}

- (void)onTapBack
{
    if ( YES == _bFlipped )
    {
        _bFlipped = NO;
        [_btnBack2Main setHidden:NO];
        [_btnBack setHidden:YES];
        if ( _curtainView )
        {
            [_curtainView removeFromSuperview];
            [_tableView setHidden:NO];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ( _currentIdx )
    {
        case 0:
        {
            return [self.curtainArray count];
        }
        break;
        case 1:
        {
            return [[CDeviceData shareDeviceData].relayStatus count];
        }
        break;
        case 2:
        {
            return [[CDeviceData shareDeviceData].sensorStatus count];
        }
        break;
        case 3:
        {
            return 1 + [[CDeviceData shareDeviceData].alarmCount count];
        }
        break;
        case 4:
        {
            return 1;
        }
        break;
        case 5:
        {
            return [[CDeviceData shareDeviceData].relayStatus count] + [self.curtainArray count];
        }
        break;
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const NSString *CellWithIdentifier = @"FunctionViewControllerTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString*)CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:(NSString*)CellWithIdentifier];
        switch ( _currentIdx )
        {
            case 5:
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            default:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
        }
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        sw.tag = [indexPath row];
        [sw addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        [sw release];
    }
    switch ( _currentIdx )
    {
        case 0:
        {
            if ( indexPath.row < [self.curtainArray count] )
            {
                cell.textLabel.text =  [self.curtainArray objectAtIndex:indexPath.row];
                cell.detailTextLabel.text = [[CDeviceData shareDeviceData] getCurtainStatus];
                NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:path];
                cell.imageView.image = theImage;
            }
            [cell.accessoryView setHidden:YES];
        }
        break;
        case 1:
        {
            if ( indexPath.row < [[CDeviceData shareDeviceData].relayStatus count] )
            {
                cell.textLabel.text = [[CDeviceData shareDeviceData].relayName objectAtIndex:indexPath.row];
                UISwitch *sw = (UISwitch*)cell.accessoryView;
                [cell.accessoryView setHidden:NO];
                NSNumber *num = (NSNumber*)[[CDeviceData shareDeviceData].relayStatus objectAtIndexedSubscript:indexPath.row];
                if ( [num integerValue] > 0 )
                {
                    cell.detailTextLabel.text = @"开启";
                    sw.on = YES;
                }
                else
                {
                    cell.detailTextLabel.text = @"关闭";
                    sw.on = NO;
                }
                NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:path];
                cell.imageView.image = theImage;
            }
            else
            {
                [cell.accessoryView setHidden:YES];
            }
        }
        break;
        case 2:
        {
            if ( indexPath.row < [[CDeviceData shareDeviceData].sensorStatus count] )
            {
                cell.textLabel.text = [[CDeviceData shareDeviceData].sensorName objectAtIndex:indexPath.row];
                [cell.accessoryView setHidden:YES];
                NSNumber *num = (NSNumber*)[[CDeviceData shareDeviceData].sensorStatus objectAtIndexedSubscript:indexPath.row];
                if ( [num integerValue] > 0 )
                {
                    cell.detailTextLabel.text = @"正常状态";
                }
                else
                {
                    cell.detailTextLabel.text = @"报警状态";
                }
                NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:path];
                cell.imageView.image = theImage;
            }
            
        }
        break;
        case 3:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    cell.textLabel.text = @"报警";
                    if ( YES == [CDeviceData shareDeviceData].bAlarmOpen )
                    {
                        cell.detailTextLabel.text = @"已启动";
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"已关闭";
                    }
                    [cell.accessoryView setHidden:NO];
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
                    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
                    cell.imageView.image = theImage;
                }
                    break;
                default:
                {
                    [cell.accessoryView setHidden:YES];
                    if ( indexPath.row < [[CDeviceData shareDeviceData].alarmCount count] + 1 )
                    {
                        NSLog(@"%ld rowrow:",(long)indexPath.row);
                        cell.textLabel.text = [[CDeviceData shareDeviceData].sensorName objectAtIndex:indexPath.row - 1];
                        int count = [[[CDeviceData shareDeviceData].alarmCount objectAtIndexedSubscript:indexPath.row - 1] unsignedLongValue];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"报警%ld次",count];
                    }
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
                    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
                    cell.imageView.image = theImage;
               }
                break;
            }
            
        }
        break;
        case 4:
        {
            cell.textLabel.text = @"温度";
            
            if ( 999 != [[CDeviceData shareDeviceData].insideTemp intValue] &&
                 999 != [[CDeviceData shareDeviceData].outsideTemp intValue] )
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"室内:%d度 室外:%d度",[[CDeviceData shareDeviceData].insideTemp intValue],[[CDeviceData shareDeviceData].outsideTemp intValue]];
            }
            else
            {
                cell.detailTextLabel.text = @"点击更新";
            }
            
            [cell.accessoryView setHidden:YES];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:path];
            cell.imageView.image = theImage;
        }
        break;
        case 5:
        {
            if ( indexPath.row < [[CDeviceData shareDeviceData].relayStatus count] )
            {
                cell.textLabel.text = [[CDeviceData shareDeviceData].relayName objectAtIndex:indexPath.row];
            }
            else
            {
                cell.textLabel.text =  [self.curtainArray objectAtIndex:indexPath.row - [[CDeviceData shareDeviceData].relayStatus count]];
            }
            [cell.accessoryView setHidden:YES];
            cell.detailTextLabel.text = @"";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"device_control_shade_on" ofType:@"png"];
            UIImage *theImage = [UIImage imageWithContentsOfFile:path];
            cell.imageView.image = theImage;
        }
            break;
        default:
            break;
    }

    return cell;
}

- (void)updateSwitchAtIndexPath:(UISwitch *)sw
{
    switch ( _currentIdx )
    {
        case 3:
            //开启报警
        {
            if ( YES == sw.on )
            {
                [[AppDelegate shareAppDelegate] enableAlarm];
            }
            else
            {
                [[AppDelegate shareAppDelegate] disableAlarm];
            }
        }
            break;
        case 1:
        {
            if ( YES == sw.on )
            {
                [[AppDelegate shareAppDelegate] openRelayAtIndex:(NSUInteger)sw.tag];
            }
            else
            {
                [[AppDelegate shareAppDelegate] closeRelayAtIndex:(NSUInteger)sw.tag];
            }
        }
        default:
            break;
    }
    
}

- (void)loadCurtainView
{
    _curtainView = [[UIView alloc] initWithFrame:CGRectMake(30, 40, 260, 300)];
    UIImage *img = [UIImage imageNamed:@"device_shade_bg.png"];
    UIImageView *_imgView = [[UIImageView alloc] initWithImage:img];
    [_imgView setFrame:CGRectMake(20, 0, 220, 250)];
    [_curtainView addSubview:_imgView];
    [_imgView release];
    
    _curtainAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 220, 250)];
   
    
    UIButton *btnOpen = [[UIButton alloc] initWithFrame:CGRectMake(35, 250, 60, 60)];
    UIImage *btnOpenImg = [UIImage imageNamed:@"device_stop_pressed.png"];
    
    [btnOpen setTitle:CURTAIN_OPEN_NAME forState:UIControlStateNormal];
//    [btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnOpen.titleLabel.font = [UIFont systemFontOfSize:20.0];
//    [btnOpen setImage:btnOpenImg forState:UIControlStateNormal];
    [btnOpen setBackgroundImage:btnOpenImg forState:UIControlStateNormal];
    [btnOpen addTarget:self action:@selector(onTapOpenCurtain) forControlEvents:UIControlEventTouchUpInside];
    [_curtainView addSubview:btnOpen];
    [btnOpen release];

    
    UIButton *btnStop = [[UIButton alloc] initWithFrame:CGRectMake(185, 250, 60, 60)];
    UIImage *btnStopImg = [UIImage imageNamed:@"device_stop_pressed.png"];
    [btnStop setBackgroundImage:btnStopImg forState:UIControlStateNormal];
    [btnStop setTitle:CURTAIN_STOP_NAME forState:UIControlStateNormal];
    [btnStop addTarget:self action:@selector(onTapStopCurtain) forControlEvents:UIControlEventTouchUpInside];
    [_curtainView addSubview:btnStop];
    [btnStop release];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(110, 250, 60, 60)];
    UIImage *btnCloseImg = [UIImage imageNamed:@"device_stop_pressed.png"];
    [btnClose setBackgroundImage:btnCloseImg forState:UIControlStateNormal];
    [btnClose setTitle:CURTAIN_CLOSE_NAME forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onTapCloseCurtain) forControlEvents:UIControlEventTouchUpInside];
    [_curtainView addSubview:btnClose];
    [btnClose release];
}

- (void)onTapStopCurtain
{
    [[AppDelegate shareAppDelegate] stopCurtain];
}

- (void)onTapCloseCurtain
{
    [[AppDelegate shareAppDelegate] closeCurtain];
}

- (void)onTapOpenCurtain
{
    [[AppDelegate shareAppDelegate] openCurtain];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select item:%d",indexPath.row);
    switch ( _currentIdx )
    {
        case 0:
        {
            switch ( indexPath.row )
            {
                case 0:
                {
                    if ( ! _curtainView )
                    {
                        [self loadCurtainView];
                    }
                    [_tableView setHidden:YES];
                    [self.view addSubview:_curtainView];

                    [_btnBack2Main setHidden:YES];
                    [_btnBack setHidden:NO];
                    _bFlipped = YES;
                }
                break;
                
                default:
                    break;
            }
        }
        break;
        case 4:
        {
            [[AppDelegate shareAppDelegate] queryTemperature];
        }
        break;
        case 5:
        {
            
                    if ( ! [AppDelegate shareAppDelegate].timerViewController )
                    {
                        [AppDelegate shareAppDelegate].timerViewController = [[TimerViewController alloc] init];
                    }
                    [[AppDelegate shareAppDelegate].timerViewController setChannel:indexPath.row];
                    [[AppDelegate shareAppDelegate].navController setNavigationBarHidden:NO animated:YES];
                    [[AppDelegate shareAppDelegate].navController pushViewController:[AppDelegate shareAppDelegate].timerViewController animated:YES];
            
            
        }
            break;
        default:
            break;
    }
    
}

- (NSUInteger) numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (NSUInteger) numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (void)onTapIndex:(NSUInteger)index
{
    _currentIdx = index;
    switch ( index )
    {
        case 0:
        {
 
        }
        break;
            
        default:
            break;
    }
    if ( YES == _bFlipped )
    {
        [self onTapBack];
    }
    [_tableView reloadData];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"select %d item",index);
    [self onTapIndex:(index) ];
}
- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel
{
    NSLog(@"curr update %d item",carousel.currentItemIndex);
    [self onTapIndex:carousel.currentItemIndex];
}

- (UIView*) carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
//		view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_home_devices.png"]] autorelease];
//        [view setFrame:CGRectMake(0, 0, 130, 130)];
//		label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
//		label.backgroundColor = [UIColor clearColor];
//		//label.textAlignment = UITextAlignmentCenter;
//		label.font = [label.font fontWithSize:50];
//		[view addSubview:label];
        UIImage *img3 = [UIImage imageNamed:@"main_home_devices.png"];
        //    NSLog(@"screen w:%f",[[UIScreen mainScreen] bounds].size.width);
        view = [[[MenuItemView alloc] initWithFrame:CGRectMake(10, 150, 130, 130) image:img3 menuName:@"功能" menuItemType:2 dispatchEvent:NO] autorelease];
       
	}
	else
	{
	//	label = [[view subviews] lastObject];
	}
	
    //set label
	//label.text = [[_items objectAtIndex:index] stringValue];
	switch ( index ) {
        case 0:
        {
            UIImage *img = [UIImage imageNamed:@"main_home_devices.png"];
            MenuItemView *itemView = (MenuItemView*)view;
            if ( itemView )
            {
                [itemView setImage:img menuName:@"窗帘"];
            }
            else
            {
                assert(false);
            }
        }
        break;
        case 1:
        {
            UIImage *img = [UIImage imageNamed:@"main_home_devices.png"];
            MenuItemView *itemView = (MenuItemView*)view;
            if ( itemView )
            {
                [itemView setImage:img menuName:@"继电器"];
            }
            else
            {
                assert(false);
            }
        }
        break;
        case 2:
        {
            UIImage *img = [UIImage imageNamed:@"main_home_devices.png"];
            MenuItemView *itemView = (MenuItemView*)view;
            if ( itemView )
            {
                [itemView setImage:img menuName:@"传感器"];
            }
            else
            {
                assert(false);
            }
        }
        break;
        case 3:
        {
            UIImage *img = [UIImage imageNamed:@"main_home_devices.png"];
            MenuItemView *itemView = (MenuItemView*)view;
            if ( itemView )
            {
                [itemView setImage:img menuName:@"报警"];
            }
            else
            {
                assert(false);
            }
        }
        break;
        case 4:
        {
            UIImage *img = [UIImage imageNamed:@"main_home_devices.png"];
            MenuItemView *itemView = (MenuItemView*)view;
            if ( itemView )
            {
                [itemView setImage:img menuName:@"温度"];
            }
            else
            {
                assert(false);
            }
        }
        break;
        case 5:
        {
            UIImage *img = [UIImage imageNamed:@"main_home_devices.png"];
            MenuItemView *itemView = (MenuItemView*)view;
            if ( itemView )
            {
                [itemView setImage:img menuName:@"定时器"];
            }
            else
            {
                assert(false);
            }
        }
            break;
        default:
            break;
    }
	return view;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.carousel = nil;
    self.items = nil;
}

- (void)didCloseCurtain
{
    [CDeviceData shareDeviceData].curtainStatus = FUNCTION_NAME_CLOSE_CURTAIN;
    [_tableView reloadData];
}

- (void)didOpenCurtain
{
    UIImage *imgOn = [UIImage imageNamed:@"device_control_shade_on.png"];
    //UIImage *imgOff = [UIImage imageNamed:@"device_control_shade_off.png"];
    //UIImage *imgMid = [UIImage imageNamed:@"device_control_shade_mid.png"];
    //_curtainAnimationView.animationImages = [NSArray arrayWithObjects:imgOn,imgMid,imgOff,nil];
    //[_curtainAnimationView setAnimationDuration:2.0];
    //[_curtainAnimationView setAnimationRepeatCount:1];
    //[_curtainAnimationView startAnimating];
    
    [_curtainAnimationView setImage:imgOn];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    // 设定动画类型
    // kCATransitionFade 淡化
    // kCATransitionPush 推挤
    // kCATransitionReveal 揭开
    // kCATransitionMoveIn 覆盖
    // @"cube" 立方体
    // @"suckEffect" 吸收
    // @"oglFlip" 翻转
    // @"rippleEffect" 波纹
    // @"pageCurl" 翻页
    // @"pageUnCurl" 反翻页
    // @"cameraIrisHollowOpen" 镜头开
    // @"cameraIrisHollowClose" 镜头关
    animation.type = @"suckEffect";
    animation.subtype = kCATransitionFromRight;

    [_curtainView addSubview:_curtainAnimationView];
    [[_curtainView layer] addAnimation:animation forKey:@"animation"];

    [CDeviceData shareDeviceData].curtainStatus = FUNCTION_NAME_OPEN_CURTAIN;
    [_tableView reloadData];
}

- (void)didStopCurtain
{
    [CDeviceData shareDeviceData].curtainStatus = FUNCTION_NAME_STOP_CURTAIN;
    [_tableView reloadData];
}

- (void)didOpenRelayAtIndex:(NSInteger)index
{
    [[CDeviceData shareDeviceData].relayStatus setObject:[NSNumber numberWithUnsignedLong:1] atIndexedSubscript:index];
   // NSLog(@"relay status size:%d",[[CDeviceData shareDeviceData].relayStatus count]);
    [_tableView reloadData];
}

- (void)didCloseRelayAtIndex:(NSInteger)index
{
    [[CDeviceData shareDeviceData].relayStatus setObject:[NSNumber numberWithUnsignedLong:0] atIndexedSubscript:index];
    [_tableView reloadData];
}

- (void)didUpdateTemp
{
    [_tableView reloadData];
}

- (void)didEnableAlarm
{
    [_tableView reloadData];
}

- (void)didDisableAlarm
{
    [_tableView reloadData];
}
@end
