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

@interface FunctionViewController ()

@end

@implementation FunctionViewController

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
    [self.view addSubview:_tableView];
    
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        [_items addObject:[NSNumber numberWithInt:i]];
    }
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 310, 320, 220)];
   // _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = iCarouselTypeCoverFlow2;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [self.view addSubview:_carousel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.curtainArray = [[NSMutableArray alloc] initWithCapacity:1];
    [self.curtainArray addObject:@"窗帘"];
    
    _currentIdx = 0;
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
            return [self.curtainArray count];
            break;
            
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const NSString *CellWithIdentifier = @"FunctionViewControllerTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text =  [self.curtainArray objectAtIndex:row];
    cell.detailTextLabel.text = [CDeviceData shareDeviceData].curtainStatus;
    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    return cell;
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
    [btnOpen setImage:btnOpenImg forState:UIControlStateNormal];
    [btnOpen setTitle:CURTAIN_OPEN_NAME forState:UIControlStateNormal];
    [btnOpen addTarget:self action:@selector(onTapOpenCurtain) forControlEvents:UIControlEventTouchUpInside];
    [_curtainView addSubview:btnOpen];
    [btnOpen release];

    UIButton *btnStop = [[UIButton alloc] initWithFrame:CGRectMake(110, 250, 60, 60)];
    UIImage *btnStopImg = [UIImage imageNamed:@"device_stop_pressed.png"];
    [btnStop setImage:btnStopImg forState:UIControlStateNormal];
    [btnStop setTitle:CURTAIN_CLOSE_NAME forState:UIControlStateNormal];
    [btnStop addTarget:self action:@selector(onTapStopCurtain) forControlEvents:UIControlEventTouchUpInside];
    [_curtainView addSubview:btnStop];
    [btnStop release];

    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(185, 250, 60, 60)];
    UIImage *btnCloseImg = [UIImage imageNamed:@"device_stop_pressed.png"];
    [btnClose setImage:btnImg forState:UIControlStateNormal];
    [btnClose setTitle:CURTAIN_STOP_NAME forState:UIControlStateNormal];
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
    //NSLog(@"ontapButn");
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
                }
                break;
                    
                default:
                    break;
            }
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
    return 5;
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
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
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
@end
