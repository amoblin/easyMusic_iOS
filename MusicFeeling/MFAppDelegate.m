//
//  MFAppDelegate.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFAppDelegate.h"

#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <UMengAnalytics/MobClick.h>

@interface MFAppDelegate()
@property (nonatomic, strong) NSMutableArray *playerCache;
@end

@implementation MFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:@"5341f04c56240b5a2219a06a"];
    [self getDeviceInfo];
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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[sb instantiateViewControllerWithIdentifier:@"songListVC"]];
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
    NSLog(@"%@", name);
    NSURL *resourceURL;
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"toneType"]) {
        case 0:
            name = [name lowercaseString];
            resourceURL = [[NSBundle mainBundle] URLForResource:name withExtension:@".mp3"];
            break;
        case 1:
            name = [name uppercaseString];
            resourceURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"ramirez%@", name] withExtension:@".mp3"];
            break;
        default:
            name = [name lowercaseString];
            resourceURL = [[NSBundle mainBundle] URLForResource:name withExtension:@".ogg"];
            break;
    }
    if (resourceURL == nil) {
        NSLog(@"%@ is not exist.", name);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ is not exist.", name]];
        return;
    }

    BOOL flag = NO;
    for (AVAudioPlayer *player in self.playerCache) {
        if ( ! player.isPlaying) {
            flag = YES;
            AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:resourceURL error:nil];
            [newPlayer play];
            [newPlayer setDelegate:self];
            [newPlayer prepareToPlay];
            [self.playerCache replaceObjectAtIndex:[self.playerCache indexOfObject:player] withObject:newPlayer];
            break;
        }
    }

    if (flag == NO) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:resourceURL error:nil];
        [player play];
        [player setDelegate:self];
        [player prepareToPlay];
        [self.playerCache addObject:player];
    }
}

- (NSMutableArray *)playerCache {
    if (_playerCache == nil) {
        _playerCache = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _playerCache;
}

- (void)getDeviceInfo {
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
}

@end
