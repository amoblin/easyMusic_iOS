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
#import "WATableViewController.h"

@interface MFSongListViewController : WATableViewController

@property (strong, nonatomic) NSMutableArray *composedSongs;
//@property (strong, nonatomic) MFArrayDataSource *arrayDataSource;
@end
