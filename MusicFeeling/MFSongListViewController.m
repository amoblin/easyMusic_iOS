//
//  MFSongListViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSongListViewController.h"
#import "MFPlayViewController.h"
#import "MFAppDelegate.h"
#import "MFSettingViewController.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface MFSongListViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MFSongListViewController

- (MFArrayDataSource *)arrayDataSource {
    if (_arrayDataSource == nil) {
        NSArray *dataArray;
        static NSString *cellId;
        void (^block)(id, id, NSIndexPath*);

        dataArray = @[self.songsInfo];
        cellId = @"cellId";
        block = ^(UITableViewCell *cell, NSDictionary *item, NSIndexPath *indexPath) {
            cell.textLabel.text = [[item[@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension];
        };
        _arrayDataSource = [[MFArrayDataSource alloc] initWithItems:dataArray cellIdentifier:cellId configureCellBlock:block];
    }
    return _arrayDataSource;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_tableView];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
    }
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        //refreshControl.tintColor = [UIColor blueColor];
        [_refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
    }
    return _refreshControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"曲目";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];

    self.tableView.dataSource = self.arrayDataSource;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    if (self.songsInfo.count == 0) {
        [SVProgressHUD show];
    }
    [self getContents];
}

- (void)viewWillAppear:(BOOL)animated {
    [self pullToRefresh];
}

- (void)pullToRefresh {
    [self getContents];
}

- (NSArray *)songsInfo {
    NSError *error = nil;
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_songsInfo == nil) {
        self.composedSongs = [[NSMutableArray alloc] initWithCapacity:100];
        for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:delegate.composedDir error:&error]) {
            [self.composedSongs addObject:@{@"name": file, @"isComposed": @YES}];
        }
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.composedSongs];
        for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:delegate.localDir error:&error]) {
            [array addObject:@{@"name": file}];
        }
        _songsInfo = [NSArray arrayWithArray:array];
    }
    return _songsInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getContents {
    //[SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"https://api.github.com/repos/amoblin/k2k/contents/";
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.composedSongs];
        [SVProgressHUD dismiss];
        for (NSDictionary *item in responseObject) {
            if ([[[item[@"name"] stringByDeletingPathExtension] pathExtension] isEqualToString:@"k2k"]) {
                [array addObject:item];
            }
        }
        [self.refreshControl endRefreshing];
        self.songsInfo = [NSArray arrayWithArray:array];
        [self.tableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addButtonPressed:(id)sender {
//        vc.isNew = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MFPlayViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"songDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        vc.songInfo = self.songsInfo[indexPath.row];
        [vc setEditableTitle:[[self.songsInfo[indexPath.row][@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension]];
    } else {
        vc.isNew = YES;
    }
}

- (void)leftBarButtonPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MFSettingViewController *vc = [sb instantiateViewControllerWithIdentifier:@"settingsVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
