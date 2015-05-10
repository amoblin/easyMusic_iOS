//
//  WATableViewController.m
//  ShuDongPo
//
//  Created by amoblin on 15/3/11.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import "WATableViewController.h"
#import "WATableViewCell.h"
#import "WANetwork.h"
#import <SVProgressHUD.h>
#import <ReactiveCocoa.h>
#import <UIImageView+AFNetworking.h>

@interface WATableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.mTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshData];
}

- (void)refreshTableView:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self refreshData];
}

- (void)refreshData {
}

- (void)loadView {
    [super loadView];
    
    self.mTableView = [UITableView new];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.view addSubview:self.mTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldRefresh) {
        [self refreshData];
    }
}

- (void)layoutTableView {
    WS(ws);
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.bottom.equalTo(ws.view).with.offset(0);
    }];
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

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mViewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mViewModel numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.mViewModel titleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    NSDictionary *item = [self.mViewModel itemForRowAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d", indexPath.section+1, indexPath.row+1];
//    [cell.mImageView setImageWithURL:[NSURL URLWithString:item[@"img_url"]] placeholderImage:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WATableViewController *controller = [[WATableViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)fetchDataWithConfig:(NSDictionary *)conf {
    NSURL *url = [NSURL URLWithString:conf[@"url"]];
    NSString *keyPath = conf[@"key_path"];
    [[WANetwork sharedInstace] setApiRoot:[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]];

    [SVProgressHUD show];
    NSDictionary *payload =  @{@"os": @"ios"};
    [[WANetwork sharedInstace] requestWithString:url.path method:@"GET" params:payload success:^(id result) {
        [SVProgressHUD dismiss];
        //        self.userList = result[@"result"];
        NSArray *data = [result valueForKeyPath:keyPath];
        self.mViewModel = [[WAViewModel alloc] initWithArray:@[data]];
        [self.mTableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)fetchDataWithConfig:(NSDictionary *)conf andCallback:(void (^)(id))callback {
    NSURL *url = [NSURL URLWithString:conf[@"url"]];
    NSString *keyPath = conf[@"key_path"];
    [[WANetwork sharedInstace] setApiRoot:[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]];

    [SVProgressHUD show];
    NSDictionary *payload =  @{@"os": @"ios"};
    [[WANetwork sharedInstace] requestWithString:url.path method:@"GET" params:payload success:^(id result) {
        [SVProgressHUD dismiss];
        callback([result valueForKeyPath:keyPath]);
    } failure:^(NSError *error) {
    }];
}

@end
