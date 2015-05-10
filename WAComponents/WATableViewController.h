//
//  WATableViewController.h
//  ShuDongPo
//
//  Created by amoblin on 15/3/11.
//  Copyright (c) 2015年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAViewModel.h"

@interface WATableViewController : UIViewController

@property (strong, nonatomic) WAViewModel *mViewModel;
@property (strong, nonatomic) UITableView *mTableView;
@property (nonatomic) BOOL shouldRefresh;

- (void)refreshData;
- (void)fetchDataWithConfig:(NSDictionary *)conf;
- (void)fetchDataWithConfig:(NSDictionary *)conf andCallback:(void (^)(id result))callback;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)layoutTableView;
@end
