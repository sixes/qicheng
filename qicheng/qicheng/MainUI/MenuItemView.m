//
//  MenuItemView.m
//  qicheng
//
//  Created by tony on 13-11-23.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "MenuItemView.h"
#import "AppDelegate.h"
@implementation MenuItemView

@synthesize menuItemType = _MenuItemtype;
@synthesize rect = _rect;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img menuName:(NSString *)name menuItemType:(NSUInteger)type dispatchEvent:(BOOL)bDis
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _rect = frame;
        _MenuItemtype = type;
        _bDis = bDis;

        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imgView];

        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height -25,frame.size.width,20)];
        [_lbl setFont:[UIFont boldSystemFontOfSize:20.0]];
        [_lbl setTextAlignment:NSTextAlignmentCenter];
        [_lbl setTextColor:[UIColor whiteColor]];
        [self addSubview:_lbl];

        [self setImage:img menuName:name];
    }
    return self;
}

- (void)setImage:(UIImage*)img menuName:(NSString*)name
{
    [_imgView setImage:img];
    [_lbl setText:name];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch;
	CGPoint point;
	
	if ([touches count] > 0)
	{
		touch = [[touches allObjects] objectAtIndex:0];
		point = [touch locationInView:self];
        NSLog(@"tap x:%f y:%f menuItemType:%d",point.x,point.y,_MenuItemtype);
        if ( _bDis )
        {
            [[AppDelegate shareAppDelegate].mainUIViewController onTapMenuItemWithType:_MenuItemtype];
        }
	}
}

- (void)dealloc
{
    [super dealloc];
    [_lbl release];
    [_imgView release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
