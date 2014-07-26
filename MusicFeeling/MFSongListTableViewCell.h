//
//  MFSongListTableViewCell.h
//  MusicFeeling
//
//  Created by amoblin on 14/7/26.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVObject;
@interface MFSongListTableViewCell : UITableViewCell

- (void)configWithItem:(AVObject *)item;
- (void)showCount:(BOOL)flag;
@end
