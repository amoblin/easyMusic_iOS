//
//  SLNavigationItem.m
//  StaffList
//
//  Created by amoblin on 3/5/14.
//  Copyright (c) 2014 amoblin. All rights reserved.
//

#import "SLNavigationItem.h"

@implementation SLNavigationItem

- (id)initWithTitle:(NSString *)title {
    if((self = [super initWithTitle:title])){
        //initializer code
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
        textField.font = [UIFont boldSystemFontOfSize:19];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"请输入曲目名字";
        textField.delegate = self;
        self.textField = textField;
        self.titleView = textField;
        self.title = textField.text;
    }
    return self;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldDidEndEditingNotification" object:nil];
}

@end
