//
//  MFTestViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDZAQAudioPlayer.h"
#import "IDZTrace.h"

@interface MFTestViewController : UIViewController <UITextFieldDelegate, IDZAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *baseToneButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UISwitch *toggleRandomSwitch;

@property (nonatomic, strong) NSMutableArray *tonesArray;
@end
