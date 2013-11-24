//
//  FunctionViewController.h
//  qicheng
//
//  Created by tony on 13-11-24.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface FunctionViewController : UIViewController <iCarouselDataSource,iCarouselDelegate>
{
    iCarousel *_carousel;
    NSMutableArray *_items;
}

@property (nonatomic,retain) iCarousel *carousel;
@property (nonatomic,retain) NSMutableArray *items;

- (void)onTapIndex:(NSUInteger)index;
@end
