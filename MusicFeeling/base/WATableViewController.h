//
//  WATableViewController.h
//  marboo.io
//
//  Created by amoblin on 15/3/11.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAViewModel.h"

@interface WATableViewController : UIViewController

@property (strong, nonatomic) NSString *cellId;
@property (nonatomic) CGFloat defaultHeight;
@property (strong, nonatomic) WAViewModel *mViewModel;
@property (strong, nonatomic) UITableView *mTableView;
@property (nonatomic) BOOL shouldRefresh;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (void)refreshData;
- (void)fetchDataWithConfig:(NSDictionary *)conf;
- (void)fetchDataWithConfig:(NSDictionary *)conf andCallback:(void (^)(id result))callback;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
@end
