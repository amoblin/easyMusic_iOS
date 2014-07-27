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
#import "MFSongListTableViewCell.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UMengAnalytics/MobClick.h>

#import <AVOSCloud/AVOSCloud.h>

@interface MFSongListViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation MFSongListViewController

- (NSMutableArray *)composedSongs {
    NSError *error = nil;
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    _composedSongs = [[NSMutableArray alloc] initWithCapacity:100];
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:delegate.composedDir error:&error]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[delegate.composedDir stringByAppendingPathComponent:file] error:nil];

        AVObject *song = [AVObject objectWithClassName:@"Song"];
        [song setObject:[[file stringByDeletingPathExtension] stringByDeletingPathExtension] forKey:@"name"];
        [song setObject:file forKey:@"path"];
        [song setObject:@YES forKey:@"isComposed"];
        [song setObject:[attributes fileModificationDate] forKey:@"mtime"];
        [_composedSongs addObject:song];
        /*
  @{@"name": [[file stringByDeletingPathExtension] stringByDeletingPathExtension],
                                    @"path": file,
                                    @"isComposed": @YES,
                           @"mtime": [attributes fileModificationDate],
                           @"dateType": @1}];
         */
        [_composedSongs sortUsingComparator:^NSComparisonResult(id a, id b) {
            return [b[@"mtime"] compare:a[@"mtime"]];
        }];
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
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[delegate.localDir stringByAppendingPathComponent:file] error:nil];

            AVObject *song = [AVObject objectWithClassName:@"Song"];
            [song setObject:[[file stringByDeletingPathExtension] stringByDeletingPathExtension] forKey:@"name"];
            [song setObject:file forKey:@"path"];
            [song setObject:[attributes fileModificationDate] forKey:@"mtime"];
            [array addObject:song];
             /*
  @{@"name": [[file stringByDeletingPathExtension] stringByDeletingPathExtension],
                               @"path": file,
                               @"mtime": [attributes fileModificationDate],
                               @"dateType": @1}];
              */
        }
        [array sortUsingComparator:^NSComparisonResult(id a, id b) {
            return [b[@"mtime"] compare:a[@"mtime"]];
        }];

        dataArray = @[self.composedSongs, array];
        cellId = @"cellId";
        block = ^(MFSongListTableViewCell *cell, AVObject *item, NSIndexPath *indexPath) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.section == 0) {
                [cell showCount:NO];
            } else {
                [cell showCount:YES];
            }
            [cell configWithItem:item];
            /*
            if (item[@"mtime"] != nil) {
                cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
                if ([[item[@"mtime"] class] isSubclassOfClass:[NSDate class]]) {
//                    NSDateFormatter *gmtFormatter=[[NSDateFormatter alloc] init];
//                    [gmtFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss VVVV"];
//                    NSDate *d = [gmtFormatter dateFromString:item[@"mtime"]];
                    cell.detailTextLabel.text = [self humanableInfoFromDate:item[@"mtime"]];
                } else {
                    NSDateFormatter *date=[[NSDateFormatter alloc] init];
                    [date setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
                    NSDate *d = [date dateFromString:item[@"mtime"]];
                    cell.detailTextLabel.text = [self humanableInfoFromDate:d];
                }
            }
             */
        };
        _arrayDataSource = [[MFArrayDataSource alloc] initWithItems:dataArray cellIdentifier:cellId configureCellBlock:block];
	    _arrayDataSource.sectionHeaderArray = @[@"我创作的", @"大家创作的"];
        _arrayDataSource.editCellBlock = ^(AVObject *item, NSIndexPath *indexPath) {
            MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (indexPath.section == 0) {
                [[NSFileManager defaultManager] removeItemAtPath:[delegate.composedDir stringByAppendingPathComponent:item[@"path"]] error:nil];
            } else {
                [[item objectForKey:@"contentFile"] deleteInBackground];
                [item deleteInBackground];
            }
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
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 65;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFPlayViewController *vc = [[MFPlayViewController alloc] init];
    vc.songInfo = [self.arrayDataSource itemAtIndexPath:indexPath];
    vc.title = vc.songInfo[@"name"];
    if ([vc.songInfo[@"isComposed"] boolValue]) {
        [vc setEditableTitle:vc.songInfo[@"name"]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getContents {
    /*
    //[SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *url = @"http://k2k.marboo.biz/api/songs";
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
     */

    /*
     */

    AVQuery *query = [AVQuery queryWithClassName:@"Song"];
    [query whereKey:@"isHidden" notEqualTo:@YES];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        /*
        NSArray *array = [[[objects rac_sequence] map:^id(id value) {
            return @{@"name": [value objectForKey:@"name"],
                     @"path": [value objectForKey:@"name"],
                     @"mtime": [value objectForKey:@"createdAt"],
                     @"contentFile": [value objectForKey:@"contentFile"],
                     @"dateType": @1};
        }] array];
         */
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        self.arrayDataSource.items = @[self.composedSongs, objects];
        [self.tableView reloadData];
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
    /*
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MFSettingViewController *vc = [sb instantiateViewControllerWithIdentifier:@"settingsVC"];
     */
    MFSettingViewController *vc = [MFSettingViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.UMPageName = @"曲目";

    self.title = @"曲目";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];

    self.tableView.dataSource = self.arrayDataSource;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MFSongListTableViewCell class] forCellReuseIdentifier:@"cellId"];
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
