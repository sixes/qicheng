//
//  MainUIViewController.m
//  qicheng
//
//  Created by tony on 13-11-21.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "MainUIViewController.h"
#import "AppDelegate.h"
#import "MenuItemView.h"
#import "UIConfig.h"

@interface MainUIViewController ()

@end

@implementation MainUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    // self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    // //[self.view setBackgroundColor:[UIColor blackColor]];
    // UIImage *bgImg = [UIImage imageNamed:@"bg4.jpeg"];
    // UIImageView *imgView = [[UIImageView alloc] initWithImage:bgImg];
    // [imgView setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    // [self.view addSubview:imgView];
    // [imgView release];
    
    UIImage *bgImg = [UIImage imageNamed:@"bg_main_ui.jpg"];
    self.view = [[UIImageView alloc] initWithImage:bgImg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    self.view.userInteractionEnabled = YES;
    
    CGFloat firstItemX,firstItemY;
    CGFloat secItemX,secItemY;
    CGFloat hGap;
    CGFloat menuItemW,menuItemH;
    if ( YES == [AppDelegate shareAppDelegate].biPad )
    {
        firstItemX  = FIRST_MENU_ITEM_X_IPAD;
        firstItemY  = FIRST_MENU_ITEM_Y_IPAD;
        hGap        = H_GAP_IPAD;
        menuItemW   = MAIN_UI_MENU_ITEM_WIDTH_IPAD;
        menuItemH   = MAIN_UI_MENU_ITEM_HEIGHT_IPAD;
        secItemX    = SECOND_MENU_ITEM_X_IPAD;
        secItemY    = SECOND_MENU_ITEM_Y_IPAD;
    }
    else
    {
        firstItemX  = FIRST_MENU_ITEM_X_IPHONE;
        firstItemY  = FIRST_MENU_ITEM_Y_IPHONE;
        hGap        = H_GAP_IPHONE;
        menuItemW   = MAIN_UI_MENU_ITEM_WIDTH_IPHONE;
        menuItemH   = MAIN_UI_MENU_ITEM_HEIGHT_IPHONE;
        secItemX    = SECOND_MENU_ITEM_X_IPHONE;
        secItemY    = SECOND_MENU_ITEM_Y_IPHONE;
    }
    
    CGRect item1Rect = CGRectMake(firstItemX,firstItemY, menuItemW,menuItemH );
    CGRect item3Rect = CGRectMake(firstItemX,firstItemY + item1Rect.size.height + hGap, menuItemW, menuItemH );
    CGRect item5Rect = CGRectMake(firstItemX,firstItemY + item1Rect.size.height + item3Rect.size.height + hGap * 2, menuItemW, menuItemH );
    

    CGRect item2Rect = CGRectMake(secItemX, secItemY, menuItemW, menuItemH);
    CGRect item4Rect = CGRectMake(secItemX, secItemY + item2Rect.size.height + hGap, menuItemW, menuItemH );
    
    
    UIImage *img1 = [UIImage imageNamed:@"scene.png"];
    MenuItemView *item1 = [[MenuItemView alloc] initWithFrame:item1Rect image:img1 menuName:@"场景" menuItemType:0 dispatchEvent:YES];
    [self.view addSubview:item1];
    [item1 release];
    
    UIImage *img2 = [UIImage imageNamed:@"main_home_room.png"];
//    NSLog(@"screen w:%f",[[UIScreen mainScreen] bounds].size.width);
    MenuItemView *item2 = [[MenuItemView alloc] initWithFrame:item2Rect image:img2 menuName:@"区域" menuItemType:1 dispatchEvent:YES];
    [self.view addSubview:item2];
    [item2 release];
    
    UIImage *img3 = [UIImage imageNamed:@"main_home_devices.png"];
    //    NSLog(@"screen w:%f",[[UIScreen mainScreen] bounds].size.width);
    MenuItemView *item3 = [[MenuItemView alloc] initWithFrame:item3Rect image:img3 menuName:@"功能" menuItemType:2 dispatchEvent:YES];
    [self.view addSubview:item3];
    [item3 release];
    
    UIImage *img4 = [UIImage imageNamed:@"main_home_system.png"];
    //    NSLog(@"screen w:%f",[[UIScreen mainScreen] bounds].size.width);
    MenuItemView *item4 = [[MenuItemView alloc] initWithFrame:item4Rect image:img4 menuName:@"系统" menuItemType:3 dispatchEvent:YES];
    [self.view addSubview:item4];
    [item4 release];
    
    UIImage *img5 = [UIImage imageNamed:@"main_home_system.png"];
    //    NSLog(@"screen w:%f",[[UIScreen mainScreen] bounds].size.width);
    MenuItemView *item5 = [[MenuItemView alloc] initWithFrame:item5Rect image:img5 menuName:@"注销" menuItemType:4 dispatchEvent:YES];
    [self.view addSubview:item5];
    [item5 release];
}

- (void)onTapMenuItemWithType:(NSUInteger)type
{
    switch( type )
    {
        case 0:
        {
            if ( ! [AppDelegate shareAppDelegate].sceneViewController ) 
            {
                [AppDelegate shareAppDelegate].sceneViewController = [[SceneViewController alloc] init];
            }
           // [self presentViewController:[AppDelegate shareAppDelegate].sceneViewController animated:YES completion:Nil];
            [[AppDelegate shareAppDelegate].navController pushViewController:[AppDelegate shareAppDelegate].sceneViewController animated:YES];
        }
        break;
        case 2:
        {
            if ( ! [AppDelegate shareAppDelegate].functionViewController )
            {
                [AppDelegate shareAppDelegate].functionViewController = [[FunctionViewController alloc] init];
            }
            //[self presentViewController:[AppDelegate shareAppDelegate].functionViewController animated:YES completion:Nil];
            [[AppDelegate shareAppDelegate].navController pushViewController:[AppDelegate shareAppDelegate].functionViewController animated:YES];
        }
        break;
        case 3:
        {
            if ( ! [AppDelegate shareAppDelegate].settingViewController )
            {
                [AppDelegate shareAppDelegate].settingViewController = [[SettingViewController alloc] init];
            }
            [[AppDelegate shareAppDelegate].navController setNavigationBarHidden:NO animated:YES];
            [[AppDelegate shareAppDelegate].navController pushViewController:[AppDelegate shareAppDelegate].settingViewController animated:YES];
        }
        break;
        case 4:
        {
            
            [[AppDelegate shareAppDelegate] logout];
        }
        break;
        default:
        {
            NSLog(@"fun:%s ln:%d type:%d needs to be done",__FUNCTION__,__LINE__,type);
        }
        break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
