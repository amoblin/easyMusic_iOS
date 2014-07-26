//
//  MFBaseViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFBaseViewController.h"
#import "MFAppDelegate.h"

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

- (NSDictionary *)mapper {
    if (_mapper == nil) {
        _mapper = @{@"1": @"C6", @"2": @"D6", @"3": @"E6", @"4": @"F6", @"7": @"G6", @"8": @"A6", @"9": @"B6",
                    @"0": @"C7", @"-": @"D7", @"=": @"E7",

                    @"q": @"C5", @"w": @"D5", @"e": @"E5", @"r": @"F5", @"u": @"G5", @"i": @"A5", @"o": @"B5",
                    @"p": @"C6", @"[": @"D6", @"]": @"E6", @"\\": @"F6",

                    @"a": @"C4", @"s": @"D4", @"d": @"E4", @"f": @"F4", @"j": @"G4", @"k": @"A4", @"l": @"B4",
                    @";": @"C5", @"'": @"D5",

                    @"z": @"C3", @"x": @"D3", @"c": @"E3", @"v": @"F3", @"m": @"G3", @",": @"A3", @".": @"B3",
                    @"/": @"C4",

                    @"g": @"D4m", @"h": @"F4m",
                    @"t": @"D5m", @"y": @"F5m",
                    @"b": @"D3m", @"n": @"F3m",

                    // b
                    @"∑": @"C5m", @"´": @"D5m", @"¨": @"F5m", @"ˆ": @"G5m", @"ø": @"A5m",
                    @"ß": @"C4m", @"∂": @"D4m", @"∆": @"F4m", @"˚": @"G4m", @"¬": @"A4m",
                    @"≈": @"C3m", @"ç": @"D3m", @"µ": @"F3m", @"≤": @"G3m", @"≥": @"A3m",

                    // #
                    @"Q": @"C5m", @"W": @"D5m", @"R": @"F5m", @"U": @"G5m", @"I": @"A5m",
                    @"A": @"C4m", @"S": @"D4m", @"F": @"F4m", @"J": @"G4m", @"K": @"A4m",
                    @"Z": @"C3m", @"X": @"D3m", @"V": @"F3m", @"M": @"G3m", @"<": @"A3m"
                    };
    }
    return _mapper;
}

- (NSDictionary *)router {
    if (_router == nil) {
        NSString *filter = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789,.-=";
        NSDictionary *dic = [self getFilteredDict:self.mapper withFilter:filter];
        _router = [self reverseDict:dic];
    }
    return _router;
}

- (NSUInteger)playCount {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.playCount;
}

- (void)setPlayCount:(NSUInteger)playCount {
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.playCount = playCount;
}

- (NSDictionary *)getFilteredDict:(NSDictionary *)dict withFilter:(NSString *)filter {
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:filter] invertedSet];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    for (NSString *key in dict.allKeys) {
        if ([key rangeOfCharacterFromSet:set].location != NSNotFound) {
            //NSLog(@"This string contains illegal characters");
            [dic removeObjectForKey:key];
            continue;
        }
    }
    return dic;
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

- (NSArray *)keyCommands {
    if (_keyCommandArray == nil) {
        NSString *filter = @"abcdefghijklmnopqrstuvwxyz0123456789-=[]\\;',./";
        NSDictionary *dic = [self getFilteredDict:self.mapper withFilter:filter];

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
