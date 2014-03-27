//
//  MFBaseViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFBaseViewController.h"

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
                    @"a": @"c4", @"s": @"d4", @"d": @"e4", @"f": @"f4", @"j": @"g4", @"k": @"a4", @"l": @"b4",
                    @"z": @"c3", @"x": @"d3", @"c": @"e3", @"v": @"f3", @"m": @"g3", @",": @"a3", @".": @"b3",
                    @"q": @"c5", @"w": @"d5", @"e": @"e5", @"r": @"f5", @"u": @"g5", @"i": @"a5", @"o": @"b5",
                    @"g": @"d4m", @"h": @"f4m",
                    @"t": @"d5m", @"y": @"f5m",
                    @"b": @"d3m", @"n": @"f3m"
                    };
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:50];
    for (NSString *key in self.mapper.allKeys) {
        dic[self.mapper[key]] = key;
    }
    return [NSDictionary dictionaryWithDictionary:dic];
}

- (void)playTone:(NSString *)name {
    IDZTrace();

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
    }
    return array;
}

- (void)keyPressed:(UIKeyCommand *)keyCommand {
    NSLog(@"%@", keyCommand.input);
    NSString *toneName;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mapper"]) {
        toneName = [NSString stringWithFormat:@"%@%@", keyCommand.input, [NSNumber numberWithInteger:4]];
    } else {
        toneName = [NSString stringWithFormat:[self.mapper objectForKey:keyCommand.input], [NSNumber numberWithInteger:4]];
    }

    [self playTone:toneName];
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
