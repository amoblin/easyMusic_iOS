//
//  MFAppDelegate.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFAppDelegate.h"
#import "MFSongListViewController.h"

#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>

#import <UMengAnalytics/MobClick.h>
//#import <TalkingData.h>
#import <UMessage.h>

#import <AVOSCloud/AVOSCloud.h>

@interface MFAppDelegate()
@property (nonatomic, strong) NSMutableArray *playerCache;
@end

@implementation MFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // disable auto lock screen.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // track analytics
    [MobClick startWithAppkey:UMENG_KEY];
    //[TalkingData sessionStarted:@"5A13A0629F061B7164BB1475EBADD33F" withChannelId:@""];
#if DEBUG
//    [self getDeviceInfo];
#endif
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] == nil) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    /*
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
     */

    [self.window setTintColor:UIColorFromRGB(57, 170, 255)];

    [AVOSCloud setApplicationId:@"em7crzhon1098l4b8rxdl1ql98rf954lflo9q8rzvww2lybm"
                      clientKey:@"meysvye442k6k7hv7dhvurj0oox2b91fsxjeaxi0da18s90q"];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.localDir = [paths[0] stringByAppendingPathComponent:@"local"];
    self.composedDir = [paths[0] stringByAppendingPathComponent:@"composed"];
    for (NSString *name in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paths[0] error:nil]) {
        if ([name hasSuffix:@".k2k.txt"]) {
            NSLog(@"found file: %@", name);
            [[NSFileManager defaultManager] removeItemAtPath:[self.composedDir stringByAppendingPathComponent:name]
                                                       error:nil];
            [[NSFileManager defaultManager] moveItemAtPath:[paths[0] stringByAppendingPathComponent:name]
                                                    toPath:[self.composedDir stringByAppendingPathComponent:name] error:nil];
        }
    }
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:self.localDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.localDir
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:self.composedDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.composedDir
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        /*
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Do Re Mi.k2k" ofType:@".txt"];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:[self.composedDir stringByAppendingPathComponent:@"Do Re Mi.k2k.txt"] error:nil];
         */
    }
    // Override point for customization after application launch.
    MFSongListViewController *controller = [[MFSongListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBar.translucent = YES;
    self.window.rootViewController = navigationController;

    [UMessage startWithAppkey:UMENG_KEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.applicationIconBadgeNumber = 0;
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

# pragma mark - remote notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *str = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *_deviceToken = nil;
    int tokenLength = [str length];
    if ([str length] > 10)
    {
        NSRange range = NSMakeRange (1, tokenLength-2);
        _deviceToken = [NSString stringWithFormat:@"%@", [str substringWithRange:range]];
        NSLog(@"device token is: %@", [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }

    [UMessage registerDeviceToken:deviceToken];
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
        /*
        if (player.isPlaying) {
            [player stop];
        }
         */
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

/*
- (void)getDeviceInfo {
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
}
 */

@end
