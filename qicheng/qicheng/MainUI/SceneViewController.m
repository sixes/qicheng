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
    self.view = [[UIImageView alloc] initWithImage:bgImg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    self.view.userInteractionEnabled = YES;
    
    _btnBack2Main   = [[UIButton alloc] init];
    UIImage *back2MainImage = [UIImage imageNamed:@"home.png"];
    NSString *pressedPath = [[NSBundle mainBundle] pathForResource:@"home_pressed" ofType:@"png"];
    UIImage *back2MainImagePressed = [UIImage imageWithContentsOfFile:pressedPath];
    [_btnBack2Main setBackgroundImage:back2MainImage forState:UIControlStateNormal];
    [_btnBack2Main setBackgroundImage:back2MainImagePressed forState:UIControlStateHighlighted];
    [_btnBack2Main setFrame:CGRectMake(0,0,back2MainImage.size.width,back2MainImage.size.height)];
    _btnBack2Main addTarget:self action:@selector(onTapBack2Main) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBack2Main];

    UIImage *img1 = [UIImage imageNamed:@"scene_gallery_2.png"];
    MenuItemView *item1 = [[MenuItemView alloc] initWithFrame:CGRectMake(10, 20, 130, 130) image:img1 menuName:@"Home" menuItemType:0 dispatchEvent:YES];
    [self.view addSubview:item1];
    [item1 release];
    
    UIImage *img2 = [UIImage imageNamed:@"scene_gallery_3.png"];
    MenuItemView *item2 = [[MenuItemView alloc] initWithFrame:CGRectMake(150, 20, 130, 130) image:img2 menuName:@"Sleep" menuItemType:1 dispatchEvent:YES];
    [self.view addSubview:item2];
    [item2 release];
    
    UIImage *img3 = [UIImage imageNamed:@"scene_gallery_4.png"];
    MenuItemView *item3 = [[MenuItemView alloc] initWithFrame:CGRectMake(10, 150, 130, 130) image:img3 menuName:@"Movie" menuItemType:2 dispatchEvent:YES];
    [self.view addSubview:item3];
    [item3 release];

    UIImage *img4 = [UIImage imageNamed:@"scene_gallery_6.png"];
    MenuItemView *item4 = [[MenuItemView alloc] initWithFrame:CGRectMake(150, 20, 130, 130) image:img4 menuName:@"Movie" menuItemType:3 dispatchEvent:YES];
    [self.view addSubview:item4];
    [item4 release];

    UIImage *img5 = [UIImage imageNamed:@"scene_gallery_1.png"];
    MenuItemView *item5 = [[MenuItemView alloc] initWithFrame:CGRectMake(10, 280, 130, 130) image:img5 menuName:@"Leave" menuItemType:4 dispatchEvent:YES];
    [self.view addSubview:item5];
    [item5 release];
}

- (void)onTapBack2Main
{
    [self presentViewController:[AppDelegate shareAppDelegate].mainUIViewController animated:NO completion:nil]; 
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
