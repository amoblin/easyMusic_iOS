//
//  DDBaseViewController.h
//  iMarboo
//
//  Created by amoblin on 15/11/24.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import "DDFonts.h"
#import "UILabel+DD.h"
#import "UIColor+DD.h"
#import <Masonry/Masonry.h>

@interface DDBaseViewController : UIViewController

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;

@property (nonatomic, copy) void (^popupSelfBlock)();
@property (nonatomic, strong) UILabel *navTitleLabel;

- (void)leftButtonPressed:(UIBarButtonItem *)sender;

- (void)rightButtonPressed:(UIBarButtonItem *)sender;

#pragma mark - DDUIKit Work Flow

// init data or reset data
- (void)resetData;

- (void)setupSubviews;

- (void)configConstraints;

// fetch data
- (void)reloadData;

- (void)addTopToolbar;

- (void)close:(UINavigationItem *)sender;

@end
