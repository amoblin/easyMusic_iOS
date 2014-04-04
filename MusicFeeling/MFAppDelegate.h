//
//  MFAppDelegate.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *mapper;
@property (strong, nonatomic) NSString *localDir;
@property (strong, nonatomic) NSString *composedDir;

@end
