//
//  MFSongListViewController.h
//  MusicFeeling
//
//  Created by amoblin on 14-3-26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFBaseViewController.h"
#import "MFArrayDataSource.h"

@interface MFSongListViewController : MFBaseViewController<UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *songsInfo;
@property (strong, nonatomic) NSMutableArray *composedSongs;
@property (strong, nonatomic) MFArrayDataSource *arrayDataSource;
@end
