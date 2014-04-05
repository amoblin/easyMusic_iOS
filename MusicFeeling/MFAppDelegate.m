//
//  MFAppDelegate.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFAppDelegate.h"

@interface MFAppDelegate()
@property (nonatomic, strong) NSMutableArray *playerCache;
@end

@implementation MFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.localDir = [paths[0] stringByAppendingPathComponent:@"local"];
    self.composedDir = [paths[0] stringByAppendingPathComponent:@"composed"];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:self.localDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.localDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:self.composedDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.composedDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// for MFBaseViewControll using
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
