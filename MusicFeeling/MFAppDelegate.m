//
//  MFAppDelegate.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFAppDelegate.h"

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
    self.mapper = @{@"1": @"c6", @"2": @"d6", @"3": @"e6", @"4": @"f6", @"7": @"g6", @"8": @"a6", @"9": @"b6",
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

@end
