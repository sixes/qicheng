//
//  SettingViewController.m
//  qicheng
//
//  Created by tony on 13-12-1.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "DeviceData.h"
#import "SetDeviceNameViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [AppDelegate shareAppDelegate].width, [AppDelegate shareAppDelegate].height) style:UITableViewStyleGrouped];
    self.view = _settingTableView;
    
    [_settingTableView setDataSource:self];
    [_settingTableView setDelegate:self];
    
    
//    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 230, 320, 120)];
//    [_datePicker setHidden:YES];
//    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    _datePicker.locale = [NSLocale systemLocale];
//    _datePicker.timeZone = [NSTimeZone systemTimeZone];
//    [_datePicker addTarget:self action:@selector(onSetTime) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_datePicker];
}

- (void)onSetTime
{    
    [CDeviceData shareDeviceData].sysDateTime = [NSDate date];
    [[AppDelegate shareAppDelegate] setSysDateTime];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ( section )
    {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            break;
    }
    return 2;
}

- (void)didSetSysDateTime
{
    [_settingTableView reloadData];
}

- (void)didQuerySysDateTime
{
    [_settingTableView reloadData];
}

- (void)didClearCounter
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                    message:@"清除成功"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ( [indexPath section] )
    {
        case 0:
            switch ( indexPath.row )
        {
                case 0:
            {
                //[_datePicker setHidden:YES];
                [[AppDelegate shareAppDelegate] clearCounter];
            }
            break;
                case 1:
            {
                //[_datePicker setHidden:NO];
                [[AppDelegate shareAppDelegate] querySysDateTime];
            }
                break;
                default:
                    break;
        }
            break;
        case 1:
        {
            switch ( indexPath.row ) {
                case 0:
                {
                    if ( ! [AppDelegate shareAppDelegate].changePasswordViewController )
                    {
                        [AppDelegate shareAppDelegate].changePasswordViewController = [[ChangePasswodViewController alloc] init];
                    }
                    [[AppDelegate shareAppDelegate].navController pushViewController:[AppDelegate shareAppDelegate].changePasswordViewController animated:YES];
                }
                    break;
                case 1:
                {
                    if ( ! [AppDelegate shareAppDelegate].setDeviceNameViewController )
                    {
                        [AppDelegate shareAppDelegate].setDeviceNameViewController = [[SetDeviceNameViewController alloc] init];
                    }
                    [[AppDelegate shareAppDelegate].navController setNavigationBarHidden:NO animated:YES];
                    [[AppDelegate shareAppDelegate].navController pushViewController:[AppDelegate shareAppDelegate].setDeviceNameViewController animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [AppDelegate shareAppDelegate].biPad )
    {
        return 100.0;
    }
    else
    {
        return 40.0;
    }
}

- (void)onBtnSetDateTime
{
    [CDeviceData shareDeviceData].sysDateTime = [NSDate date];
    [[AppDelegate shareAppDelegate] setSysDateTime];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const NSString *CellWithIdentifier = @"SettingViewControllerTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString*)CellWithIdentifier];
    if (cell == nil)
    {
        switch ( [indexPath section] )
        {
            case 0:
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:(NSString*)CellWithIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:@"同步" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [btn setFrame:CGRectMake(0, 0, 40, 30)];
                [btn addTarget:self action:@selector(onBtnSetDateTime) forControlEvents:UIControlEventTouchDown];
                cell.accessoryView = btn;
            }
            break;
            case 1:
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:(NSString*)CellWithIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
            default:
            break;
        }
        
    }
    switch ( [indexPath section] )
    {
        case 0:
        {
            switch ( indexPath.row )
            {
                case 0:
                    cell.textLabel.text = @"清除所有计数器";
                    cell.detailTextLabel.text = @"包括继电器开关输入计数器和报警计数器";
                    [cell.accessoryView setHidden:YES];
                    //UISwitch *sw = (UISwitch*)cell.accessoryView;
                    //[sw setHidden:NO];
                    //[sw addTarget:self action:@selector(onTapClearCounter:) forControlEvents:UIControlEventValueChanged];
                    break;
                case 1:
                {
                    cell.textLabel.text = @"设备日期";
                    NSString * strDt = [[CDeviceData shareDeviceData].sysDateTime descriptionWithLocale:[NSLocale currentLocale]];
                    if ( [strDt length] <= 0 )
                    {
                        strDt = @"点击获取设备时间";
                    }
                    cell.detailTextLabel.text = strDt;
                    
                }
                    break;
                default:
                    break;
            }
        }
        break;
        case 1:
        {
            switch ( [indexPath row] )
            {
                case 0:
                {
                    cell.textLabel.text = @"修改密码";
                }
                break;
                case 1:
                {
                    cell.textLabel.text = @"设备名字";
                }
                break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
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
}

@end
