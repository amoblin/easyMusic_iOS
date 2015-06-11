//
//  WASettingsViewController.h
//  goClimb
//
//  Created by amoblin on 15/6/7.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WATableViewController.h"

@protocol SettingsDelegate <NSObject>

@optional
- (void)refreshData;
@end

@interface WASettingsViewController : WATableViewController

@property (nonatomic, unsafe_unretained)NSObject<SettingsDelegate> *delegate;
@end
