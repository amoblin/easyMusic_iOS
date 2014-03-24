//
//  MFTestViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFBaseViewController.h"

@interface MFTestViewController : MFBaseViewController <UITextFieldDelegate, IDZAudioPlayerDelegate, UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIButton *baseToneButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIButton *toneButton;

@property (nonatomic, strong) NSMutableArray *tonesArray;
@end
