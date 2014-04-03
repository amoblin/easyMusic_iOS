//
//  SLNavigationItem.h
//  StaffList
//
//  Created by amoblin on 3/5/14.
//  Copyright (c) 2014 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLNavigationItem : UINavigationItem<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@end
