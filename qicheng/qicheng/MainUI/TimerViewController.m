//
//  TimerViewController.m
//  qicheng
//
//  Created by tony on 13-12-1.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "TimerViewController.h"
#import "AppDelegate.h"
#import "DeviceData.h"

@interface TimerViewController ()

@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setChannel:(NSUInteger)channel
{
    _channel = channel;
    NSString *strTitle;
    if ( _channel < 7 )
    {
        strTitle = [NSString stringWithFormat:@"继电器%d",_channel];
    }
    else
    {
        strTitle = @"窗帘";
    }
    [_lblTitle setText:strTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_datePicker setHidden:NO];
   // [_timerTableView setEditing:YES];
   // [_lblTitle setText:@"selected"];
    [_btnCancel setHidden:NO];
    [_btnDone setHidden:NO];
    [_btnNext setHidden:NO];
    [_btnOpen setHidden:NO];
    _selectedTableIdx = [indexPath row];
   
    [self updateOpenBtnStatus];
}

- (void)updateOpenBtnStatus
{
    if ( _channel >= [[CDeviceData shareDeviceData].channelTimerStatus count] )
    {
        //it seems NOT connected...
        return ;
    }
    NSDictionary *dict = [[CDeviceData shareDeviceData].channelTimerStatus objectAtIndexedSubscript:_channel];
    NSNumber *numOpen = [dict objectForKey:@"isOpenTimer"];
    NSString *strBtn;
    if ( [numOpen intValue] > 0 )
    {
        strBtn = @"关闭";
    }
    else
    {
        strBtn = @"开启";
    }
    [_btnOpen setTitle:strBtn forState:UIControlStateNormal];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const NSString *CellWithIdentifier = @"TimerViewControllerTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString*)CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:(NSString*)CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = [indexPath row];
        [sw addTarget:self action:@selector(onTapSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        [sw release];
    }
    
    if ( _channel < [[CDeviceData shareDeviceData].channelTimerStatus count] )
    {
        NSMutableDictionary *dict = [[CDeviceData shareDeviceData].channelTimerStatus objectAtIndexedSubscript:_channel];
        
        NSMutableArray *dateDict = [dict objectForKey:@"dateArr"];
        cell.textLabel.text = [dateDict objectAtIndexedSubscript:indexPath.row];
        
        NSMutableArray *array = [dict objectForKey:@"isOpenDevice"];
        NSNumber *num = [array objectAtIndex:indexPath.row];
        
        UISwitch *sw = (UISwitch*)cell.accessoryView;
        if ( [num intValue] > 0 )
        {
            sw.on = YES;
        }
        else
        {
            sw.on = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)loadView
{
    _timerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height) style:UITableViewStyleGrouped];
    self.view = _timerTableView;
    //[self.view setFrame:CGRectMake(0, 80, 320, 640)];
    
    [_timerTableView setDataSource:self];
    [_timerTableView setDelegate:self];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,80, 320, 30)];
    header.userInteractionEnabled = YES;
//    _timerTableView.tableHeaderView = [[UIView alloc] init];
//    [_timerTableView.tableHeaderView setIsAccessibilityElement:YES];
    _timerTableView.tableHeaderView.userInteractionEnabled = YES;
    _timerTableView.tableHeaderView = header;
    [header release];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 800, 320, 30)];
    footer.userInteractionEnabled = YES;
    _timerTableView.tableFooterView = footer;
    
    _btnCancel  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _lblTitle   = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 100, 30)];
    _btnDone    = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 100, 30)];
    _btnNext    = [[UIButton alloc] initWithFrame:CGRectMake(220, 0, 100, 30)];
    _btnOpen    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    [_timerTableView.tableHeaderView addSubview:_btnOpen];
    [_timerTableView.tableHeaderView addSubview:_lblTitle];
    [_timerTableView.tableHeaderView addSubview:_btnDone];
   
    
    [_timerTableView.tableFooterView addSubview:_btnCancel];
    [_timerTableView.tableFooterView addSubview:_btnNext];
    
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"test"];
    //[[AppDelegate shareAppDelegate].navController.navigationBar pushNavigationItem:item animated:YES];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 230, 320, 120)];
    [_datePicker setHidden:YES];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    _datePicker.locale = [NSLocale systemLocale];
    _datePicker.timeZone = [NSTimeZone systemTimeZone];
    [_datePicker addTarget:self action:@selector(onSetTime) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
}

- (void)onSetTime
{
    NSLog(@"%@",[_datePicker date]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [_btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [_btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnDone addTarget:self action:@selector(onBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(onBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnNext setTitle:@"下一个" forState:UIControlStateNormal];
    [_btnNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnNext addTarget:self action:@selector(onBtnNext) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnOpen setTitle:@"开启" forState:UIControlStateNormal];
    [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnOpen addTarget:self action:@selector(onBtnOpen) forControlEvents:UIControlEventTouchUpInside];
    
    _selectedTableIdx = -1;
    
    [_btnDone setHidden:YES];
    [_btnCancel setHidden:YES];
    [_btnNext setHidden:YES];
    [_btnOpen setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_timerTableView reloadData];
    NSLog(@"willapp");
}

- (void)onTapSwitch:(UISwitch*)sw
{
    if ( sw.tag < 0 || sw.tag >= 5 )
    {
        assert(false);
        return;
    }
    int openValue = 0;
    if ( YES == sw.on )
    {
        openValue = 1;
    }
    
    if ( _channel < [[CDeviceData shareDeviceData].channelTimerStatus count] )
    {
        NSDictionary *dict = [[CDeviceData shareDeviceData].channelTimerStatus objectAtIndexedSubscript:_channel];
        NSMutableArray *array = [dict objectForKey:@"isOpenDevice"];
        [array setObject:[NSNumber numberWithUnsignedInt:openValue] atIndexedSubscript:sw.tag];
    }
    
    
    NSLog(@"debgu");
}

- (void)onBtnOpen
{
    if ( _channel >= [[CDeviceData shareDeviceData].channelTimerStatus count] )
    {
        return ;
    }
    NSDictionary *dict = [[CDeviceData shareDeviceData].channelTimerStatus objectAtIndexedSubscript:_channel];
    NSNumber *numOpen = [dict objectForKey:@"isOpenTimer"];
    if ( [numOpen intValue] > 0 )
    {
        numOpen = [NSNumber numberWithUnsignedInt:0];
    }
    else
    {
        numOpen = [NSNumber numberWithUnsignedInt:1];
    }
    [dict setValue:numOpen forKey:@"isOpenTimer"];
    [self updateOpenBtnStatus];
}
- (void)onBtnDone
{
    NSLog(@"done");
    [_btnCancel setHidden:YES];
    [_btnNext setHidden:YES];
    [_btnDone setHidden:YES];
    [_btnOpen setHidden:YES];
    [_datePicker setHidden:YES];
    [[AppDelegate shareAppDelegate] set5TimerAtChannel:_channel];
}

- (void)onBtnCancel
{
    NSLog(@"cancel");
    [_datePicker setHidden:YES];
    [_btnCancel setHidden:YES];
    [_btnNext setHidden:YES];
}

- (void)onBtnNext
{
    NSLog(@"next");
    if ( -1 == _selectedTableIdx )
    {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *strDate = [formatter stringFromDate:_datePicker.date];
    NSLog(@"select DT:%@",strDate);
    NSDictionary *dict = [[CDeviceData shareDeviceData].channelTimerStatus objectAtIndexedSubscript:_channel];
    NSMutableArray *array = [dict objectForKey:@"dateArr"];
    [array setObject:strDate atIndexedSubscript:_selectedTableIdx];
    [formatter release];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:_selectedTableIdx inSection:0];
    NSArray *arr = [NSArray arrayWithObject:ip];
    [_timerTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
    
    if ( _selectedTableIdx < 4 )
    {
        ip = [NSIndexPath indexPathForRow:++_selectedTableIdx inSection:0];
        [_timerTableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
