//
//  MFSettingViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-22.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFBaseViewController.h"
//#import <iVersion.h>

@class MFArrayDataSource;
@interface MFSettingViewController : MFBaseViewController <UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UINavigationBar *bar;
@property (weak, nonatomic) IBOutlet UISwitch *toggleRandomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *toggleMapperSwitch;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) MFArrayDataSource *arrayDataSource;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)segmentedValueChanged:(id)sender;
@end
