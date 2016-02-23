//
//  WAEditViewController.m
//  goClimb
//
//  Created by amoblin on 15/6/8.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WAEditViewController.h"
#import <WANetwork.h>

@interface WAEditViewController ()

@end

@implementation WAEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Local(@"Save") style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed:)];
}

- (void)loadView {
    [super loadView];
    self.textView = [UITextView new];
    self.textView.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:self.textView];
    
    self.textView.text = [NSString stringWithFormat:@"%@", self.info[@"value"]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(ws);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.height.mas_equalTo(200);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonPressed:(UIBarButtonItem *)sender {
    NSLog(@"saved");
    WS(ws);
    NSDictionary *payload = @{self.info[@"key_string"]: self.textView.text};
    [[WANetwork sharedInstance] requestWithPath:@"/user/info" method:@"POST" params:payload success:^(id result) {
        NSLog(@"%@", result);
        ws.userInfo[ws.info[@"key_string"]] = ws.textView.text;
        [[NSUserDefaults standardUserDefaults] setValue:self.userInfo forKeyPath:@"info"];
        [ws.navigationController popViewControllerAnimated:YES];
    } failure:^(id response, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

@end
