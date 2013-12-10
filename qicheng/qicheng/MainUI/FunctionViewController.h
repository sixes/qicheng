//
//  FunctionViewController.h
//  qicheng
//
//  Created by tony on 13-11-24.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface FunctionViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UITableViewDataSource,UITableViewDelegate>
{
    iCarousel *_carousel;
    NSMutableArray *_items;
    
    NSMutableArray *_curtainArray;
    
    UITableView *_tableView;
    
    NSUInteger _currentIdx;
    
    UIView *_curtainView;
    UIImageView *_curtainAnimationView;
    
    BOOL _bFlipped;

    UIButton *_btnBack2Main;
    UIButton *_btnBack;
    
   // NSTimer *_sensorTimer;
    NSTimer *_tempTimer;
    
    BOOL _bHadQuerySensorStatus;
    BOOL _bHadQueryAlarmCount;
    BOOL _bHadQueryTimerStatus;
    BOOL _bHadQueryRelayStatus;
}

@property (nonatomic,assign) BOOL bFilpped;
@property (nonatomic,assign) BOOL bHadQuerySensorStatus;
@property (nonatomic,assign) BOOL bHadQueryAlarmCount;
@property (nonatomic,assign) BOOL bHadQueryTimerStatus;
@property (nonatomic,assign) BOOL bHadQueryRelayStatus;
@property (nonatomic,retain) iCarousel *carousel;
@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic,retain) NSMutableArray *curtainArray;

- (void)onTapIndex:(NSUInteger)index;

- (void)loadCurtainView;

- (void)didEnableAlarm;
- (void)didDisableAlarm;
- (void)didCloseCurtain;
- (void)didOpenCurtain;
- (void)didStopCurtain;
- (void)didOpenRelayAtIndex:(NSInteger)index;
- (void)didCloseRelayAtIndex:(NSInteger)index;
- (void)didUpdateTemp;
- (void)updateTableData;
- (void)didUpdateAlarmCount;
- (void)didQueryAllRelayStatus;
- (void)didQueryAlarmIsOpen;
- (void)didQueryAllSensorStatus;
- (void)didQueryAllTimerStatus;
@end
