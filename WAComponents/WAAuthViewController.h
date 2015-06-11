//
//  WAAuthViewController.h
//  marboo.io
//
//  Created by amoblin on 14/10/25.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WATableViewController.h"
#import "WATextField.h"

@protocol AuthDelegate <NSObject>

@optional
- (void)refreshData;
@end

@interface WAAuthViewController : UIViewController

@property (weak, nonatomic) NSObject<AuthDelegate> *delegate;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UISegmentedControl *mSegmentedControl;

@property (strong, nonatomic) UIImageView *accountIconView;
@property (strong, nonatomic) UIImageView *passwordIconView;
@property (strong, nonatomic) WATextField *accountTextField;
@property (strong, nonatomic) WATextField *passwordTextField;

@property (strong, nonatomic) UIImageView *validationIconView;
@property (strong, nonatomic) WATextField *validationTextField;

@property (strong, nonatomic) UIButton *validationButton;

@property (strong, nonatomic) UIButton *resetPasswordButton;
@property (strong, nonatomic) UIButton *signInUpButton;
@property (strong, nonatomic) UIButton *signInupInfoButton;

@property (strong, nonatomic) UIButton *wechatButton;

@property (strong, nonatomic) UIColor *tintColor;

-(BOOL)isValidateMobile:(NSString *)mobile;
@end
