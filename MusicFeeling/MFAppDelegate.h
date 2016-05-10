//
//  MFAppDelegate.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MFAppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *localDir;
@property (strong, nonatomic) NSString *composedDir;
@property (nonatomic) NSUInteger playCount;

- (void)playTone:(NSString *)name;
- (void)triggerNote:(NSString *)toneName isOn:(BOOL)isOn;
@end
