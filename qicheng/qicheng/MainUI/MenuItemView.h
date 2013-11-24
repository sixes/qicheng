//
//  MenuItemView.h
//  qicheng
//
//  Created by tony on 13-11-23.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemView : UIView
{
    CGRect _rect;
    NSUInteger _MenuItemtype;
    BOOL _bDis;
    
    UIImageView *_imgView;
    UILabel *_lbl;
}

@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) NSUInteger menuItemType;
- (id)initWithFrame:(CGRect)frame image:(UIImage *)img menuName:(NSString *)name menuItemType:(NSUInteger)type dispatchEvent:(BOOL)bDis;
- (void)setImage:(UIImage*)img menuName:(NSString*)name;
@end
