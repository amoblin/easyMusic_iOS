//
//  MFPlayViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFBaseViewController.h"

@interface MFPlayViewController : MFBaseViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSDictionary *songInfo;
@end
