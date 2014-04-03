//
//  SLNavigationItem.m
//  StaffList
//
//  Created by amoblin on 3/5/14.
//  Copyright (c) 2014 amoblin. All rights reserved.
//

#import "SLNavigationItem.h"

@implementation SLNavigationItem

- (void)awakeFromNib {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
    textField.font = [UIFont boldSystemFontOfSize:19];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    self.textField = textField;
    self.titleView = textField;
    self.title = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.title = textField.text;
}

@end
