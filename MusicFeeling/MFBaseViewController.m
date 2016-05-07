//
//  MFBaseViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFBaseViewController.h"
#import "MFAppDelegate.h"
#import "MFUtils.h"

#import <UMengAnalytics/MobClick.h>

@implementation MFBaseViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.UMPageName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.UMPageName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)uuid {
    if (_uuid == nil) {
        _uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    }
    return _uuid;
}

- (NSUInteger)playCount {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.playCount;
}

- (void)setPlayCount:(NSUInteger)playCount {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.playCount = playCount;
}

- (NSDictionary *)reverseDict:(NSDictionary *)dict {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:50];
    for (NSString *key in dict.allKeys) {
        dic[dict[key]] = key;
    }
    return dic;
}

- (void)playTone:(NSString *)toneName {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate playTone:toneName];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSArray<UIKeyCommand *> *)keyCommands {
    if (_keyCommandArray == nil) {
        NSString *filter = @"abcdefghijklmnopqrstuvwxyz0123456789-=[]\\;',./";
        NSDictionary *dic = [[MFUtils sharedInstance] getFilteredDictWithFilter:filter];

        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:50];
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            UIKeyCommand *keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:kNilOptions action:@selector(keyPressed:)];
            [array addObject:keyCommand];
            keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:UIKeyModifierShift action:@selector(keyPressed:)];
            [array addObject:keyCommand];
            keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:UIKeyModifierAlternate action:@selector(keyPressed:)];
            [array addObject:keyCommand];
        }

        // return key, delete key
        for (NSString *key in @[@"\r", @"\b", @" ", UIKeyInputEscape]) {
            UIKeyCommand *keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:kNilOptions action:@selector(keyPressed:)];
            [array addObject:keyCommand];
        }
        [array addObject:[UIKeyCommand keyCommandWithInput:@" " modifierFlags:UIKeyModifierShift action:@selector(keyPressed:)]];
        _keyCommandArray = [NSArray arrayWithArray:array];
    }
    return _keyCommandArray;
}

- (void)keyPressed:(UIKeyCommand *)keyCommand {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"keyboardConnected"] == nil) {
        [MobClick event:@"keyboardConnected"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"keyboardConnected"];
    }
    if ([keyCommand.input isEqualToString:UIKeyInputEscape]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString *toneName = [self.mapper objectForKey:keyCommand.input];
    if (toneName == nil) {
        return;
    }
    switch (keyCommand.modifierFlags) {
        case UIKeyModifierAlternate:
            // b
            toneName = [self getPreviousHalfTone:toneName];
            break;
        case UIKeyModifierShift:
            // #
            toneName = [NSString stringWithFormat:@"%@m", toneName];
            break;
        default:
            break;
    }
    [self playTone:toneName];
    self.playCount++;
}

- (NSString *)getPreviousHalfTone:(NSString *)tone {
    // 99: 0,1,2,3,4, -2, -1
    // 2 3 4 5 6 0 1
    // 97 + (num + 7 - 98) % 7
    // (97+x) + (num + 7 - (97+x+1)) % 7
    // (97+x) + (num - (91 + x)) % 7
    //NSLog(@"%@", tone);
    unichar t = [tone characterAtIndex:0];
    unichar n = [tone characterAtIndex:1];
    //NSLog(@"%d", t);
    unichar pt = 97 + (t - 91) % 7;
    //NSLog(@"%d", pt);
    NSString *previousHalfTone = [NSString stringWithFormat:@"%c%cm", pt, n];
    NSLog(@"%@", previousHalfTone);
    return previousHalfTone;
}

@end
