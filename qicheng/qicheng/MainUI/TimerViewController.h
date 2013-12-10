//
//  TimerViewController.h
//  qicheng
//
//  Created by tony on 13-12-1.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_timerTableView;
    NSUInteger _channel;
    UIDatePicker *_datePicker;
    
    UILabel *_lblTitle;
    UIButton *_btnCancel;
    UIButton *_btnDone;
    UIButton *_btnNext;
    UIButton *_btnOpen;
    
    NSUInteger _selectedTableIdx;
    
    UISwitch *_swOpen;
    
    NSString *_channelName;
}

- (void)setChannel:(NSUInteger)channel channelName:(NSString*)name;
- (void)updateOpenBtnStatus;
- (void)didQueryAllTimerStatus;
- (id)initAtChannel:(NSUInteger)channel ChannelName:(NSString*)name;
@end
