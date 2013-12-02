//
//  SettingViewController.h
//  qicheng
//
//  Created by tony on 13-12-1.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIDatePicker *_datePicker;
    UITableView *_settingTableView;
}

- (void)didClearCounter;
- (void)didSetSysDateTime;
@end
