//
//  SceneViewController.m
//  qicheng
//
//  Created by tony on 13-11-21.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "SceneViewController.h"
#import "AppDelegate.h"
#import "MenuItemView.h"
#import "UIConfig.h"

@interface SceneViewController ()

@end

@implementation SceneViewController

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
    UIImage *bgImg = [UIImage imageNamed:@"bg_main_ui.jpg"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:bgImg];
    
    [imgView setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    self.view = imgView;
    [imgView release];
    
    self.view.userInteractionEnabled = YES;
    
    NSLog(@"yyyyy:%f",[[UIScreen mainScreen] applicationFrame].origin.y);
    
    _btnBack2Main   = [[UIButton alloc] init];
    UIImage *back2MainImage = [UIImage imageNamed:@"home.png"];
    NSString *pressedPath = [[NSBundle mainBundle] pathForResource:@"home_pressed" ofType:@"png"];
    UIImage *back2MainImagePressed = [UIImage imageWithContentsOfFile:pressedPath];
    [_btnBack2Main setBackgroundImage:back2MainImage forState:UIControlStateNormal];
    [_btnBack2Main setBackgroundImage:back2MainImagePressed forState:UIControlStateHighlighted];
    CGFloat h;
    CGFloat imgW,imgH;
    if ( [AppDelegate shareAppDelegate].biPad )
    {
        h = 0;
        imgW = back2MainImage.size.width;
        imgH = back2MainImage.size.height;
    }
    else
    {
        h = 20;
        imgW = back2MainImage.size.width / 2;
        imgH = back2MainImage.size.height / 2;
    }
    [_btnBack2Main setFrame:CGRectMake(0,h,imgW,imgH)];
    [_btnBack2Main addTarget:self action:@selector(onTapBack2Main) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBack2Main];

    
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
    
    UIImage *img1 = [UIImage imageNamed:@"scene_gallery_2.png"];
    MenuItemView *item1 = [[MenuItemView alloc] initWithFrame:item1Rect image:img1 menuName:@"Home" menuItemType:0 dispatchEvent:NO];
    [self.view addSubview:item1];
    [item1 release];
    
    UIImage *img2 = [UIImage imageNamed:@"scene_gallery_3.png"];
    MenuItemView *item2 = [[MenuItemView alloc] initWithFrame:item2Rect image:img2 menuName:@"Sleep" menuItemType:1 dispatchEvent:NO];
    [self.view addSubview:item2];
    [item2 release];
    
    UIImage *img3 = [UIImage imageNamed:@"scene_gallery_4.png"];
    MenuItemView *item3 = [[MenuItemView alloc] initWithFrame:item3Rect image:img3 menuName:@"Movie" menuItemType:2 dispatchEvent:NO];
    [self.view addSubview:item3];
    [item3 release];

    UIImage *img4 = [UIImage imageNamed:@"scene_gallery_6.png"];
    MenuItemView *item4 = [[MenuItemView alloc] initWithFrame:item4Rect image:img4 menuName:@"Dinner" menuItemType:3 dispatchEvent:NO];
    [self.view addSubview:item4];
    [item4 release];

    UIImage *img5 = [UIImage imageNamed:@"scene_gallery_1.png"];
    MenuItemView *item5 = [[MenuItemView alloc] initWithFrame:item5Rect image:img5 menuName:@"Leave" menuItemType:4 dispatchEvent:NO];
    [self.view addSubview:item5];
    [item5 release];
}

- (void)onTapBack2Main
{
    [[AppDelegate shareAppDelegate].navController popToRootViewControllerAnimated:YES];
    //[self presentViewController:[AppDelegate shareAppDelegate].mainUIViewController animated:NO completion:nil];
}

- (void)onTapMenuItemWithType:(NSUInteger)type
{
    NSLog(@"SceneViewController fun:%s ln:%d type:%d to be impl",__FUNCTION__,__LINE__,type);
    switch( type )
    {
        case 0:
        {
            
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
