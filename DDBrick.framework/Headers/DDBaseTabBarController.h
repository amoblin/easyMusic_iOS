//
//  DDBaseTabBarController.h
//  Bee
//
//  Created by amoblin on 16/8/15.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTabBarViewControllerItem.h"

@interface DDBaseTabBarController : UITabBarController

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIColor *navBackgroundColor;

- (void)setupSubviews;

@end
