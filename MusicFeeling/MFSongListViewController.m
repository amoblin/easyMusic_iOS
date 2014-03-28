//
//  MFSongListViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFSongListViewController.h"
#import "MFPlayViewController.h"
#import <AFNetworking.h>

@interface MFSongListViewController ()

@end

@implementation MFSongListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getContents {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"https://api.github.com/repos/amoblin/k2k/contents/";
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:100];
        for (NSDictionary *item in responseObject) {
            if ([[[item[@"name"] stringByDeletingPathExtension] pathExtension] isEqualToString:@"k2k"]) {
                [array addObject:item];
            }
        }
        self.songsInfo = [NSArray arrayWithArray:array];
        [self.tableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songsInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.text = [[self.songsInfo[indexPath.row][@"name"] stringByDeletingPathExtension] stringByDeletingPathExtension];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MFPlayViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    vc.songInfo = self.songsInfo[indexPath.row];
}

@end
