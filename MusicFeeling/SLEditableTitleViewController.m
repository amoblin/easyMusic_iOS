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

- (void)setPlaceHolder:(NSString *)placeholder {
    SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
    item.textField.placeholder = placeholder;
}

- (void)setEditableTitle:(NSString *)title {
    SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
    item.textField.text = title;
    item.title = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapViewAction {
    SLNavigationItem *item = (SLNavigationItem *)self.navigationItem;
    [item.textField endEditing:YES];
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
@end
