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

- (void)loadView
{
    UIImage *bgImg = [UIImage imageNamed:@"bg_main_ui.jpg"];
    self.view = [[UIImageView alloc] initWithImage:bgImg];
    [self.view setFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height)];
    [self.view setUserInteractionEnabled:YES];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 40, 260, 300) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    
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
   // _carousel.center = CGPointMake(30, 160);
    [self.view addSubview:_carousel];
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
    switch ( index ) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aa"];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            [lbl setText:@"window"];
          //  cell.textLabel = lbl;
            
        }
            break;
            
        default:
            break;
    }
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
            if ( itemView ) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.carousel = nil;
    self.items = nil;
}

@end
