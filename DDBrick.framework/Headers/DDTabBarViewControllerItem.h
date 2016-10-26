//
//  DDTabBarViewControllerItem.h
//  Bee
//
//  Created by amoblin on 16/8/15.
//  Copyright © 2016年 didi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTabBarViewControllerItem : NSObject

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *selectedImageName;

- (instancetype)initWithController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;
@end
