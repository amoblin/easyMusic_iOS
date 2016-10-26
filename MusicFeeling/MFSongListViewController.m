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

@import AFNetworking;
@import SVProgressHUD;
#import <UMMobClick/MobClick.h>
@import Masonry;

#import <AVOSCloud/AVOSCloud.h>

@interface MFSongListViewController ()

@end

@implementation MFSongListViewController

- (NSMutableArray *)composedSongs {
    NSError *error = nil;
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    _composedSongs = [[NSMutableArray alloc] initWithCapacity:100];
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:delegate.composedDir error:&error]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[delegate.composedDir stringByAppendingPathComponent:file] error:nil];

        NSMutableDictionary *song = [[NSMutableDictionary alloc] initWithDictionary:
                                     @{@"name": [[file stringByDeletingPathExtension] stringByDeletingPathExtension],
                                       @"path": file,
                                       @"isComposed": @YES,
                                       @"mtime": [attributes fileModificationDate]}];
        //        [song setObject:[attributes fileCreationDate] forKey:@"createdAt"];
        [_composedSongs addObject:song];
        [_composedSongs sortUsingComparator:^NSComparisonResult(id a, id b) {
            return [b[@"mtime"] compare:a[@"mtime"]];
        }];
    }
    return _composedSongs;
}

/*
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

            NSString *filename = [[file stringByDeletingPathExtension] stringByDeletingPathExtension];

            AVObject *song = [AVObject objectWithClassName:@"Song"];
            [song setObject:[filename componentsSeparatedByString:@"_"][0] forKey:@"name"];
            [song setObject:file forKey:@"path"];
            [song setObject:[attributes fileModificationDate] forKey:@"mtime"];
            [array addObject:song];
//  @{@"name": [[file stringByDeletingPathExtension] stringByDeletingPathExtension],
//                               @"path": file,
//                               @"mtime": [attributes fileModificationDate],
//                               @"dateType": @1}];
        [array sortUsingComparator:^NSComparisonResult(id a, id b) {
            return [b[@"mtime"] compare:a[@"mtime"]];
        }];

        dataArray = @[self.composedSongs, array];
        cellId = @"cellId";
        block = ^(MFSongListTableViewCell *cell, AVObject *item, NSIndexPath *indexPath) {
        };
        _arrayDataSource = [[MFArrayDataSource alloc] initWithItems:dataArray cellIdentifier:cellId configureCellBlock:block];
    }
    return _arrayDataSource;
}
*/

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
    vc.songInfo = [self.mViewModel itemForRowAtIndexPath:indexPath];
    vc.title = vc.songInfo[@"name"];
    if (indexPath.section == 0) {
        vc.songInfo[@"isComposed"] = @YES;
    } else {
        vc.songInfo[@"isComposed"] = @NO;
    }
    if ([vc.songInfo[@"isComposed"] boolValue]) {
        [vc setEditableTitle:vc.songInfo[@"name"]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshData {
    [SVProgressHUD show];
    /*
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
    [query whereKeyExists:@"author"];
    [query orderByDescending:@"mtime"];
    query.limit = 1000;
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
        if (error != nil) {
            return;
        }
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        self.mViewModel = [[WAViewModel alloc] initWithArray:@[self.composedSongs, objects]];
        self.mViewModel.sectionTitleList = [NSMutableArray arrayWithArray:@[@"我创作的", @"大家创作的"]];
        [self.mTableView reloadData];
    }];
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
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        vc.songInfo = [self.mViewModel itemForRowAtIndexPath:indexPath];
        [vc setEditableTitle:[[[self.mViewModel itemForRowAtIndexPath:indexPath][@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension]];
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
//    self.UMPageName = NSLocalizedString(@"Songs", nil);

//    self.title = NSLocalizedString(@"Songs", nil);
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"最热"]];
    segmentedControl.selectedSegmentIndex = 0;
    CGRect frame = segmentedControl.frame;
    frame.size.width = 140;
    segmentedControl.frame = frame;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(leftBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];

//    self.mTableView.dataSource = self.arrayDataSource;
    [self.mTableView registerClass:[MFSongListTableViewCell class] forCellReuseIdentifier:@"cellId"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    AVObject *item = [self.mViewModel itemForRowAtIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d", indexPath.section+1, indexPath.row+1];
//    [cell.mImageView setImageWithURL:[NSURL URLWithString:item[@"img_url"]] placeholderImage:nil];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        [cell showCount:NO];
    } else {
        [cell showCount:YES];
    }
    [cell configWithItem:item];
    //                cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    //                if ([[item[@"mtime"] class] isSubclassOfClass:[NSDate class]]) {
    ////                    NSDateFormatter *gmtFormatter=[[NSDateFormatter alloc] init];
    ////                    [gmtFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss VVVV"];
    ////                    NSDate *d = [gmtFormatter dateFromString:item[@"mtime"]];
    //                    cell.detailTextLabel.text = [self humanableInfoFromDate:item[@"mtime"]];
    //                } else {
    //                    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    //                    [date setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    //                    NSDate *d = [date dateFromString:item[@"mtime"]];
    //                    cell.detailTextLabel.text = [self humanableInfoFromDate:d];
    //                }
    //            }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    NSString *author = [AVUser currentUser].username;
    if ([[[self.mViewModel itemForRowAtIndexPath:indexPath] objectForKey:@"author"] isEqualToString:author]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.mViewModel itemForRowAtIndexPath:indexPath];
    
    MFAppDelegate *delegate = (MFAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.section == 0) {
        [[NSFileManager defaultManager] removeItemAtPath:[delegate.composedDir stringByAppendingPathComponent:item[@"path"]] error:nil];
    } else {
        [[item objectForKey:@"contentFile"] deleteInBackground];
        [item deleteInBackground];
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.mViewModel removeItemAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)segmentedControlValueChangedAction:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.mViewModel.indexPathDataList[1] = [self.mViewModel.indexPathDataList[1] sortedArrayUsingComparator:^NSComparisonResult(AVObject *obj1, AVObject *obj2) {
            if (obj1[@"mtime"] == NULL) {
                return NSOrderedAscending;
            }
            if (obj2[@"mtime"] == NULL) {
                return NSOrderedDescending;
            }
            return [obj2[@"mtime"] compare:obj1[@"mtime"]];
        }];
    } else {
        self.mViewModel.indexPathDataList[1] = [self.mViewModel.indexPathDataList[1] sortedArrayUsingComparator:^NSComparisonResult(AVObject *obj1, AVObject *obj2) {
            NSNumber *f1 = obj1[@"finishCount"];
            if (f1 == nil) {
                f1 = @0;
            }
            NSNumber *f2 = obj2[@"finishCount"];
            if (f2 == nil) {
                f2 = @0;
            }
            return [f2 compare:f1];
        }];
    }
    [self.mTableView reloadData];
    [self.mTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
@end
