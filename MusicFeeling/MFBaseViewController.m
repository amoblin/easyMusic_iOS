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
    [MobClick beginLogPageView:self.navigationItem.title];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navigationItem.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSDictionary *)mapper {
    if (_mapper == nil) {
        _mapper = @{@"1": @"c6", @"2": @"d6", @"3": @"e6", @"4": @"f6", @"7": @"g6", @"8": @"a6", @"9": @"b6",
                    @"0": @"c7", @"-": @"d7", @"=": @"e7",

                    @"q": @"c5", @"w": @"d5", @"e": @"e5", @"r": @"f5", @"u": @"g5", @"i": @"a5", @"o": @"b5",
                    @"p": @"c6", @"[": @"d6", @"]": @"e6", @"\\": @"f6",

                    @"a": @"c4", @"s": @"d4", @"d": @"e4", @"f": @"f4", @"j": @"g4", @"k": @"a4", @"l": @"b4",
                    @";": @"c5", @"'": @"d5",

                    @"z": @"c3", @"x": @"d3", @"c": @"e3", @"v": @"f3", @"m": @"g3", @",": @"a3", @".": @"b3",
                    @"/": @"c4",

                    @"g": @"d4m", @"h": @"f4m",
                    @"t": @"d5m", @"y": @"f5m",
                    @"b": @"d3m", @"n": @"f3m",

                    // b
                    @"∑": @"c5m", @"´": @"d5m", @"¨": @"f5m", @"ˆ": @"g5m", @"ø": @"a5m",
                    @"ß": @"c4m", @"∂": @"d4m", @"∆": @"f4m", @"˚": @"g4m", @"¬": @"a4m",
                    @"≈": @"c3m", @"ç": @"d3m", @"µ": @"f3m", @"≤": @"g3m", @"≥": @"a3m",

                    // #
                    @"Q": @"c5m", @"W": @"d5m", @"R": @"f5m", @"U": @"g5m", @"I": @"a5m",
                    @"A": @"c4m", @"S": @"d4m", @"F": @"f4m", @"J": @"g4m", @"K": @"a4m",
                    @"Z": @"c3m", @"X": @"d3m", @"V": @"f3m", @"M": @"g3m", @"<": @"a3m"
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
