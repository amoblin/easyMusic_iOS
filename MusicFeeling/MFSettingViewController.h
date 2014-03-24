//
//  MFSettingViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-22.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFBaseViewController.h"

@interface MFSettingViewController : MFBaseViewController

@property (weak, nonatomic) IBOutlet UISwitch *toggleRandomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *toggleMapperSwitch;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sliderValueChanged:(id)sender;
@end
