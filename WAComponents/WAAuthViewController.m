//
//  WAAuthViewController.m
//  marboo.io
//
//  Created by amoblin on 14/10/25.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "WAAuthViewController.h"
#import <Masonry.h>
#import "WANetwork.h"
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD.h>
#import <PXAlertView.h>

@interface WAAuthViewController () <UINavigationBarDelegate>

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UIButton *sendCodeButton;

//@property (strong, nonatomic) UIButton *resetPasswordButton;
//@property (strong, nonatomic) UIButton *signInUpButton;
//@property (strong, nonatomic) UIButton *signInupInfoButton;

@property (nonatomic) BOOL isSignIn;

@end

@implementation WAAuthViewController

- (NSArray *)defaultAccounts {
#ifdef DEBUG
    return @[];
#else 
    return @[];
#endif
}

- (UIColor *)tintColor {
#ifdef MAIN_COLOR
    _tintColor = MAIN_COLOR;
#endif
    if (_tintColor == nil) {
        _tintColor = [UIColor orangeColor];
    }
    return _tintColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSignIn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapViewAction:)];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGesture];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(tapViewAction:)];
    swipeGesture.direction= UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGesture];
    
    [self.iconImageView setBackgroundColor:[UIColor blueColor]];
    [self.accountIconView setImage:[UIImage imageNamed:@"phone"]];
    [self.passwordIconView setImage:[UIImage imageNamed:@"password"]];
    [self.validationIconView setImage:[UIImage imageNamed:@"password"]];
    self.validationIconView.contentMode = UIViewContentModeCenter;
    [self.wechatButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
}

- (void)loadView {
    [super loadView];
    self.title = Local(@"Login");
    
    NSMutableArray *titles = [NSMutableArray new];
    for (NSDictionary *item in [self defaultAccounts]) {
        [titles addObject:item[@"title"]];
    }
    
//    @[@"1号线", @"2号线", @"3号线", @"粮油厂家"]
    self.mSegmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
    [self.view addSubview:self.mSegmentedControl];

    self.iconImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.iconImageView];

    self.accountTextField = [WATextField new];
//    self.accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.accountTextField.placeholder = Local(@"Please input phone number");
    self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.accountTextField];
    
    self.accountIconView = [UIImageView new];
    [self.view addSubview:self.accountIconView];
    
    self.passwordIconView = [UIImageView new];
    [self.view addSubview:self.passwordIconView];
    
    self.validationIconView = [UIImageView new];
    [self.view addSubview:self.validationIconView];
    
    self.validationTextField = [WATextField new];
    self.accountTextField.borderStyle = UITextBorderStyleNone;
    self.validationTextField.placeholder = Local(@"请输入验证码");
    self.validationTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.validationTextField];
    
    self.validationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.validationButton setImage:[UIImage imageNamed:@"validation"] forState:UIControlStateNormal];
    [self.view addSubview:self.validationButton];
    
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendCodeButton setTitle:Local(@"免费发送") forState:UIControlStateNormal];
    [self.view addSubview:self.sendCodeButton];
    
    self.passwordTextField = [WATextField new];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.placeholder = Local(@"Please input password");
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:self.passwordTextField];
    
    self.resetPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    /*
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:Local(@"Reset Password")];
    NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    [attString addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, attString.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attString.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attString.length)];
    [self.resetPasswordButton setAttributedTitle:attString forState:UIControlStateNormal];
     */
    [self.resetPasswordButton setTitle:Local(@"Reset Password")forState:UIControlStateNormal];
    
    [self.view addSubview:self.resetPasswordButton];
    
    self.signInUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self setButton:self.signInUpButton withTitle:@"Sign in"];
    
    [self.signInUpButton setBackgroundColor:self.tintColor];
    self.signInUpButton.layer.cornerRadius = 4.0f;
    self.signInUpButton.layer.masksToBounds = YES;
    
    [self.signInUpButton addTarget:self
                          action:@selector(signInUpButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signInUpButton];
    
    self.signInupInfoButton = [UIButton new];
    [self setSignUpInfo];

    [self.signInupInfoButton addTarget:self
                          action:@selector(signInUpInfoButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signInupInfoButton];
    
    self.wechatButton = [UIButton new];
    [self.view addSubview:self.wechatButton];

    [self setModalStyle];
}

- (void)setModalStyle {
    UINavigationBar *bar = [[UINavigationBar alloc] init];
//    bar.backgroundColor = UIColorFromRGB(122.0, 122.0, 122.0);
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:Local(@"Sign in")];
    [bar setItems:@[item]];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    bar.barTintColor = self.tintColor;
    bar.tintColor = [UIColor whiteColor];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Local(@"Close")
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(close)];
    [bar setDelegate:self];
    self.navBar = bar;
    [self.view addSubview:bar];
    
    WS(ws);
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
    }];
//    CGFloat height = self.view.frame.size.height - 44 - 64;
//    self.mTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, height);
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(ws);
    [self.mSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.width.mas_equalTo(300);
        make.top.equalTo(ws.view).with.offset(80);
        make.height.mas_equalTo(22);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(0);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.iconImageView.mas_bottom).with.offset(20).priorityLow();
        make.right.equalTo(ws.view.mas_right);
        make.left.equalTo(ws.accountIconView.mas_right).with.priorityLow();
        make.height.mas_equalTo(44);
    }];
    
    [self.accountIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.accountTextField.mas_centerY);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.validationTextField.mas_bottom);
        make.left.equalTo(ws.accountTextField.mas_left);
        make.right.equalTo(ws.accountTextField.mas_right);
        make.height.mas_equalTo(ws.accountTextField.mas_height);
    }];
    [self.passwordIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.passwordTextField.mas_centerY);
        make.left.mas_equalTo(self.accountIconView.mas_left);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.view.mas_centerX);
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-50);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.passwordTextField.mas_bottom).mas_offset(10);
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.accountTextField.mas_left);
        make.height.mas_equalTo(20);
    }];
    [self.signInUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.resetPasswordButton.mas_bottom).mas_offset(20);
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.accountTextField.mas_left);
        make.height.mas_equalTo(45);
    }];
    [self.signInupInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.signInUpButton.mas_bottom).mas_offset(20);
        make.centerX.equalTo(ws.view);
        make.left.equalTo(ws.accountTextField.mas_left);
        make.height.mas_equalTo(20);
    }];
    /*
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_iconImageView(==100)]-10-[_accountTextField(==height)]-[_validationTextField(==validationHeight)]-[_passwordTextField(==height)]-10-[_resetPasswordButton(==20)]-20-[_loginButton(==45)]-20-[_signupButton(==20)]"
                                                                     options:0
                                                                     metrics:matrics
                                                                       views:NSDictionaryOfVariableBindings(_iconImageView, _accountTextField, _validationTextField, _passwordTextField, _resetPasswordButton, _loginButton, _signupButton)]];
     */
}

- (void)updateViewConstraints {
    WS(ws);
    NSNumber *matrics;
    if (self.isSignIn) {
        matrics = @0;
        [self.validationIconView setHidden:YES];
        [self.validationButton setHidden:YES];
    } else {
        matrics = @40;
        [self.validationIconView setHidden:NO];
        [self.validationButton setHidden:NO];
    }
    
    [self.validationTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.accountTextField.mas_left);
        make.top.equalTo(ws.accountTextField.mas_bottom);
        make.right.equalTo(ws.accountTextField.mas_right);
        make.height.mas_equalTo(matrics.floatValue);
    }];
    [self.validationIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.validationTextField.mas_centerY);
        make.left.mas_equalTo(ws.accountIconView.mas_left);
        make.height.mas_equalTo(ws.validationTextField.mas_height);
        make.width.mas_equalTo(18);
    }];
    
    [self.validationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.validationTextField.mas_centerY);
        make.right.mas_equalTo(ws.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(ws.validationTextField.mas_height);
        make.width.mas_equalTo(115);
    }];
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - User Interfaction Action

- (void)tapViewAction:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
//    [self.inputTextField endEditing:YES];
}

- (void)signInUpButtonPressed:(UIButton *)sender {
    NSLog(@"Sign in/up");
    [SVProgressHUD show];
    
    NSMutableDictionary *payload;
    NSString *path;
    if (self.mSegmentedControl.selectedSegmentIndex < [[self defaultAccounts] count]) {
        payload = [[self defaultAccounts][self.mSegmentedControl.selectedSegmentIndex][@"payload"] mutableCopy];
    }
    if ([self.accountTextField.text isEqualToString:@""]) {
    } else {
        payload = [@{@"mobile": self.accountTextField.text, @"password": self.passwordTextField.text} mutableCopy];
    }
    if ( ! self.isSignIn) {
        payload[@"code"] = self.validationTextField.text;
        path = @"/login/reg";
    } else {
        path = @"/login/index";
    }
    [[WANetwork sharedInstace] requestWithPath:path method:@"POST" params:payload success:^(id result) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        NSLog(@"%@", result);
        if ([result objectForKey:@"data"]) {
            [[NSUserDefaults standardUserDefaults] setObject:result[@"data"] forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (self.isSignIn) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
//                [self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>]
            }
            if ([self.delegate respondsToSelector:@selector(refreshData)]) {
                [self.delegate refreshData];
            }
        } else {
            NSString *msg = result[@"errMsg"];
            if (msg == nil) {
                msg = @"";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)signInUpInfoButtonPressed:(UIButton *)sender {
    self.isSignIn = ! self.isSignIn;
//    [self viewDidLayoutSubviews];
    /*
    [self updateViewConstraints];
    [self.view needsUpdateConstraints];
    [self.view updateConstraints];
     */
//    [self viewWillLayoutSubviews];
//    [self.view updateConstraints];
    if (self.isSignIn) {
//        [self signInLayout];
        [self setButton:self.signInUpButton withTitle:@"Sign in"];
//        [self.resetPasswordButton setHidden:NO];
        [self.resetPasswordButton setTitle:Local(@"Reset Password") forState:UIControlStateNormal];
        [self setSignUpInfo];
    } else {
        [self setButton:self.signInUpButton withTitle:@"Sign up"];
//        [self.resetPasswordButton setHidden:YES];
        [self.resetPasswordButton setTitle:Local(@"Privacy") forState:UIControlStateNormal];
        [self setSignInInfo];
    }
    [self updateViewConstraints];
}

- (void)setButton:(UIButton *)button withTitle:(NSString *)title {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:Local(title)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (void)setSignUpInfo {
    NSString *str = Local(@"Don't have an account? Sign up!");
    NSMutableAttributedString *signupString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange r1 = [str rangeOfString:Local(@"Don't have an account? ")];
    [signupString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r1];
    [signupString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:r1];

    NSRange r2 = [str rangeOfString:Local(@"Sign up!")];
    [signupString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r2];
    [signupString addAttribute:NSForegroundColorAttributeName value:self.tintColor  range:r2];

    [self.signInupInfoButton setAttributedTitle:signupString forState:UIControlStateNormal];
}

- (void)setSignInInfo {
    NSString *str = Local(@"Already have an account? Sign in!");
    NSMutableAttributedString *signupString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange r1 = [str rangeOfString:Local(@"Already have an account?")];
    [signupString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r1];
    [signupString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:r1];

    NSRange r2 = [str rangeOfString:Local(@"Sign in!")];
    [signupString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r2];
    [signupString addAttribute:NSForegroundColorAttributeName value:self.tintColor range:r2];

    [self.signInupInfoButton setAttributedTitle:signupString forState:UIControlStateNormal];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
@end
