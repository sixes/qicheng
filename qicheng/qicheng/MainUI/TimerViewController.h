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
}

- (void)setChannel:(NSUInteger)channel;
- (void)updateOpenBtnStatus;

@end
