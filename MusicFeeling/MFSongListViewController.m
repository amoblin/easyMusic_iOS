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
#import "MFSettingsTableViewCell.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UMengAnalytics/MobClick.h>

@interface MFSongListViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MFSongListViewController

- (NSString *)humanableInfoFromDate: (NSString *) theDate {
//    theDate = @"2014-04-15 17:20:59";
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSDate *d=[date dateFromString:theDate];
    NSString *info;

    NSTimeInterval delta = -[d timeIntervalSinceNow];
    if (delta < 60) {
        // 1分钟之内
        info = @"Just Now";
    } else {
        delta = delta / 60;
        if (delta < 60) {
            // n分钟前
            info = [NSString stringWithFormat:@"%d分钟前", (NSUInteger)delta];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                info = [NSString stringWithFormat:@"%d小时前", (NSUInteger)delta];
            } else {
                delta = delta / 24;
                if (delta == 1) {
                    //昨天
                    info = @"昨天";
                } else if (delta == 2) {
                    info = @"前天";
                } else {
                    info = [NSString stringWithFormat:@"%d天前", (NSUInteger)delta];
                }
            }
        }
    }
    NSLog(@"%@", info);
    return info;
}

- (NSMutableArray *)composedSongs {
    NSError *error = nil;
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    _composedSongs = [[NSMutableArray alloc] initWithCapacity:100];
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:delegate.composedDir error:&error]) {
        [_composedSongs addObject:@{@"name": file, @"isComposed": @YES}];
    }
    return _composedSongs;
}

- (MFArrayDataSource *)arrayDataSource {
    if (_arrayDataSource == nil) {
        NSArray *dataArray;
        static NSString *cellId;
        void (^block)(id, id, NSIndexPath*);

        NSError *error = nil;
        MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:delegate.localDir error:&error]) {
            [array addObject:@{@"name": [[file stringByDeletingPathExtension] stringByDeletingPathExtension]}];
        }
        dataArray = @[self.composedSongs, array];
        cellId = @"cellId";
        block = ^(MFSettingsTableViewCell *cell, NSDictionary *item, NSIndexPath *indexPath) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = item[@"name"];
            if (item[@"mtime"] != nil) {
                cell.detailTextLabel.text = [self humanableInfoFromDate:item[@"mtime"]];
            }
        };
        _arrayDataSource = [[MFArrayDataSource alloc] initWithItems:dataArray cellIdentifier:cellId configureCellBlock:block];
	    _arrayDataSource.sectionHeaderArray = @[@"我创作的", @"大家创作的"];
        _arrayDataSource.editCellBlock = ^(NSDictionary *item, NSIndexPath *indexPath) {
            MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
            [[NSFileManager defaultManager] removeItemAtPath:[delegate.composedDir stringByAppendingPathComponent:item[@"name"]] error:nil];
        };
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
        [_tableView addSubview:self.refreshControl];
    }
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
//        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [_refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFPlayViewController *vc = [[MFPlayViewController alloc] init];
    vc.songInfo = [self.arrayDataSource itemAtIndexPath:indexPath];
    vc.title = [[[self.arrayDataSource itemAtIndexPath:indexPath][@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension];
//    [vc setEditableTitle:[[self.songsInfo[indexPath.row][@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getContents {
    //[SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"http://apion.github.io/k2k/songs.json";
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        self.arrayDataSource.items = @[self.composedSongs, responseObject];
        [self.tableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
    }];
}

- (void)pullToRefresh {
    [self getContents];
}

- (void)addButtonPressed:(id)sender {
    [MobClick event:@"创作曲目"];
    MFPlayViewController *vc = [[MFPlayViewController alloc] init];
    vc.isNew = YES;
    [vc setEditableTitle:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MFPlayViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"songDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        vc.songInfo = [self.arrayDataSource itemAtIndexPath:indexPath];
        [vc setEditableTitle:[[[self.arrayDataSource itemAtIndexPath:indexPath][@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension]];
    } else {
        vc.isNew = YES;
    }
}

- (void)leftBarButtonPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MFSettingViewController *vc = [sb instantiateViewControllerWithIdentifier:@"settingsVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"曲目";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];

    self.tableView.dataSource = self.arrayDataSource;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MFSettingsTableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self getContents];
}

- (void)viewWillAppear:(BOOL)animated {
    self.arrayDataSource.items = @[self.composedSongs, self.arrayDataSource.items[1]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
