//
//  WASettingsViewController.m
//  goClimb
//
//  Created by amoblin on 15/6/7.
//  Copyright (c) 2015年 marboo. All rights reserved.
//

#import "WASettingsViewController.h"
#import "WATableViewCell.h"
#import "WAAuthViewController.h"

@interface WASettingsViewController ()

@end

@implementation WASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [super loadView];
}

- (void)refreshData {
    if ([USER_DEFAULT objectForKey:@"user"]) {
        self.mViewModel = [[WAViewModel alloc] initWithArray:@[@[@{@"title": @"意见反馈"},
                                                                 @{@"title": @"评价"},
                                                                 @{@"title": @"分享"},
                                                                 @{@"title": @"关于"}],
                                                               @[@{@"title": @"退出登录"}]]];
    } else {
        self.mViewModel = [[WAViewModel alloc] initWithArray:@[@[@{@"title": @"意见反馈"},
                                                                 @{@"title": @"评价"},
                                                                 @{@"title": @"分享"},
                                                                 @{@"title": @"关于"}],
                                                               @[@{@"title": @"登录"}]]];
    }
    [self.mTableView reloadData];
    if ([self.delegate respondsToSelector:@selector(refreshData)]) {
        [self.delegate refreshData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.backgroundColor = UIColorFromHex(0xFF6666);
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    NSDictionary *item = [self.mViewModel itemForRowAtIndexPath:indexPath];
    cell.textLabel.text = item[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if ([USER_DEFAULT objectForKey:@"user"]) {
            [self logoutButtonPressed:nil];
        } else {
            [self loginButtonPressed:nil];
        }
    } else {
        if (indexPath.row == 1) {
            [self goAppStore];
        }
    }
}

- (void)loginButtonPressed:(UIBarButtonItem *)sender {
    WAAuthViewController *controller = [WAAuthViewController new];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    [self refreshData];
}

- (void)logoutButtonPressed:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认退出？" message:@"" delegate:self cancelButtonTitle:Local(@"Cancel") otherButtonTitles:Local(@"OK"), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
//        [self.loginOutButton setTitle:Local(@"Login")];
        //    [sender setTitle:Local(@"Login") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        self.userInfo = nil;
        for (UINavigationController *navController in self.tabBarController.viewControllers) {
            [navController.viewControllers[0] setShouldRefresh:YES];
        }
        [self refreshData];
        /*
        if ([self.delegate respondsToSelector:@selector(refreshData)]) {
            [self.delegate refreshData];
        }
         */
//        WAAuthViewController *controller = [WAAuthViewController new];
//        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void) goAppStore
{
    NSString *url = @"";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
