//
//  MainUIViewController.m
//  qicheng
//
//  Created by tony on 13-11-21.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "MainUIViewController.h"
#import "AppDelegate.h"
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
    
    UIImage *bgImg = [UIImage imageNamed:@"bg_main_ui.jpeg"];
    self.view = [[UIImageView alloc] initWithImage:bgImg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    self.view.userInteractionEnabled = YES;
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
