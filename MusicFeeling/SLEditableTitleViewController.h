//
//  SLEditableTitleViewController.h
//  StaffList
//
//  Created by amoblin on 3/7/14.
//  Copyright (c) 2014 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFBaseViewController.h"

@interface SLEditableTitleViewController : MFBaseViewController

- (void)setPlaceHolder:(NSString *)placeholder;
- (void)setEditableTitle:(NSString *)title;
@end
