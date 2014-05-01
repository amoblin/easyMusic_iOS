//
//  SLEditableTitleViewController.m
//  StaffList
//
//  Created by amoblin on 3/7/14.
//  Copyright (c) 2014 amoblin. All rights reserved.
//

#import "SLEditableTitleViewController.h"
#import "SLNavigationItem.h"

@interface SLEditableTitleViewController ()

@end

@implementation SLEditableTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (UITextField *)textField {
    if (_textField == nil) {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
    textField.font = [UIFont boldSystemFontOfSize:19];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
        _textField = textField;
    }
    return _textField;
}

- (void)setPlaceHolder:(NSString *)placeholder {
//    SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
    self.textField.placeholder = placeholder;
}

- (void)setEditableTitle:(NSString *)title {
//    SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
    self.textField.text = title;
    [self.navigationItem setTitleView:self.textField];
    self.title = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapViewAction {
//    SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
    [self.textField endEditing:YES];
}

- (void)saveContent:(NSArray *)array atPath:(NSString *)path {
    NSError *error;
    NSString *content = @"";
    if (error == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *file = [NSString stringWithFormat:@"%@%@",documentsDirectory, path];
        [content writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.navigationItem.title = textField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldDidEndEditingNotification" object:nil];
}

@end
