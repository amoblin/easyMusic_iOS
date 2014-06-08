//
//  MFBaseViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-24.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFBaseViewController : UIViewController

@property (strong, nonatomic) NSDictionary *mapper;
@property (strong, nonatomic) NSDictionary *router;
@property (strong, nonatomic) NSArray *keyCommandArray;
@property (strong, nonatomic) NSString *UMPageName;
@property (nonatomic) NSUInteger playCount;

- (void)keyPressed:(UIKeyCommand *)keyCommand;

- (void)playTone:(NSString *)name;
- (NSString *)getPreviousHalfTone:(NSString *)tone;
@end
