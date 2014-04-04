//
//  MFBaseViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFBaseViewController.h"
#import "MFAppDelegate.h"

@interface MFBaseViewController ()

@property (nonatomic, strong) NSMutableArray *playerCache;
@end

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
    self.mapper = [(MFAppDelegate *)[[UIApplication sharedApplication] delegate] mapper];
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

- (void)playTone:(NSString *)name {
    IDZTrace();

    NSLog(@"%@", name);
    name = [name lowercaseString];
    NSError *error;
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@".ogg"];
    if (oggUrl == nil) {
        NSLog(@"%@ is not exist.", name);
        return;
    }
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);

    BOOL flag = NO;
    for (IDZAQAudioPlayer *player in self.playerCache) {
        if ( ! player.isPlaying) {
            flag = YES;
            IDZAQAudioPlayer *newPlayer = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
            [self.playerCache replaceObjectAtIndex:[self.playerCache indexOfObject:player] withObject:newPlayer];
            newPlayer.delegate = self;
            [newPlayer prepareToPlay];

            //[self startTimer];
            [newPlayer play];
            break;
        }
    }
    if (flag == NO) {
        IDZAQAudioPlayer *player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
        player.delegate = self;
        [player prepareToPlay];

        //[self startTimer];
        [player play];
        [self.playerCache addObject:player];
    }
}

- (NSMutableArray *)playerCache {
    if (_playerCache == nil) {
        _playerCache = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _playerCache;
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

#pragma mark - IDZAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(id<IDZAudioPlayer>)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
    //[self stopTimer];
    //[self updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(id<IDZAudioPlayer>)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    //[self stopTimer];
    //[self updateDisplay];
}

@end
