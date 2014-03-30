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
    self.mapper = @{@";": @"c5", @"/": @"c4",  @"p": @"c6",
                    @"q": @"c5", @"w": @"d5", @"e": @"e5", @"r": @"f5", @"u": @"g5", @"i": @"a5", @"o": @"b5",
                    @"a": @"c4", @"s": @"d4", @"d": @"e4", @"f": @"f4", @"j": @"g4", @"k": @"a4", @"l": @"b4",
                    @"z": @"c3", @"x": @"d3", @"c": @"e3", @"v": @"f3", @"m": @"g3", @",": @"a3", @".": @"b3",
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
    //self.mapper = [(MFAppDelegate *)[[UIApplication sharedApplication] delegate] mapper];
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
        NSString *setStr = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789,.";
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:setStr] invertedSet];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:50];
        for (NSString *key in self.mapper.allKeys) {
            if ([key rangeOfCharacterFromSet:set].location != NSNotFound) {
                //NSLog(@"This string contains illegal characters");
                continue;
            }
            dic[self.mapper[key]] = key;
        }
        _router = [NSDictionary dictionaryWithDictionary:dic];
    }
    return _router;
}

- (void)playTone:(NSString *)name {
    IDZTrace();

    NSLog(@"%@", name);
    NSError *error;
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@".ogg"];
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
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:26];
    NSArray *keys;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mapper"]) {
        keys = @[@"c", @"d", @"e", @"f", @"g", @"a", @"b"];
    } else {
        keys = [self.mapper allKeys];
    }
    for (NSString *key in keys) {
        UIKeyCommand *keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:kNilOptions action:@selector(keyPressed:)];
        [array addObject:keyCommand];
        keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:UIKeyModifierShift action:@selector(keyPressed:)];
        [array addObject:keyCommand];
        keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:UIKeyModifierAlternate action:@selector(keyPressed:)];
        [array addObject:keyCommand];
    }
    return array;
}

- (void)keyPressed:(UIKeyCommand *)keyCommand {
    NSString *toneName = [self.mapper objectForKey:keyCommand.input];
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
