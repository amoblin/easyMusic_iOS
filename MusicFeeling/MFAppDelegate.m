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
#import <UMFeedback.h>

#import <AVOSCloud/AVOSCloud.h>

#import <AudioToolbox/AudioToolbox.h>

@interface MFAppDelegate()

@property (nonatomic, strong) NSMutableArray *playerCache;

@property (nonatomic, assign) AUGraph AUGraph;
@property (nonatomic, assign) AudioUnit samplerUnit;

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
    if ([AVUser currentUser] != nil) {
        [AVUser currentUser].email = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    }

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

    if (IOS_8_OR_LATER) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:settings];
    } else {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }

    [self prepareAUGraph];
    [self loadSamplerPath:2];
//    [self noteOn:@21 velocity:@127];
//    [self noteOn:<#(NSNumber *)#> velocity:@0];
    return YES;
}

- (void)prepareAUGraph {
    OSStatus err;

    AUNode samplerNode;
    AUNode remoteOutputNode;

    NewAUGraph(&_AUGraph);
    AUGraphOpen(_AUGraph);

    AudioComponentDescription cd;
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType =  kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = cd.componentFlagsMask = 0;

    err = AUGraphAddNode(_AUGraph, &cd, &remoteOutputNode);
    if (err) {
        NSLog(@"err = %ld", err);
    }
    cd.componentType = kAudioUnitType_MusicDevice;
    cd.componentSubType = kAudioUnitSubType_Sampler;
    err = AUGraphAddNode(_AUGraph, &cd, &samplerNode);
    if (err) {
        NSLog(@"err = %ld", err);
    }
    err = AUGraphConnectNodeInput(_AUGraph, samplerNode, 0, remoteOutputNode, 0);
    if (err) {
        NSLog(@"err = %ld", err);
    }

    err = AUGraphInitialize(_AUGraph);
    if (err) {
        NSLog(@"err = %ld", err);
    }
    err = AUGraphStart(_AUGraph);
    if (err) {
        NSLog(@"err = %ld", err);
    }

    err = AUGraphNodeInfo(_AUGraph,
                          samplerNode,
                          NULL,
                          &_samplerUnit);
    if (err) {
        NSLog(@"err = %ld", err);
    }
}

- (void)noteOn:(NSNumber *)noteNumber velocity:(NSNumber *)velocityNumber {
    NSUInteger note = [noteNumber integerValue];
    NSUInteger velocity = [velocityNumber integerValue];
    MusicDeviceMIDIEvent(_samplerUnit,
                         0x90,
                         note,
                         velocity,
                         0);
}


- (void)loadSamplerPath:(int)pathId {
    NSURL *presetURL;
//    presetURL = [[NSBundle mainBundle] URLForResource:@"GeneralUser GS SoftSynth v1.44"
    presetURL = [[NSBundle mainBundle] URLForResource:@"TimGM6mb"
                                        withExtension:@"sf2"];
    [self loadFromDLSOrSoundFont:presetURL withPatch:2];
}


- (OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber {
    OSStatus result = noErr;
    // fill out a bank preset data structure
    AUSamplerBankPresetData bpdata;
    bpdata.bankURL  = (__bridge CFURLRef)bankURL;
    bpdata.bankMSB  = kAUSampler_DefaultMelodicBankMSB;
    bpdata.bankLSB  = kAUSampler_DefaultBankLSB;
    bpdata.presetID = (UInt8)presetNumber;

    // set the kAUSamplerProperty_LoadPresetFromBank property
    result = AudioUnitSetProperty(_samplerUnit,
                                  kAUSamplerProperty_LoadPresetFromBank,
                                  kAudioUnitScope_Global,
                                  0,
                                  &bpdata,
                                  sizeof(bpdata));
    // check for errors
    NSCAssert(result == noErr,
              @"Unable to set the preset property on the Sampler. Error code:%d '%.4s'",
              (int)result,
              (const char *)&result);
    return result;
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
    [UMFeedback didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *str = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *_deviceToken = nil;
    NSUInteger tokenLength = [str length];
    if ([str length] > 10)
    {
        NSRange range = NSMakeRange (1, tokenLength-2);
        _deviceToken = [NSString stringWithFormat:@"%@", [str substringWithRange:range]];
        NSLog(@"device token is: %@", [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }

    [UMessage registerDeviceToken:deviceToken];
    [UMessage addAlias:[UMFeedback uuid] type:@"Umeng" response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            NSLog(@"%@", responseObject);
        }
    }];
}

#pragma mark For iOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}


// for MFBaseViewControll using

- (void)triggerNote:(NSUInteger)note isOn:(BOOL)isOn;
{
    [self noteOn:@(note) velocity:isOn ? @127: @0];
}

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
