//
//  MainUIViewController.h
//  qicheng
//
//  Created by tony on 13-11-21.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionViewController.h"

@interface MainUIViewController : UIViewController
{
    FunctionViewController *_functionViewController;
}

- (void)onTapMenuItemWithType:(NSUInteger)type;

@end
