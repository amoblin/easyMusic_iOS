//
//  WATableViewController.m
//  marboo.io
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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.mTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshData];
}

- (void)refreshTableView:(UIRefreshControl *)refreshControl {
    [self refreshData];
}

- (void)refreshData {
    [self.refreshControl endRefreshing];
}

- (UITableView *)mTableView {
    if (_mTableView == nil) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _mTableView;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    self.mTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[WATableViewCell class] forCellReuseIdentifier:self.cellId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldRefresh) {
        [self refreshData];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(ws);
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.priorityLow();
        make.left.equalTo(ws.view).with.priorityLow();
        make.right.equalTo(ws.view).with.priorityLow();
        make.bottom.equalTo(ws.view).with.offset(0).with.priorityLow();
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
    NSString *title = [self.mViewModel titleForSection:section];
    if (title == nil) {
        return [NSString stringWithFormat:@"Section %@", @(section)];
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    NSDictionary *item = [self.mViewModel itemForRowAtIndexPath:indexPath];
    [cell config:item atIndexPath:(NSIndexPath *)indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.defaultHeight;
}

- (CGFloat)defaultHeight {
    if (_defaultHeight == 0) {
        _defaultHeight = 40;
    }
    return _defaultHeight;
}

- (NSString *)cellId {
    if (_cellId == nil) {
        _cellId = @"cellId";
    }
    return _cellId;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WATableViewController *controller = [[WATableViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)fetchDataWithConfig:(NSDictionary *)conf {
    NSURL *url = [NSURL URLWithString:conf[@"url"]];
    NSString *keyPath = conf[@"key_path"];
    [[WANetwork sharedInstace] setApiRoot:[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]];

    NSDictionary *payload =  @{@"os": @"ios"};
    [[WANetwork sharedInstace] requestWithString:url.path method:@"GET" params:payload success:^(id result) {
        [self.refreshControl endRefreshing];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)fetchDataWithConfig:(NSDictionary *)conf andCallback:(void (^)(id))callback {
    NSURL *url = [NSURL URLWithString:conf[@"url"]];
    NSString *keyPath = conf[@"key_path"];
    [[WANetwork sharedInstace] setApiRoot:[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]];

    NSDictionary *payload =  @{@"os": @"ios"};
    [[WANetwork sharedInstace] requestWithString:url.path method:@"GET" params:payload success:^(id result) {
        [self.refreshControl endRefreshing];
        callback([result valueForKeyPath:keyPath]);
    } failure:^(NSError *error) {
    }];
}

@end
